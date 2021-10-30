//
//  SettingsController.swift
//  DISH Connect
//
//  Created by JJ Zapata on 4/5/21.
//

import UIKit
import StoreKit
import Firebase

class SettingsController: UIViewController {
    
    // MARK: - Constants
    
    let version = "1.0.3"
    
    let language = "English"
    
    // MARK: - View Objects
    
    let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(named: "backgroundColor")!
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let profileImage : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(named: "secondaryBackground")!
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        return imageView
    }()
    
    let titleName : UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor(named: "mainTextColor")!
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let versionImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "rocet")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let languageImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "language")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let rateUsImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let reportErrorImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cloud")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let requestFeatureImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "feature")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let shareDishImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "share")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let signOutImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logout")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let versionTitle : UILabel = {
        let label = UILabel()
        label.text = "Version"
        label.textColor = UIColor(named: "mainTextColor")!
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let versionDesc : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "placeholderColor")!
        label.textAlignment = NSTextAlignment.right
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let languageTitle : UILabel = {
        let label = UILabel()
        label.text = "Language"
        label.textColor = UIColor(named: "mainTextColor")!
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let languageDesc : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "placeholderColor")!
        label.textAlignment = NSTextAlignment.right
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let rateUsTitle : UILabel = {
        let label = UILabel()
        label.text = "Rate us"
        label.textColor = UIColor(named: "mainTextColor")!
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let reportErrorTitle : UILabel = {
        let label = UILabel()
        label.text = "Report Error"
        label.textColor = UIColor(named: "mainTextColor")!
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let requestFeatureTitle : UILabel = {
        let label = UILabel()
        label.text = "Manage Features"
        label.textColor = UIColor(named: "mainTextColor")!
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let shareDshTitle : UILabel = {
        let label = UILabel()
        label.text = "Share DISH"
        label.textColor = UIColor(named: "mainTextColor")!
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let signOutTitle : UILabel = {
        let label = UILabel()
        label.text = "Sign Out"
        label.textColor = UIColor(named: "mainTextColor")!
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let chevron1 : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = UIColor(named: "placeholderColor")
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let chevron2 : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = UIColor(named: "placeholderColor")
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let chevron3 : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = UIColor(named: "placeholderColor")
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let chevron4 : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = UIColor(named: "placeholderColor")
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let chevron5 : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = UIColor(named: "placeholderColor")
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let chevron6 : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = UIColor(named: "placeholderColor")
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let chevron7 : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = UIColor(named: "placeholderColor")
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let button1 : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(button1Tapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let button2 : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(button2Tapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let button3 : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(button3Tapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let button4 : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(button4Tapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let button5 : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(button5Tapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    // MARK: - Overriden Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor(named: "backgroundColor")!
        
        updateViewConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.tintColor = UIColor.mainBlue
        
        backend()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        constraints()
    }
    
    // MARK: - Private Functions
    
    private func constraints() {
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: view.frame.width - 50, height: 500)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        
        scrollView.addSubview(profileImage)
        profileImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 7).isActive = true
        profileImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        scrollView.addSubview(titleName)
        titleName.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 19).isActive = true
        titleName.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        titleName.heightAnchor.constraint(equalToConstant: 21).isActive = true
        titleName.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 50).isActive = true
        
        scrollView.addSubview(versionImage)
        versionImage.topAnchor.constraint(equalTo: titleName.bottomAnchor, constant: 48).isActive = true
        versionImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        versionImage.widthAnchor.constraint(equalToConstant: 35).isActive = true
        versionImage.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        scrollView.addSubview(languageImage)
        languageImage.topAnchor.constraint(equalTo: versionImage.bottomAnchor, constant: 15).isActive = true
        languageImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        languageImage.widthAnchor.constraint(equalToConstant: 35).isActive = true
        languageImage.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        scrollView.addSubview(rateUsImage)
        rateUsImage.topAnchor.constraint(equalTo: languageImage.bottomAnchor, constant: 30).isActive = true
        rateUsImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        rateUsImage.widthAnchor.constraint(equalToConstant: 35).isActive = true
        rateUsImage.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        scrollView.addSubview(reportErrorImage)
        reportErrorImage.topAnchor.constraint(equalTo: rateUsImage.bottomAnchor, constant: 15).isActive = true
        reportErrorImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        reportErrorImage.widthAnchor.constraint(equalToConstant: 35).isActive = true
        reportErrorImage.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        scrollView.addSubview(requestFeatureImage)
        requestFeatureImage.topAnchor.constraint(equalTo: reportErrorImage.bottomAnchor, constant: 15).isActive = true
        requestFeatureImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        requestFeatureImage.widthAnchor.constraint(equalToConstant: 35).isActive = true
        requestFeatureImage.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        scrollView.addSubview(shareDishImage)
        shareDishImage.topAnchor.constraint(equalTo: requestFeatureImage.bottomAnchor, constant: 30).isActive = true
        shareDishImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        shareDishImage.widthAnchor.constraint(equalToConstant: 35).isActive = true
        shareDishImage.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        scrollView.addSubview(signOutImage)
        signOutImage.topAnchor.constraint(equalTo: shareDishImage.bottomAnchor, constant: 30).isActive = true
        signOutImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        signOutImage.widthAnchor.constraint(equalToConstant: 35).isActive = true
        signOutImage.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        scrollView.addSubview(versionTitle)
        versionTitle.topAnchor.constraint(equalTo: titleName.bottomAnchor, constant: 48).isActive = true
        versionTitle.leftAnchor.constraint(equalTo: versionImage.rightAnchor, constant: 12).isActive = true
        versionTitle.heightAnchor.constraint(equalToConstant: 35).isActive = true
        versionTitle.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        scrollView.addSubview(languageTitle)
        languageTitle.topAnchor.constraint(equalTo: languageImage.topAnchor).isActive = true
        languageTitle.leftAnchor.constraint(equalTo: languageImage.rightAnchor, constant: 12).isActive = true
        languageTitle.heightAnchor.constraint(equalToConstant: 35).isActive = true
        languageTitle.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        scrollView.addSubview(versionDesc)
        versionDesc.text = version
        versionDesc.topAnchor.constraint(equalTo: titleName.bottomAnchor, constant: 48).isActive = true
        versionDesc.leftAnchor.constraint(equalTo: versionImage.rightAnchor, constant: 12).isActive = true
        versionDesc.heightAnchor.constraint(equalToConstant: 35).isActive = true
        versionDesc.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        
        scrollView.addSubview(languageDesc)
        languageDesc.text = language
        languageDesc.topAnchor.constraint(equalTo: languageImage.topAnchor).isActive = true
        languageDesc.leftAnchor.constraint(equalTo: languageImage.rightAnchor, constant: 12).isActive = true
        languageDesc.heightAnchor.constraint(equalToConstant: 35).isActive = true
        languageDesc.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        
        scrollView.addSubview(rateUsTitle)
        rateUsTitle.topAnchor.constraint(equalTo: rateUsImage.topAnchor).isActive = true
        rateUsTitle.leftAnchor.constraint(equalTo: rateUsImage.rightAnchor, constant: 12).isActive = true
        rateUsTitle.heightAnchor.constraint(equalToConstant: 35).isActive = true
        rateUsTitle.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        scrollView.addSubview(reportErrorTitle)
        reportErrorTitle.topAnchor.constraint(equalTo: reportErrorImage.topAnchor).isActive = true
        reportErrorTitle.leftAnchor.constraint(equalTo: reportErrorImage.rightAnchor, constant: 12).isActive = true
        reportErrorTitle.heightAnchor.constraint(equalToConstant: 35).isActive = true
        reportErrorTitle.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        scrollView.addSubview(requestFeatureTitle)
        requestFeatureTitle.topAnchor.constraint(equalTo: requestFeatureImage.topAnchor).isActive = true
        requestFeatureTitle.leftAnchor.constraint(equalTo: requestFeatureImage.rightAnchor, constant: 12).isActive = true
        requestFeatureTitle.heightAnchor.constraint(equalToConstant: 35).isActive = true
        requestFeatureTitle.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        scrollView.addSubview(shareDshTitle)
        shareDshTitle.topAnchor.constraint(equalTo: shareDishImage.topAnchor).isActive = true
        shareDshTitle.leftAnchor.constraint(equalTo: shareDishImage.rightAnchor, constant: 12).isActive = true
        shareDshTitle.heightAnchor.constraint(equalToConstant: 35).isActive = true
        shareDshTitle.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        scrollView.addSubview(signOutTitle)
        signOutTitle.topAnchor.constraint(equalTo: signOutImage.topAnchor).isActive = true
        signOutTitle.leftAnchor.constraint(equalTo: signOutImage.rightAnchor, constant: 12).isActive = true
        signOutTitle.heightAnchor.constraint(equalToConstant: 35).isActive = true
        signOutTitle.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        scrollView.addSubview(chevron3)
        chevron3.centerYAnchor.constraint(equalTo: rateUsImage.centerYAnchor).isActive = true
        chevron3.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        chevron3.widthAnchor.constraint(equalToConstant: 15).isActive = true
        chevron3.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        scrollView.addSubview(chevron4)
        chevron4.centerYAnchor.constraint(equalTo: reportErrorImage.centerYAnchor).isActive = true
        chevron4.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        chevron4.widthAnchor.constraint(equalToConstant: 15).isActive = true
        chevron4.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        scrollView.addSubview(chevron5)
        chevron5.centerYAnchor.constraint(equalTo: requestFeatureImage.centerYAnchor).isActive = true
        chevron5.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        chevron5.widthAnchor.constraint(equalToConstant: 15).isActive = true
        chevron5.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        scrollView.addSubview(chevron6)
        chevron6.centerYAnchor.constraint(equalTo: shareDishImage.centerYAnchor).isActive = true
        chevron6.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        chevron6.widthAnchor.constraint(equalToConstant: 15).isActive = true
        chevron6.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        scrollView.addSubview(chevron7)
        chevron7.centerYAnchor.constraint(equalTo: signOutImage.centerYAnchor).isActive = true
        chevron7.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        chevron7.widthAnchor.constraint(equalToConstant: 15).isActive = true
        chevron7.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        scrollView.addSubview(button1)
        button1.topAnchor.constraint(equalTo: rateUsImage.topAnchor).isActive = true
        button1.leftAnchor.constraint(equalTo: rateUsImage.leftAnchor).isActive = true
        button1.rightAnchor.constraint(equalTo: chevron3.rightAnchor).isActive = true
        button1.bottomAnchor.constraint(equalTo: rateUsImage.bottomAnchor).isActive = true
        
        scrollView.addSubview(button2)
        button2.topAnchor.constraint(equalTo: reportErrorImage.topAnchor).isActive = true
        button2.leftAnchor.constraint(equalTo: reportErrorImage.leftAnchor).isActive = true
        button2.rightAnchor.constraint(equalTo: chevron4.rightAnchor).isActive = true
        button2.bottomAnchor.constraint(equalTo: reportErrorImage.bottomAnchor).isActive = true
        
        scrollView.addSubview(button3)
        button3.topAnchor.constraint(equalTo: requestFeatureImage.topAnchor).isActive = true
        button3.leftAnchor.constraint(equalTo: requestFeatureImage.leftAnchor).isActive = true
        button3.rightAnchor.constraint(equalTo: chevron5.rightAnchor).isActive = true
        button3.bottomAnchor.constraint(equalTo: requestFeatureImage.bottomAnchor).isActive = true
        
        scrollView.addSubview(button4)
        button4.topAnchor.constraint(equalTo: shareDishImage.topAnchor).isActive = true
        button4.leftAnchor.constraint(equalTo: shareDishImage.leftAnchor).isActive = true
        button4.rightAnchor.constraint(equalTo: chevron6.rightAnchor).isActive = true
        button4.bottomAnchor.constraint(equalTo: shareDishImage.bottomAnchor).isActive = true
        
        scrollView.addSubview(button5)
        button5.topAnchor.constraint(equalTo: signOutImage.topAnchor).isActive = true
        button5.leftAnchor.constraint(equalTo: signOutImage.leftAnchor).isActive = true
        button5.rightAnchor.constraint(equalTo: chevron7.rightAnchor).isActive = true
        button5.bottomAnchor.constraint(equalTo: signOutImage.bottomAnchor).isActive = true
    }
    
    private func backend() {
        findProfilePic()
        findName()
    }
    
    private func findProfilePic() {
        Database.database().reference().child("Apps").child(globalAppId).child("appIcon").observeSingleEvent(of: .value) { (snapshot) in
            if let profileURL = snapshot.value as? String {
                self.profileImage.loadImageUsingCacheWithUrlString(profileURL)
            }
        }
    }
    
    private func findName() {
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("name").observeSingleEvent(of: .value) { (snapshot) in
            if let name = snapshot.value as? String {
                self.titleName.text = name
            }
        }
    }
    
    // MARK: - Objective-C Functions
    
    @objc func button1Tapped() {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "1564642768") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func button2Tapped() {
        let controller = ReportErrorController()
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func button3Tapped() {
        let controller = ManageFeaturesController()
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func button4Tapped() {
        let items = ["https://dish-digital.netlify.app"]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(ac, animated: true)
    }
    
    @objc func button5Tapped() {
        let alert = UIAlertController(title: "Sign Out?", message: "Are you sure you want to sign out?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            do {
                try Auth.auth().signOut()
            } catch let signOutError as NSError {
                print("Error signing out: \(signOutError)")
            }
            let controller = SignInController()
            controller.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.present(controller, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
