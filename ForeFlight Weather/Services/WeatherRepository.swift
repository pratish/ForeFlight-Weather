//
//  WeatherRepository.swift
//  ForeFlight Weather
//
//  Created by Pratish Karmacharya on 2/23/24.
//

import Foundation
import Persistance
import WeatherAPI
import CoreData
import SwiftUI

///
/// Manages how and where you get weather data
///
protocol WeatherRepository {
    ///
    /// List of locally available airports
    ///
    var airports: [AirportModel] {get}
    
    ///
    /// Retrieves list of all airport from database
    func getAllAirport()
    
    ///
    /// Gets the weather for the given identifier
    func getWeather(identifier: String) async -> WeatherModel?
}

@Observable
class WeatherRepositoryImpl: WeatherRepository  {

    private let requestProvider: WeatherAPIRequestProvider = WeatherAPIRequestProvider()
    private let apiClient = WeatherAPIClient()
    
    var airports: [AirportModel] = []
    
    private let persistence: LocalStorageManager = LocalStorageManager.shared
    private let managedContext = LocalStorageManager.shared.viewContext
    
    func getAllAirport() {
        let allAirports = try? persistence.viewContext.fetch(NSFetchRequest(entityName: "AirportEntity"))
        airports = (allAirports?.map({
            let airport = $0 as! AirportEntity
            var airportModel = AirportModel(identifier: airport.identifier!)
            airportModel.weather = airport.weather?.toWeatherModel()
            return airportModel
        }))!
    }
    
    func getWeather(identifier: String) async -> WeatherModel? {
        print("Getting weather for \(identifier)")
        let urlRequest = requestProvider.getAirportWeather(with: identifier)
        var weather: WeatherModel? = nil
        try? await apiClient.enque(request: urlRequest) {[weak viewContext = managedContext] (result: Result<WeatherReport, WeatherAPIClient.APIError>) in
            switch result {
            case .success(let report):
                if let viewContext = viewContext {
                    if let identity = report.report.conditions?.ident {
                        let airportEntity = self.saveNewWeatherReport(identifier: identifier, report: report.report)
                        weather = airportEntity?.weather?.toWeatherModel()
                    }
                }
            case .failure(let error): print(error)
            }
        }
        return weather
    }
    
    // MARK: Private Helper Function
    private func getAirportWeather(identifier: String) {
        Task {
            // Check local weather data first.
            let identifierPredicate = NSPredicate(format: "identifier LIKE %@", identifier)
            let airportRequest = AirportEntity.fetchRequest()
            airportRequest.predicate = identifierPredicate
            let airportEntities: [NSFetchRequestResult]
            do {
                airportEntities = try managedContext.fetch(airportRequest)
                if let airportEntity = airportEntities.first, let airportEntity = airportEntity as? AirportEntity {
                    if airportEntity.weather != nil {
                        var airportModel = AirportModel(identifier: airportEntity.identifier!)
                        airportModel.weather = airportEntity.weather?.toWeatherModel()
                        airports.append(airportModel)
                    } else {
                        // fetch weather
                            var airportModel = AirportModel(identifier: airportEntity.identifier!)
                            let weatherModel = await getWeather(identifier: identifier)
                            airportModel.weather = weatherModel
                            airports.append(airportModel)
                    }
                } else {
                    // if local weather data not found, get from cloud
                    let weatherModel = await getWeather(identifier: identifier)
                    var airportModel = AirportModel(identifier: identifier, weather: weatherModel)
                    airports.append(airportModel)
                }
            } catch {
                print(error)
            }
        }
    }
    
