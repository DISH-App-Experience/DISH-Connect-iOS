//
//  TabBarController.swift
//  DISH Connect
//
//  Created by JJ Zapata on 4/5/21.
//

import UIKit
import Firebase

class TabBarController: UITabBarController {
    
    // MARK: - Constants
    
    let homeController = UINavigationController(rootViewController: HomeController())
    
    let menuController = UINavigationController(rootViewController: MenuController())
    
    let reservationController = UINavigationController(rootViewController: ReservationController())
    
    let actionController = UINavigationController(rootViewController: ActionController())
    
    let settingsController = UINavigationController(rootViewController: SettingsController())
    
    // MARK: - Variables
    
    var appId = ""
    
    var navigationControllers = [UINavigationController]()
    
    // MARK: - Overriden Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tabBar.tintColor = UIColor.mainBlue
        
        hidesBottomBarWhenPushed = true
        
        tabBarCustomization()
        
//        getAppId()
    }
    
    func tabBarCustomization() {
        homeController.tabBarItem.image = UIImage(systemName: "house")
        homeController.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        
        menuController.tabBarItem.image = UIImage(systemName: "book")
        menuController.tabBarItem.selectedImage = UIImage(systemName: "book.fill")
        
        reservationController.tabBarItem.image = UIImage(systemName: "person")
        reservationController.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
        
        actionController.tabBarItem.image = UIImage(systemName: "message")
        actionController.tabBarItem.selectedImage = UIImage(systemName: "message.fill")
        
        settingsController.tabBarItem.image = UIImage(systemName: "gearshape")
        settingsController.tabBarItem.selectedImage = UIImage(systemName: "gearshape.fill")
    }
    
    // MARK: - Functions
    
     func getAppId() {
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("appId").observeSingleEvent(of: .value, with: { (snapshot) in
            if let appId = snapshot.value as? String {
                self.appId = appId
                globalAppId = appId
                self.checkControllers()
            }
        })
    }
    
     func checkControllers() {
        
        navigationControllers.append(homeController)
        
        navigationControllers.append(menuController)
        
        Database.database().reference().child("Apps").child(appId).child("features").child("reservationRequests").observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? Bool {
                if value {
                    self.navigationControllers.append(self.reservationController)
                    self.checkActionController()
                } else {
                    self.checkActionController()
                }
            }
        }
    }
    
     func checkActionController() {
        Database.database().reference().child("Apps").child(appId).child("features").child("newsEvents").observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? Bool {
                if value {
                    self.navigationControllers.append(self.actionController)
                    self.navigationControllers.append(self.settingsController)
                    self.viewControllers = self.navigationControllers
                } else {
                    self.checkAnotherAction()
                }
            }
        }
    }
    
     func checkAnotherAction() {
        Database.database().reference().child("Apps").child(self.appId).child("features").child("sendPromos").observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? Bool {
                if value {
                    self.navigationControllers.append(self.actionController)
                    self.navigationControllers.append(self.settingsController)
                    self.viewControllers = self.navigationControllers
                } else {
                    self.checkAnotherAnotherFunction()
                }
            }
        }
    }
    
     func checkAnotherAnotherFunction() {
        Database.database().reference().child("Apps").child(self.appId).child("features").child("rewardProgram").observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? Bool {
                if value {
                    self.navigationControllers.append(self.actionController)
                    self.navigationControllers.append(self.settingsController)
                    self.viewControllers = self.navigationControllers
                } else {
                    self.navigationControllers.append(self.settingsController)
                    self.viewControllers = self.navigationControllers
                }
            }
        }
    }
    
    
    
    

}
