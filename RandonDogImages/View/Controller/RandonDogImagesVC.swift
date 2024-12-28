//
//  ViewController.swift
//  RandonDogImages
//
//  Created by Andrew Vale on 25/12/24.
//

import UIKit

class RandonDogImagesVC: UIViewController {
    private let dogImageVM = DogImageVM()
    
    private let dogImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.shadowColor = UIColor.gray.cgColor
        imageView.layer.shadowOpacity = 0.7
        imageView.layer.shadowRadius = 5
        imageView.layer.masksToBounds = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        configBindings()
        dogImageVM.fetchImage()
    }
    
    //MARK: - Actions
    @objc func viewTapped() {
        dogImageVM.fetchImage()
    }
}

//MARK: - View Setup
extension RandonDogImagesVC {
    func setupViews() {
        view.addSubview(dogImageView)

        NSLayoutConstraint.activate([
            dogImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dogImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            dogImageView.widthAnchor.constraint(equalToConstant: 300),
            dogImageView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        self.view.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        
        self.view.addGestureRecognizer(tapGesture)
    }
}

//MARK: - Bindings
extension RandonDogImagesVC {
    func configBindings() {
        dogImageVM.onImageURLUpdated = { [weak self] in
            guard let dogImageStringURL = self?.dogImageVM.imageURL else { return }
            print("Dog Image: \(dogImageStringURL)")
            if let dogImageURL = URL(string: dogImageStringURL) {
                Task {
                    await self?.dogImageView.loadImage(from: dogImageURL)
                }
            }
        }
        
        dogImageVM.onError = { errorMessage in
            print("Error: \(errorMessage)")
        }
    }
}
