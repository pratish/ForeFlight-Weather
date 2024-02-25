//
//  PeriodicUpdater.swift
//  ForeFlight Weather
//
//  Created by Pratish Karmacharya on 2/24/24.
//

import Foundation

///
/// Class responsible for fetching latest data at said interval.
///
class PeriodicUpdater: ObservableObject {
    private let repo = WeatherRepositoryImpl()
    @Published var weather: WeatherModel? = nil
    @Published var lastUpdatedTime: Date = Date.now
    private var interval: TimeInterval = TimeInterval(5)
    private var timer: Timer? = nil
    private var identifier: String = ""
    
    init() {
        
    }
    
    func updateTimer(newTimer: Int) {
        interval = TimeInterval(newTimer)
        update()
    }
    
    private func update() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [self] _ in
            lastUpdatedTime = Date.now
            Task {
                weather = await self.repo.getWeather(identifier: identifier)
            }
        }
        timer?.fire()
    }
    
    func setAirport(_ airport: AirportModel) {
        self.weather = airport.weather
        self.identifier = airport.identifier
        update()
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }

}
