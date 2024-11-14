//
//  NetworkManager.swift
//  Jobs
//
//  Created by Rui Silva on 03/04/2024.
//

import Foundation

public protocol NetworkManaging {
    func fetchData(query: String) async throws -> [CompanyInfo]
}

public struct NetworkManager: NetworkManaging {

    public func fetchData(query: String) async throws -> [CompanyInfo] {
        let imageURL = "https://autocomplete.clearbit.com/v1/companies/suggest?query=:\(query)"

        guard let url = URL(string: imageURL) else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse,
            response.statusCode == 200
        else {
            throw NetworkError.invalidResponse
        }

        let decodedData = try JSONDecoder().decode(
            [CompanyInfo].self, from: data)

        return decodedData
    }
}
