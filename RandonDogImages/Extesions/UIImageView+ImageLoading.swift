//
//  UIImageView+ImageLoading.swift
//  RandonDogImages
//
//  Created by Andrew Vale on 26/12/24.
//
import UIKit

extension UIImageView {
    func loadImage(from url:URL) async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        } catch {
            print("Image loading failed \(error.localizedDescription)")
        }
    }
}

