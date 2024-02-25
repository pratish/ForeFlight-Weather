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
    
    public enum MapperError: Error {
        case codingKeys
    }
    
    private let decoder = JSONDecoder()
    
    public func mapObject<T>(data: Data) throws -> T  {
        do {
            let decodedObject = try decoder.decode(WeatherReport.self, from: data)
            return decodedObject as! T
        } catch {
            print(error)
            throw MapperError.codingKeys
        }
    }
    
    
}


@available(iOS 13.0.0, *)
public class WeatherAPIClient {
    let session = URLSession.shared
    
    public enum APIError: Error {
        case generalError(msg: String)
    }
    
    public init() {
        
    }
    
    public func enque<T: Readable>(request: URLRequest, completion: @escaping (Result<T, APIError>) -> Void) async throws {
        let (data, response) = try await session.data(for: request)
            do {
                let t: T? = try ResponseMapper().mapObject(data: data)
                completion(Result.success(t!))
            } catch {
                completion(Result.failure(APIError.generalError(msg: error.localizedDescription)))
            }
    }
}

