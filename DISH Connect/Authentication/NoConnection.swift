//
//  NoConnection.swift
//  DISH Connect
//
//  Created by JJ Zapata on 8/9/21.
//

import Foundation
import UIKit

class NoConnection: UIViewController {
    
    // MARK: - View Objects
    
    let signInLogo : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "landingPageLogo")!
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let noInternetTitle : UILabel = {
        let label = UILabel()
        label.text = "Limited to No Connection"
        label.alpha = 0
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        print("here")
        
        constraints()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    private func constraints() {
        view.addSubview(signInLogo)
        signInLogo.heightAnchor.constraint(equalToConstant: 93).isActive = true
        signInLogo.widthAnchor.constraint(equalToConstant: 93).isActive = true
        signInLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200).isActive = true
        signInLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        animations()
    }
    
    private func animations() {
        UIView.animate(withDuration: 1, delay: 1) {
            self.signInLogo.frame.origin.y -= 200
        } completion: { yMinus in
            if yMinus {
                self.view.addSubview(self.noInternetTitle)
                self.noInternetTitle.topAnchor.constraint(equalTo: self.signInLogo.bottomAnchor, constant: 20).isActive = true
                self.noInternetTitle.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
                self.noInternetTitle.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
                self.noInternetTitle.heightAnchor.constraint(equalToConstant: 55).isActive = true
                UIView.animate(withDuration: 0.5) {
                    self.noInternetTitle.alpha = 1
                } completion: { titleFade in
                    if titleFade {
                        print("done with animations")
                    }
                }

            }
        }

    }

}
