//
//  SignInController.swift
//  DISH Connect
//
//  Created by JJ Zapata on 4/5/21.
//

import UIKit
import MBProgressHUD
import AppTrackingTransparency
import Firebase

class SignInController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    // MARK: - View Objects
    
    let signInLogo : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "signInLogo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let welcomeText : UILabel = {
        let label = UILabel()
        label.text = "Sign In"
        label.textColor = UIColor(named: "mainTextColor")!
        label.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let requestButton : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        let prompt1 = NSMutableAttributedString(string: "Interested in a restaurant app? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor : UIColor(named: "secondaryText")!])
        let prompt2 = NSMutableAttributedString(string: "Request Here", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor : UIColor(named: "accentColor")!])
        prompt1.append(prompt2)
        button.setAttributedTitle(prompt1, for: UIControl.State.normal)
        button.addTarget(self, action: #selector(requestButtonPressed), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let inputTextFieldView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let mainButton : MainButton = {
        let button = MainButton(title: "Sign In")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(mainButtonPressed), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let emailTextField : MainTextField = {
        let textField = MainTextField(placeholderString: "Email")
        textField.isSecureTextEntry = false
        textField.keyboardType = UIKeyboardType.emailAddress
        textField.autocapitalizationType = UITextAutocapitalizationType.none
        return textField
    }()
    
    let passwordTextField : MainTextField = {
        let textField = MainTextField(placeholderString: "Password")
        textField.isSecureTextEntry = true
        textField.keyboardType = UIKeyboardType.default
        return textField
    }()
    
    // MARK: - Overriden Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        delegates()
        updateViewConstraints()
        autoSignIn()
        appTracking()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
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
        view.addSubview(signInLogo)
        signInLogo.topAnchor.constraint(equalTo: view.topAnchor, constant: 74).isActive = true
        signInLogo.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        signInLogo.heightAnchor.constraint(equalToConstant: 75).isActive = true
        signInLogo.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(welcomeText)
        welcomeText.topAnchor.constraint(equalTo: signInLogo.bottomAnchor, constant: 9).isActive = true
        welcomeText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        welcomeText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        welcomeText.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        Database.database().reference().child("Settings").child("requestLinkShowing").observe(DataEventType.value) { snapshot in
            if let bool = snapshot.value as? Bool {
                if bool {
                    self.view.addSubview(self.requestButton)
                    self.requestButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
                    self.requestButton.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
                    self.requestButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
                    self.requestButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
                }
            }
        }
        
        view.addSubview(inputTextFieldView)
        inputTextFieldView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputTextFieldView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        inputTextFieldView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        inputTextFieldView.heightAnchor.constraint(equalToConstant: 178).isActive = true
        
        inputTextFieldView.addSubview(mainButton)
        mainButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainButton.leftAnchor.constraint(equalTo: inputTextFieldView.leftAnchor).isActive = true
        mainButton.rightAnchor.constraint(equalTo: inputTextFieldView.rightAnchor).isActive = true
        mainButton.bottomAnchor.constraint(equalTo: inputTextFieldView.bottomAnchor).isActive = true
        
        inputTextFieldView.addSubview(emailTextField)
        emailTextField.topAnchor.constraint(equalTo: inputTextFieldView.topAnchor).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: inputTextFieldView.leftAnchor).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: inputTextFieldView.rightAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        inputTextFieldView.addSubview(passwordTextField)
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: inputTextFieldView.leftAnchor).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: inputTextFieldView.rightAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    private func delegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func autoSignIn() {
        if let _ = Auth.auth().currentUser {
            goToTabBar()
        }
    }
    
    private func goToTabBar() {
        let controller = TabBarController()
        controller.getAppId()
        controller.modalPresentationStyle = .fullScreen
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    private func appTracking() {
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                print("Authorized")
            case .denied:
                print("Denied")
                ATTrackingManager.requestTrackingAuthorization { anotherStatus in
                    print("denied again")
                }
            case .notDetermined:
                print("Not Determined")
            case .restricted:
                print("Restricted")
            @unknown default:
                print("Unknown")
            }
        }
    }
    
    // MARK: - Objective-C Functions
    
    @objc func requestButtonPressed() {
        let urlString = "https://dish-digital.netlify.app"
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func mainButtonPressed() {
        MBProgressHUD.showAdded(to: view, animated: true)
        if emailTextField.text != "" || passwordTextField.text != "" {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { authResult, error in
                if let error = error {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.simpleAlert(title: "Error", message: error.localizedDescription)
                } else if let _ = authResult {
                    self.goToTabBar()
                } else {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.simpleAlert(title: "Error", message: "Unknown error. Please try again")
                }
            }
        } else {
            MBProgressHUD.hide(for: view, animated: true)
            simpleAlert(title: "Error", message: "Please fill in all fields")
        }
    }
    
    // MARK: - UITextField Delegate Functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            textField.resignFirstResponder()
            mainButtonPressed()
        } else {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        }
        return (true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