    private func saveNewWeatherReport(identifier: String, report: Report) -> AirportEntity? {
        var newAirportEntity: AirportEntity? = nil
        managedContext.performAndWait { [self] in
            let identifierPredicate = NSPredicate(format: "identifier LIKE %@", identifier)
            let airportRequest = AirportEntity.fetchRequest()
            airportRequest.predicate = identifierPredicate
            let airportEntities: [NSFetchRequestResult]
            do {
                airportEntities = try self.managedContext.fetch(airportRequest)
                if let airportEntity = airportEntities.first, let airportEntity = airportEntity as? AirportEntity {
                    newAirportEntity = airportEntity
                } else {
                    newAirportEntity = AirportEntity(context: managedContext)
                    newAirportEntity?.identifier = report.conditions?.ident
                }
                
                let weatherEntity = WeatherReportEntity(context: managedContext)
                
                if let conditions = report.conditions {
                    let conditionsEntity = ConditionsEntity(context: managedContext)
                    conditionsEntity.text = conditions.text
                    conditionsEntity.densityAltitudeFt = Int32(conditions.densityAltitudeFt ?? 0)
                    conditionsEntity.dewpointC = Int16(conditions.dewpointC ?? 0)
                    conditionsEntity.elevationFt = conditions.elevationFt ?? 0
                    conditionsEntity.flightRules = conditions.flightRules
                    conditionsEntity.ident = conditions.ident
                    conditionsEntity.lat = conditions.lat ?? 0
                    conditionsEntity.lon = conditions.lon ?? 0
                    conditionsEntity.pressureHg = conditions.pressureHg ?? 0
                    conditionsEntity.tempC = Int16(conditions.tempC ?? 0)
                    if let visibility = conditions.visibility {
                        var visibilityEntity = VisibilityEntity(context: managedContext)
                        visibilityEntity.distanceSm = visibility.distanceSm ?? 0
                        visibilityEntity.prevailingVisSm = visibility.prevailingVisSm ?? 0
                        conditionsEntity.visibility = visibilityEntity
                    }
                    
                    if let wind = conditions.wind {
                        var windEntity = WindEntity(context: managedContext)
                        windEntity.direction = Int16(wind.direction ?? 0)
                        windEntity.from = Int16(wind.from ?? 0)
                        windEntity.speedKts = wind.speedKts ?? 0
                        windEntity.variable = wind.variable ?? false
                        conditionsEntity.wind = windEntity
                    }
                    conditionsEntity.dateIssued = conditions.dateIssued?.toDate()
                    weatherEntity.setValue(conditionsEntity, forKey: #keyPath(WeatherReportEntity.conditions))
                }
                
                if let forecast = report.forecast {
                    let forecastEntity = ForecastEntity(context: managedContext)
                    forecastEntity.lat = forecast.lat ?? 0.0
                    forecastEntity.text = forecast.text
                    weatherEntity.setValue(forecastEntity, forKey: #keyPath(WeatherReportEntity.forecast))
                }
                newAirportEntity?.setValue(weatherEntity, forKey: #keyPath(AirportEntity.weather))
                
                do {
                    try managedContext.save()
                } catch {
                    print(error)
                }
            } catch {
                
            }
        }
        return newAirportEntity
    }
}

// MARK: Extensions
/// Extension function to convert coredata models into client usable models
extension WeatherReportEntity {
    func toWeatherModel() -> WeatherModel {
        var weatherModel = WeatherModel(conditions: nil, forecast: nil)
        if let conditions = self.conditions {
            weatherModel.conditions = conditions.toConditionModel()
        }
        
        if let forecast = self.forecast {
            let conditions = forecast.conditions?.allObjects.map({ condition in
                (condition as! ConditionsEntity).toConditionModel()
            })
            let forecastModel = ForecastModel(text: forecast.text, conditions: conditions)
            weatherModel.forecast = forecastModel
        }
        return weatherModel
    }
}

extension ConditionsEntity {
    func toConditionModel() -> ConditionModel {
        return ConditionModel(
            text: self.text,
            dateIssued: self.dateIssued,
            densityAltitudeFt: self.densityAltitudeFt,
            dewpointC: self.dewpointC,
            elevationFt: self.elevationFt,
            flightRules: self.flightRules,
            ident: self.ident,
            lat: self.lat,
            lon: self.lon,
            pressureHg: self.pressureHg,
            pressureHpa: self.pressureHpa,
            relativeHumidity: self.relativeHumidity,
            reportedAsHpa: self.reportedAsHpa,
            tempC: self.tempC,
            weather: self.weather,
            cloudLayer: [],
            cloudLayerV2: [],
            visibility: VisibilityModel(distanceSm: self.visibility?.distanceSm ?? 0, prevailingVisSm: self.visibility?.prevailingVisSm ?? 0),
            wind: WindModel(direction: self.wind?.direction ?? 0, from: self.wind?.from ?? 0, speedKts: self.wind?.speedKts ?? 0, variable: self.wind?.variable ?? false)
        )
    }
}

private extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-ddThh:MM:ss+0000"
        return dateFormatter.date(from: self)
    }
}

// MARK: Client Models
/// Client usable models
struct AirportModel {
    var identifier: String
    var weather: WeatherModel? = nil
}

struct WeatherModel {
    var conditions: ConditionModel?
    var forecast: ForecastModel?
}

struct ConditionModel {
    let text: String?
    let dateIssued: Date?
    let densityAltitudeFt: Int32
    let dewpointC: Int16
    let elevationFt: Int32
    let flightRules: String?
    let ident: String?
    let lat: Double
    let lon: Double
    let pressureHg: Double
    let pressureHpa: Double
    let relativeHumidity: Int16
    let reportedAsHpa: Bool
    let tempC: Int16
    let weather: String?
    let cloudLayer: [CloudModel]?
    let cloudLayerV2: [CloudModel]?
    let visibility: VisibilityModel?
    let wind: WindModel?
}

struct CloudModel {
    let altitudeFt: Int32
    let ceiling: Bool
    let coverage: String?
}

struct VisibilityModel {
    let distanceSm: Double
    let prevailingVisSm: Double
}

struct WindModel {
    let direction: Int16
    let from: Int16
    let speedKts: Double
    let variable: Bool
}

struct ForecastModel {
    let dateIssued: Date? = nil
    let elevationFt: Int32 = 0
    let ident: String? = nil
    let lat: Double = 0
    let lon: Double = 0
    let text: String?
    let conditions: [ConditionModel]?
}
