//
//  NetworkManager.swift
//  Jobs
//
//  Created by Rui Silva on 03/04/2024.
//

import Foundation

public protocol NetworkManaging {
    func fetchLogos(query: String) async throws -> [CompanyInfo]
    func fetchOnlineJobs(query: String) async throws -> OnlineJobsResults
}

public class NetworkManager: NetworkManaging {
    
    public func fetchLogos(query: String) async throws -> [CompanyInfo] {
        let host = "https://autocomplete.clearbit.com/v1/companies/suggest?query=:"
        let url = host.appending(query)
        
        guard let url = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decodedData = try JSONDecoder().decode([CompanyInfo].self, from: data)
            return decodedData
        } catch {
            throw NetworkError.invalidData
        }
    }
    
    public func fetchOnlineJobs(query: String) async throws -> OnlineJobsResults {
        let host = "https://api.apijobs.dev/v1/job/search"
        
        guard let url = URL(string: host) else {
            throw NetworkError.invalidURL
        }
        
        let apiKey = "apiKey"
        let contentType = "application/json"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(apiKey, forHTTPHeaderField: "apiKey")
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = ["q": query]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            throw NetworkError.invalidRequest
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodeData = try JSONDecoder().decode(OnlineJobsResults.self, from: data)
            
            print(decodeData)
            return decodeData
        } catch {
            throw NetworkError.invalidData
        }
    }
}
