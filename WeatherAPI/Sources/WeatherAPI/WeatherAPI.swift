// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public protocol WeatherAPI {
    func getAirportWeather(with identifier: String) -> URLRequest
}

public class WeatherAPIRequestProvider {
    private let session = URLSession.shared
    public init() {
        
    }
    
    public func getAirportWeather(with identifier: String) -> URLRequest{
        let endpoint = Endpoint.airportWeather(withAirportIdentifier: identifier)
        return getData(for: endpoint)
    }
    
    private func getData(for endpoint: Endpoint) -> URLRequest {
        return buildRequest(for: endpoint)
    }
    
    private func buildRequest(for endpoint: Endpoint) -> URLRequest {
        var request: URLRequest = URLRequest(url: endpoint.url)
        request.addValue("1", forHTTPHeaderField: "ff-coding-exercise")
        return request
    }
}

public struct ResponseMapper {
    private let decoder = JSONDecoder()
    
    public func mapObject<T>(data: Data) -> T? {
        print(data)
        do {
            let decodedObject = try decoder.decode(WeatherReport.self, from: data)
            
            print(decodedObject.report)
            return decodedObject as! T
        } catch {
            print(error)
            return nil
            
        }
    }
    
    
}


public class WeatherAPIClient {
    let session = URLSession.shared
    
    public init() {
        
    }
    
    public func enque<T>(request: URLRequest, completion: @escaping (T) -> Void) {
        let task = session.dataTask(with: request) { data, response, error in
            let stringValue = String(data: data!, encoding: .utf8) as! String
//            print(stringValue)
            let t: T? = ResponseMapper().mapObject(data: data!)
            completion(t!)
        }
        print("tasking...")
        //TODO:  Something else should execute, but immediate execute for now.
        task.resume()
    }
}

