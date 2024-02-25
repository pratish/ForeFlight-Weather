//
//  WeatherDetail.swift
//  ForeFlight Weather
//
//  Created by Pratish Karmacharya on 2/23/24.
//

import Foundation
import SwiftUI
import Persistance

struct WeatherDetail: View {
    @State private var currentSelection = 0
    @State private var updateFrequency = "5"
      
    let weatherRepo = WeatherRepositoryImpl()
    var airport: AirportModel
    let updater = PeriodicUpdater()
    
    var body: some View {
        VStack {
            HStack {
                Text ("Update Frequency")
                Spacer()
                TextField("", text: $updateFrequency)
                    .keyboardType(.numberPad)
                    .padding(8)
                    .onSubmit {
                        let interval = Int(updateFrequency) ?? 10
                        updater.updateTimer(newTimer: interval)
                    }
                Text(updater.lastUpdatedTime, format: .dateTime.hour().minute().second())
            }
            Picker(airport.identifier, selection: $currentSelection) {
                Text("Condition").tag(0)
                Text("Forecast").tag(1)
            }
            .pickerStyle(.segmented)
            if (currentSelection == 0) {
                if let conditions = weather?.conditions {
                    ConditionView(condition: conditions)
                }
            } else {
                if let forecast = weather?.forecast {
                    ForecastView(forecast: forecast)
                }
            }
            Spacer()
        }
        .task() {
            updater.setAirport(airport)
        }
        .onDisappear {
            updater.stop()
        }
    }
    
    var weather: WeatherModel? { updater.weather ?? airport.weather }
    
    @ViewBuilder
    func ConditionView(condition: ConditionModel) -> some View {
        List {
            Section("Airport Info") {
                condition.ident?.toRowView("Airport Identifier")
                condition.elevationFt.description.toRowView("Elevation (ft)")
                condition.lat.description.toRowView("Latitude")
                condition.lon.description.toRowView("Longitude")
                condition.flightRules?.toRowView("Flight Rules")
                condition.text?.toRowView("")
            }
            Section("Weather") {
                condition.dateIssued?.formatted().toRowView("Date Issued")
                condition.tempC.description.toRowView("Temp (C)")
                condition.dewpointC.description.toRowView("Dew Point")
                condition.pressureHg.description.toRowView("Pressure (hg)")
                condition.pressureHpa.description.toRowView("Pressure (Hpa")
            }
            Section("Wind") {
                condition.wind?.direction.description.toRowView("Direction")
                condition.wind?.from.description.toRowView("From")
                condition.wind?.speedKts.description.toRowView("Speed (kts)")
                condition.wind?.variable.description.toRowView("Variable")
            }
        }
    }
    
    @ViewBuilder
    func ForecastView(forecast: ForecastModel) -> some View {
        List {
            forecast.text?.toRowView("")
            forecast.dateIssued?.formatted().toRowView("Date Issued")
            forecast.elevationFt.description.toRowView("Elevation (Ft)")
            if let conditions = forecast.conditions {
                List(conditions, id: \.dateIssued) {
                    ConditionView(condition: $0)
                }
            }
        }
    }
}

extension String? {
    @ViewBuilder
    func toRowView(_ title: String) -> some View {
        if let content = self { content.toRowView(title) }
    }
}

extension String {
    @ViewBuilder
    func toRowView(_ title: String) -> some View {
        RowView(title, self)
    }
    
    @ViewBuilder
    func RowView(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
        }
    }
}
