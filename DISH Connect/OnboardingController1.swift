//
//  OnboardingController1.swift
//  DISH Connect
//
//  Created by JJ Zapata on 4/5/21.
//

import UIKit

class OnboardingController1: UIViewController {
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    // MARK: - View Objects
    
    let onboardingImage : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.image = UIImage(named: "image-1")!
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let mainButton : MainButton = {
        let button = MainButton(title: "Next")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(mainButtonPressed), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let descriptionLabel : UILabel = {
        let label = UILabel()
        label.text = "Manage and edit your menu in real time! Dish makes it easy for business owners to update their menu with minimal work."
        label.numberOfLines = 5
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor(named: "secondaryText")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Manage Your Menu"
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor(named: "mainTextColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageViewArea : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "secondaryBackground")!
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - Overriden Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        updateViewConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        constraints()
    }
    
    // MARK: - Private Functions
    
    private func constraints() {
        view.addSubview(mainButton)
        mainButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        mainButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        mainButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -97).isActive = true
        
        view.addSubview(descriptionLabel)
        descriptionLabel.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: -51).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 102).isActive = true
        
        view.addSubview(titleLabel)
        titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -5).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        view.addSubview(imageViewArea)
        imageViewArea.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -43).isActive = true
        imageViewArea.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imageViewArea.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        imageViewArea.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        imageViewArea.addSubview(onboardingImage)
        onboardingImage.widthAnchor.constraint(equalToConstant: view.frame.size.width - 50).isActive = true
        onboardingImage.heightAnchor.constraint(equalToConstant: view.frame.size.height - 100).isActive = true
        onboardingImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        onboardingImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    // MARK: - Objective-C Functions
    
    @objc func mainButtonPressed() {
        navigationController?.pushViewController(OnboardingController2(), animated: true)
    }

}
