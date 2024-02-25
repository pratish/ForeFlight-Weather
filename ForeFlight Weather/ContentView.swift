//
//  ContentView.swift
//  ForeFlight Weather
//
//  Created by Pratish Karmacharya on 2/23/24.
//

import SwiftUI
import CoreData
import WeatherAPI
import Persistance

struct ContentView: View {

    let weatherRepository: WeatherRepository
    
    @Environment(\.managedObjectContext) private var viewContext

    @State var searchText: String = ""
    
    @State var airports: [AirportModel] = []
    
    init() {
        weatherRepository = WeatherRepositoryImpl()
        airports = weatherRepository.airports
        weatherRepository.getAllAirport()
    }
    
    var searchResults: [AirportModel] {
        if searchText.isEmpty {
            return weatherRepository.airports
        } else {
            return weatherRepository.airports.filter { $0.identifier.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationSplitView {
            List(searchResults, id: \.identifier) { airport in
                NavigationLink {
                    WeatherDetail(airport: airport)
                        .onAppear {
                            searchText = ""
                        }
                } label: {
                    Text(airport.identifier)
                }
            }
            .searchable(text: $searchText)
            .onSubmit(of: .search) {
                getWeather()
            }
            .overlay {
                if searchResults.isEmpty {
                    ContentUnavailableView("No airport found with identifier: \(searchText)", image: "")
                }
            }
            
        } detail: {
            Text("Select an airport first")
        }
    }
    
    private func getWeather() {
        Task {
            await weatherRepository.getWeather(identifier: searchText)
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
