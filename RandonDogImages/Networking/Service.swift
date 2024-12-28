//
//  Service.swift
//  RandonDogImages
//
//  Created by Andrew Vale on 25/12/24.
//
import Foundation

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError
}

class Service {
    func fetchImage() async throws -> String {
        
        // defines the API url
        let urlString = "https://dog.ceo/api/breeds/image/random"
        
        // verify if it's a valid URL
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        // Open a session to get data and response
        let (data, response) = try await URLSession.shared.data(from: url)
        // check if response is success
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        //decode data into our Model DogImage
        do {
            let decodedResponse = try JSONDecoder().decode(DogImage.self, from: data)
            return decodedResponse.message
        } catch {
            throw APIError.decodingError
        }
    }
}
