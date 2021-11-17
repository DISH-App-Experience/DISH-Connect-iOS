//
//  ReportErrorController.swift
//  DISH Connect
//
//  Created by JJ Zapata on 4/6/21.
//

import UIKit
import Firebase
import MBProgressHUD

class ReportErrorController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Constants
    
    // MARK: - View Objects
    
    let largeImageView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "secondaryBackground")!
        view.layer.cornerRadius = 20
        return view
    }()
    
    let iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor(named: "mainTextColor")!
        imageView.image = UIImage(systemName: "exclamationmark.triangle")
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        return imageView
    }()
    
    let textFieldDesc : UILabel = {
        let label = UILabel()
        label.text = "Please report your error with detail:"
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor(named: "placeholderColor")!
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let mainTextField : MainTextField = {
        let textField = MainTextField(placeholderString: "Write Here")
        textField.isSecureTextEntry = false
        textField.keyboardType = UIKeyboardType.default
        textField.autocapitalizationType = UITextAutocapitalizationType.sentences
        return textField
    }()
    
    let mainButton : MainButton = {
        let button = MainButton(title: "Report")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(mainButtonPressed), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    // MARK: - Overriden Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor(named: "backgroundColor")!
        
        updateViewConstraints()
        delegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "Report Error"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        constraints()
    }
    
    // MARK: - Private Functions
    
    private func constraints() {
        view.addSubview(largeImageView)
        largeImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        largeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        largeImageView.widthAnchor.constraint(equalToConstant: 253).isActive = true
        largeImageView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        largeImageView.addSubview(iconImageView)
        iconImageView.centerXAnchor.constraint(equalTo: largeImageView.centerXAnchor).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: largeImageView.centerYAnchor).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(textFieldDesc)
        textFieldDesc.topAnchor.constraint(equalTo: largeImageView.bottomAnchor, constant: 25).isActive = true
        textFieldDesc.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        textFieldDesc.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        textFieldDesc.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        view.addSubview(mainTextField)
        mainTextField.becomeFirstResponder()
        mainTextField.topAnchor.constraint(equalTo: textFieldDesc.bottomAnchor, constant: 2).isActive = true
        mainTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        mainTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        mainTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        view.addSubview(mainButton)
        mainButton.topAnchor.constraint(equalTo: mainTextField.bottomAnchor, constant: 21).isActive = true
        mainButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        mainButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    private func delegates() {
        mainTextField.delegate = self
    }
    
    // MARK: - Objective-C Functions
    
    @objc func mainButtonPressed() {
        MBProgressHUD.showAdded(to: view, animated: true)
        if mainTextField.text != "" {
            let values = [
                "reporter" : "\(Auth.auth().currentUser!.uid)",
                "date" : "\(Int(Date().timeIntervalSince1970))",
                "message" : "\(self.mainTextField.text!)",
                "version" : "1.0.8"
            ]
            Database.database().reference().child("Feedback").child("Connect").childByAutoId().updateChildValues(values)
            PushNotificationSender().sendPushNotification(to: "fMAumCLS_kX9j5I31A7Eps:APA91bHEaQSV3HNY_eyMFjabR_htPnR4oRxVFnlADFZ8IilsBopHxj3MLFAI7_jnKxJCH4QitLRUxGkRrnBLWGlm2Q8FsJ9gqYXV2Ae6ZSmtmjH2YR5_4da4WnuMpujVtwKgQVHBg8ap", title: "Error Report", body: "Please Check Firebase DB to see reported errors.")
            MBProgressHUD.hide(for: view, animated: true)
            let alert = UIAlertController(title: "Success", message: "Thank you for providing feedback!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            MBProgressHUD.hide(for: view, animated: true)
            simpleAlert(title: "Error", message: "Please fill in the field before submitting")
        }
    }
    
    // MARK: - UITextField Delegate Functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        mainButtonPressed()
        return (true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
