//
//  NetworkManager.swift
//  Jobs
//
//  Created by Rui Silva on 03/04/2024.
//

import Foundation
import Factory

protocol NetworkManaging {
    func fetchLogos(query: String) async throws -> [CompanyInfo]
    func fetchAPIKey() async throws -> String
    func fetchAccessToken() async throws -> String
}

class NetworkManager: NetworkManaging {
    
    @Injected(\.keychainManager) var keychainManager
    
    let baseURLString = "http://localhost:8080"
    
    func fetchLogos(query: String) async throws -> [CompanyInfo] {
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
    
    func fetchAccessToken() async throws -> String {
        
        let accessTokenURL = "/get-access-token"
        let url = baseURLString.appending(accessTokenURL)
        
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        guard let token = String(data: data, encoding: .utf8) else {
            throw URLError(.cannotDecodeRawData)
        }
        
        return token.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func fetchAPIKey() async throws -> String {
        
        let accessToken = keychainManager.getToken() ?? "No token stored"
        
        let apiKeyURL = "/get-api-key"
        let url = baseURLString.appending(apiKeyURL)
        
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode != 200 {
                let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                throw URLError(.badServerResponse, userInfo: ["Server Response": errorMessage])
            }
        }
        
        guard let apiKey = String(data: data, encoding: .utf8) else {
            throw URLError(.cannotDecodeRawData)
        }

        return apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
