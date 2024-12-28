//
//  DogImageVM.swift
//  RandonDogImages
//
//  Created by Andrew Vale on 26/12/24.
//
import Foundation

class DogImageVM {
    private let service = Service()
    var imageURL: String?
    var onError: ((String) -> Void)?
    var onImageURLUpdated: (() -> Void)?
    
    func fetchImage () {
        Task {
            do {
                let url = try await service.fetchImage()
                self.imageURL = url
                self.onImageURLUpdated?()
            } catch {
                self.onError?(self.handleError(error))
            }
        }
    }
}

extension DogImageVM {
    func handleError(_ error: Error) -> String {
        guard let apiError = error as? APIError else {
            return "Unknow error: \(error.localizedDescription)"
        }
        
        switch apiError {
        case .decodingError:
            return "Failed to decode data."
        case .invalidResponse:
            return "Invalid Response"
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let networkError):
            return "Error: \(networkError.localizedDescription)"
        }
    }
}
