//
//  Home.swift
//  DISH Connect
//
//  Created by JJ Zapata on 4/5/21.
//

import UIKit
import Firebase
import MBProgressHUD

class HomeController: UIViewController {
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    var users = [Customer]()
    
    // MARK: - View Objects
    
    let squareView1 : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        view.backgroundColor = UIColor(named: "secondaryBackground")!
        return view
    }()
    
    let emoji1 : UILabel = {
        let label = UILabel()
        label.text = "🎨"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    let action1 : UILabel = {
        let label = UILabel()
        label.text = "Customize"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor(named: "placeholderColor")!
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    let theme1 : UILabel = {
        let label = UILabel()
        label.text = "Theme"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.mainBlue
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    let squareView2 : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        view.backgroundColor = UIColor.mainBlue
        return view
    }()
    
    let action2 : UILabel = {
        let label = UILabel()
        label.text = "Total Users"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    let theme2 : UILabel = {
        let label = UILabel()
        label.text = "NUMBER"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    let squareView3 : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        view.backgroundColor = UIColor(named: "secondaryBackground")!
        return view
    }()
    
    let emoji3 : UILabel = {
        let label = UILabel()
        label.text = "📕"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    let action3 : UILabel = {
        let label = UILabel()
        label.text = "Tailor Your"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor(named: "placeholderColor")!
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    let theme3 : UILabel = {
        let label = UILabel()
        label.text = "Menu"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.mainBlue
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    let squareView4 : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        view.backgroundColor = UIColor(named: "secondaryBackground")!
        return view
    }()
    
    let emoji4 : UILabel = {
        let label = UILabel()
        label.text = "📸"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    let action4 : UILabel = {
        let label = UILabel()
        label.text = "Add Your"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor(named: "placeholderColor")!
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    let theme4 : UILabel = {
        let label = UILabel()
        label.text = "Images"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.mainBlue
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    let squareView5 : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        view.backgroundColor = UIColor(named: "secondaryBackground")!
        return view
    }()
    
    let action5 : UILabel = {
        let label = UILabel()
        label.text = "Write Your"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor(named: "placeholderColor")!
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    let theme5 : UILabel = {
        let label = UILabel()
        label.text = "About Us"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.mainBlue
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    let squareView6 : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        view.backgroundColor = UIColor(named: "secondaryBackground")!
        return view
    }()
    
    let emoji6 : UILabel = {
        let label = UILabel()
        label.text = "📍"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    let action6 : UILabel = {
        let label = UILabel()
        label.text = "Add Your"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor(named: "placeholderColor")!
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    let theme6 : UILabel = {
        let label = UILabel()
        label.text = "Location"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.mainBlue
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    let actionButton1 : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonAction1), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let actionButton2 : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonAction2), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let actionButton3 : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonAction3), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let actionButton4 : UIButton = {
        let button = UIButton()
        button.tag = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonAction4), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let actionButton5 : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonAction5), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let actionButton6 : UIButton = {
        let button = UIButton()
        button.tag = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonAction6), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let largeView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Overriden Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(named: "backgroundColor")!
        
        updateViewConstraints()
        totalUsers()
        
        // Notification Implementation
        let pushManager = PushNotificationManager(userID: Auth.auth().currentUser!.uid)
        pushManager.registerForPushNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = UIColor.mainBlue
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.backButtonTitle = "Back"
        
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("name").observeSingleEvent(of: .value) { (snapshot) in
            if let name = snapshot.value as? String {
                self.navigationItem.title = "Hi \(name.components(separatedBy: " ").first!) 👋"
            } else {
                self.navigationItem.title = "Home"
            }
        }
        
        featureUsage()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        constraints()
    }
    
    // MARK: - Private Functions
    
    private func constraints() {
        view.addSubview(squareView1)
        squareView1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        squareView1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        squareView1.widthAnchor.constraint(equalToConstant: (self.view.frame.size.width / 2) - 37.5).isActive = true
        squareView1.heightAnchor.constraint(equalToConstant: (self.view.frame.size.width / 2) - 37.5).isActive = true
        
        squareView1.addSubview(theme1)
        theme1.bottomAnchor.constraint(equalTo: squareView1.bottomAnchor, constant: -15).isActive = true
        theme1.leftAnchor.constraint(equalTo: squareView1.leftAnchor, constant: 12).isActive = true
        theme1.rightAnchor.constraint(equalTo: squareView1.rightAnchor, constant: -12).isActive = true
        theme1.heightAnchor.constraint(equalToConstant: 31).isActive = true
        
        squareView1.addSubview(action1)
        action1.bottomAnchor.constraint(equalTo: theme1.topAnchor, constant: 3).isActive = true
        action1.leftAnchor.constraint(equalTo: squareView1.leftAnchor, constant: 12).isActive = true
        action1.rightAnchor.constraint(equalTo: squareView1.rightAnchor, constant: -12).isActive = true
        action1.heightAnchor.constraint(equalToConstant: 31).isActive = true
        
        squareView1.addSubview(emoji1)
        emoji1.bottomAnchor.constraint(equalTo: action1.topAnchor).isActive = true
        emoji1.leftAnchor.constraint(equalTo: squareView1.leftAnchor, constant: 12).isActive = true
        emoji1.rightAnchor.constraint(equalTo: squareView1.rightAnchor, constant: -12).isActive = true
        emoji1.heightAnchor.constraint(equalToConstant: 31).isActive = true
        
        view.addSubview(squareView2)
        squareView2.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        squareView2.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        squareView2.widthAnchor.constraint(equalToConstant: (self.view.frame.size.width / 2) - 37.5).isActive = true
        squareView2.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        squareView2.addSubview(theme2)
        theme2.bottomAnchor.constraint(equalTo: squareView2.bottomAnchor, constant: -18).isActive = true
        theme2.leftAnchor.constraint(equalTo: squareView2.leftAnchor, constant: 18).isActive = true
        theme2.rightAnchor.constraint(equalTo: squareView2.rightAnchor, constant: -3).isActive = true
        theme2.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        squareView2.addSubview(action2)
        action2.bottomAnchor.constraint(equalTo: theme2.topAnchor, constant: 3).isActive = true
        action2.leftAnchor.constraint(equalTo: squareView2.leftAnchor, constant: 18).isActive = true
        action2.rightAnchor.constraint(equalTo: squareView2.rightAnchor, constant: -3).isActive = true
        action2.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(squareView3)
        squareView3.topAnchor.constraint(equalTo: squareView1.bottomAnchor, constant: 25).isActive = true
        squareView3.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        squareView3.widthAnchor.constraint(equalToConstant: (self.view.frame.size.width / 2) - 37.5).isActive = true
        squareView3.heightAnchor.constraint(equalToConstant: (self.view.frame.size.width / 2) - 37.5).isActive = true
        
        squareView3.addSubview(theme3)
        theme3.bottomAnchor.constraint(equalTo: squareView3.bottomAnchor, constant: -15).isActive = true
        theme3.leftAnchor.constraint(equalTo: squareView3.leftAnchor, constant: 12).isActive = true
        theme3.rightAnchor.constraint(equalTo: squareView3.rightAnchor, constant: -12).isActive = true
        theme3.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        squareView3.addSubview(action3)
        action3.bottomAnchor.constraint(equalTo: theme3.topAnchor, constant: 3).isActive = true
        action3.leftAnchor.constraint(equalTo: squareView3.leftAnchor, constant: 12).isActive = true
        action3.rightAnchor.constraint(equalTo: squareView3.rightAnchor, constant: -12).isActive = true
        action3.heightAnchor.constraint(equalToConstant: 31).isActive = true
        
        squareView3.addSubview(emoji3)
        emoji3.bottomAnchor.constraint(equalTo: action3.topAnchor).isActive = true
        emoji3.leftAnchor.constraint(equalTo: squareView3.leftAnchor, constant: 12).isActive = true
        emoji3.rightAnchor.constraint(equalTo: squareView3.rightAnchor, constant: -12).isActive = true
        emoji3.heightAnchor.constraint(equalToConstant: 31).isActive = true
        
        view.addSubview(squareView4)
        squareView4.topAnchor.constraint(equalTo: squareView2.bottomAnchor, constant: 25).isActive = true
        squareView4.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        squareView4.widthAnchor.constraint(equalToConstant: (self.view.frame.size.width / 2) - 37.5).isActive = true
        squareView4.heightAnchor.constraint(equalToConstant: (self.view.frame.size.width / 2) - 37.5).isActive = true
        
        squareView4.addSubview(theme4)
        theme4.bottomAnchor.constraint(equalTo: squareView4.bottomAnchor, constant: -15).isActive = true
        theme4.leftAnchor.constraint(equalTo: squareView4.leftAnchor, constant: 12).isActive = true
        theme4.rightAnchor.constraint(equalTo: squareView4.rightAnchor, constant: -12).isActive = true
        theme4.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        squareView4.addSubview(action4)
        action4.bottomAnchor.constraint(equalTo: theme4.topAnchor, constant: 3).isActive = true
        action4.leftAnchor.constraint(equalTo: squareView4.leftAnchor, constant: 12).isActive = true
        action4.rightAnchor.constraint(equalTo: squareView4.rightAnchor, constant: -12).isActive = true
        action4.heightAnchor.constraint(equalToConstant: 31).isActive = true
        
        squareView4.addSubview(emoji4)
        emoji4.bottomAnchor.constraint(equalTo: action4.topAnchor).isActive = true
        emoji4.leftAnchor.constraint(equalTo: squareView4.leftAnchor, constant: 12).isActive = true
        emoji4.rightAnchor.constraint(equalTo: squareView4.rightAnchor, constant: -12).isActive = true
        emoji4.heightAnchor.constraint(equalToConstant: 31).isActive = true
        
        view.addSubview(squareView5)
        squareView5.topAnchor.constraint(equalTo: squareView3.bottomAnchor, constant: 25).isActive = true
        squareView5.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        squareView5.widthAnchor.constraint(equalToConstant: (self.view.frame.size.width / 2) - 37.5).isActive = true
        squareView5.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        squareView5.addSubview(theme5)
        theme5.bottomAnchor.constraint(equalTo: squareView5.bottomAnchor, constant: -18).isActive = true
        theme5.leftAnchor.constraint(equalTo: squareView5.leftAnchor, constant: 18).isActive = true
        theme5.rightAnchor.constraint(equalTo: squareView5.rightAnchor, constant: -3).isActive = true
        theme5.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        squareView5.addSubview(action5)
        action5.bottomAnchor.constraint(equalTo: theme5.topAnchor, constant: 3).isActive = true
        action5.leftAnchor.constraint(equalTo: squareView5.leftAnchor, constant: 18).isActive = true
        action5.rightAnchor.constraint(equalTo: squareView5.rightAnchor, constant: -3).isActive = true
        action5.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(squareView6)
        squareView6.topAnchor.constraint(equalTo: squareView4.bottomAnchor, constant: 25).isActive = true
        squareView6.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        squareView6.widthAnchor.constraint(equalToConstant: (self.view.frame.size.width / 2) - 37.5).isActive = true
        squareView6.heightAnchor.constraint(equalToConstant: (self.view.frame.size.width / 2) - 37.5).isActive = true
        
        squareView6.addSubview(theme6)
        theme6.bottomAnchor.constraint(equalTo: squareView6.bottomAnchor, constant: -15).isActive = true
        theme6.leftAnchor.constraint(equalTo: squareView6.leftAnchor, constant: 12).isActive = true
        theme6.rightAnchor.constraint(equalTo: squareView6.rightAnchor, constant: -12).isActive = true
        theme6.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        squareView6.addSubview(action6)
        action6.bottomAnchor.constraint(equalTo: theme6.topAnchor, constant: 3).isActive = true
        action6.leftAnchor.constraint(equalTo: squareView6.leftAnchor, constant: 12).isActive = true
        action6.rightAnchor.constraint(equalTo: squareView6.rightAnchor, constant: -12).isActive = true
        action6.heightAnchor.constraint(equalToConstant: 31).isActive = true
        
        squareView6.addSubview(emoji6)
        emoji6.bottomAnchor.constraint(equalTo: action6.topAnchor).isActive = true
        emoji6.leftAnchor.constraint(equalTo: squareView6.leftAnchor, constant: 12).isActive = true
        emoji6.rightAnchor.constraint(equalTo: squareView6.rightAnchor, constant: -12).isActive = true
        emoji6.heightAnchor.constraint(equalToConstant: 31).isActive = true
        
        view.addSubview(largeView)
        largeView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        largeView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        largeView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        largeView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(actionButton1)
        actionButton1.topAnchor.constraint(equalTo: squareView1.topAnchor).isActive = true
        actionButton1.leftAnchor.constraint(equalTo: squareView1.leftAnchor).isActive = true
        actionButton1.rightAnchor.constraint(equalTo: squareView1.rightAnchor).isActive = true
        actionButton1.bottomAnchor.constraint(equalTo: squareView1.bottomAnchor).isActive = true
        
        view.addSubview(actionButton2)
        actionButton2.topAnchor.constraint(equalTo: squareView2.topAnchor).isActive = true
        actionButton2.leftAnchor.constraint(equalTo: squareView2.leftAnchor).isActive = true
        actionButton2.rightAnchor.constraint(equalTo: squareView2.rightAnchor).isActive = true
        actionButton2.bottomAnchor.constraint(equalTo: squareView2.bottomAnchor).isActive = true
        
        view.addSubview(actionButton3)
        actionButton3.topAnchor.constraint(equalTo: squareView3.topAnchor).isActive = true
        actionButton3.leftAnchor.constraint(equalTo: squareView3.leftAnchor).isActive = true
        actionButton3.rightAnchor.constraint(equalTo: squareView3.rightAnchor).isActive = true
        actionButton3.bottomAnchor.constraint(equalTo: squareView3.bottomAnchor).isActive = true
        
        view.addSubview(actionButton4)
        actionButton4.topAnchor.constraint(equalTo: squareView4.topAnchor).isActive = true
        actionButton4.leftAnchor.constraint(equalTo: squareView4.leftAnchor).isActive = true
        actionButton4.rightAnchor.constraint(equalTo: squareView4.rightAnchor).isActive = true
        actionButton4.bottomAnchor.constraint(equalTo: squareView4.bottomAnchor).isActive = true
        
        view.addSubview(actionButton5)
        actionButton5.topAnchor.constraint(equalTo: squareView5.topAnchor).isActive = true
        actionButton5.leftAnchor.constraint(equalTo: squareView5.leftAnchor).isActive = true
        actionButton5.rightAnchor.constraint(equalTo: squareView5.rightAnchor).isActive = true
        actionButton5.bottomAnchor.constraint(equalTo: squareView5.bottomAnchor).isActive = true
        
        view.addSubview(actionButton6)
        actionButton6.topAnchor.constraint(equalTo: squareView6.topAnchor).isActive = true
        actionButton6.leftAnchor.constraint(equalTo: squareView6.leftAnchor).isActive = true
        actionButton6.rightAnchor.constraint(equalTo: squareView6.rightAnchor).isActive = true
        actionButton6.bottomAnchor.constraint(equalTo: squareView6.bottomAnchor).isActive = true
    }
    
    private func totalUsers() {
        self.theme2.text! = String(0)
        Database.database().reference().child("Apps").child(globalAppId).child("Users").observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let user = Customer(
                    name: value["firstName"] as! String,
                    email: value["email"] as! String
                )
                self.users.append(user)
            }
            self.theme2.text! = String(self.users.count)
        }
    }
    
    private func goToFollowingScreen(viewController: UIViewController) {
        let controller = viewController
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func featureUsage() {
        MBProgressHUD.showAdded(to: self.largeView, animated: true)
        
        Database.database().reference().child("Apps").child(globalAppId).child("features").child("aboutUs").observe(DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? Bool {
                if !value {
                    self.squareView5.alpha = 0
                } else {
                    UIView.animate(withDuration: 0.5) {
                        self.squareView5.alpha = 1
                        MBProgressHUD.hide(for: self.largeView, animated: true)
                    }
                }
            }
        }
        
        Database.database().reference().child("Apps").child(globalAppId).child("features").child("addLocations").observe(DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? Bool {
                if !value {
                    self.squareView6.alpha = 0
                } else {
                    UIView.animate(withDuration: 0.5) {
                        self.squareView6.alpha = 1
                    }
                }
            }
        }
        
        Database.database().reference().child("Apps").child(globalAppId).child("features").child("imageGallery").observe(DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? Bool {
                if !value {
                    self.squareView4.alpha = 0
                } else {
                    UIView.animate(withDuration: 0.5) {
                        self.squareView4.alpha = 1
                    }
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if self.squareView4.alpha == 0 && self.squareView6.alpha == 1 {
                self.squareView4.alpha = 1
                self.action4.text = "Add Your"
                self.theme4.text = "Location"
                self.emoji4.text = "📍"
                self.actionButton4.tag = 1
                
                self.squareView6.alpha = 0
                self.action6.text = "Add Your"
                self.theme6.text = "Images"
                self.emoji6.text = "📸"
                self.actionButton6.tag = 0
            } else {
                self.squareView6.alpha = 1
                self.action6.text = "Add Your"
                self.theme6.text = "Location"
                self.emoji6.text = "📍"
                self.actionButton6.tag = 1
                
                self.squareView4.alpha = 1
                self.action4.text = "Add Your"
                self.theme4.text = "Images"
                self.emoji4.text = "📸"
                self.actionButton4.tag = 0
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                MBProgressHUD.hide(for: self.largeView, animated: true)
            }
        }
    }
    
    // MARK: - Objective-C Functions
    
    @objc func buttonAction1() {
        goToFollowingScreen(viewController: CustomizeThemeController())
    }
    
    @objc func buttonAction2() {
        print("not tappable")
    }
    
    @objc func buttonAction3() {
        tabBarController?.selectedIndex = 1
    }
    
    @objc func buttonAction4() {
        if self.actionButton4.tag == 0 {
            goToFollowingScreen(viewController: ImageGalleryController())
        } else {
            goToFollowingScreen(viewController: LocationsController())
        }
    }
    
    @objc func buttonAction5() {
        goToFollowingScreen(viewController: AboutUsController())
    }
    
    @objc func buttonAction6() {
        goToFollowingScreen(viewController: LocationsController())
    }

}
