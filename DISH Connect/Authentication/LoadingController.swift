//
//  LoadingController.swift
//  DISH Connect
//
//  Created by JJ Zapata on 5/19/21.
//

import UIKit
import Firebase
import MBProgressHUD

class LoadingController: UIViewController {
    
    // MARK: - View Objects
    
    let signInLogo : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "roundedIcon")!
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let progressVirew : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.style = .medium
        spinner.isHidden = false
        return spinner
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        view.addSubview(signInLogo)
        signInLogo.heightAnchor.constraint(equalToConstant: 93).isActive = true
        signInLogo.widthAnchor.constraint(equalToConstant: 93).isActive = true
        signInLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        signInLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(progressVirew)
        progressVirew.heightAnchor.constraint(equalToConstant: 70).isActive = true
        progressVirew.widthAnchor.constraint(equalToConstant: 70).isActive = true
        progressVirew.topAnchor.constraint(equalTo: signInLogo.bottomAnchor, constant: 35).isActive = true
        progressVirew.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        autoSignIn()
    }
    
    // MARK: - Private Functions
    
    private func autoSignIn() {
        progressVirew.startAnimating()
        if let _ = Auth.auth().currentUser {
            print("active firebase user")
            goToTabBar()
        } else {
            print("nil firebase user")
            goToSignIn()
        }
    }
    
    private func goToSignIn() {
        let controller = SignInController()
        controller.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.progressVirew.stopAnimating()
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    private func goToTabBar() {
        let controller = TabBarController()
        controller.getAppId()
        controller.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.progressVirew.stopAnimating()
            self.present(controller, animated: true, completion: nil)
        }
    }

}
