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
        imageView.image = UIImage(named: "landingPageLogo")!
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(signInLogo)
        signInLogo.heightAnchor.constraint(equalToConstant: 93).isActive = true
        signInLogo.widthAnchor.constraint(equalToConstant: 93).isActive = true
        signInLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        signInLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        autoSignIn()
    }
    
    // MARK: - Private Functions
    
    private func autoSignIn() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
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
            MBProgressHUD.hide(for: self.view, animated: true)
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    private func goToTabBar() {
        let controller = TabBarController()
        controller.getAppId()
        controller.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.present(controller, animated: true, completion: nil)
        }
    }

}
