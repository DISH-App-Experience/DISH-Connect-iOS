//
//  File.swift
//  DISH Connect
//
//  Created by JJ Zapata on 4/27/21.
//

import UIKit
import Firebase
import Foundation
import CoreLocation
import MBProgressHUD

class PromoDetailController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    var action : String? {
        didSet {
            if action == "GET" {
                title = "Edit Promo"
                addRemoveButton()
            } else {
                title = "Add Promo"
            }
        }
    }
    
    var users = [Customer]()
    
    var eventId : String? {
        didSet {
            backend(withItemID: eventId!)
        }
    }
    
    // MARK: - View Objects
    
    let streetAddressTF : MainTextField = {
        let textField = MainTextField(placeholderString: "Code")
        textField.isSecureTextEntry = false
        textField.keyboardType = UIKeyboardType.default
        textField.autocapitalizationType = UITextAutocapitalizationType.words
        return textField
    }()
    
    let cityTF : MainTextField = {
        let textField = MainTextField(placeholderString: "Name")
        textField.isSecureTextEntry = false
        textField.keyboardType = UIKeyboardType.default
        textField.autocapitalizationType = UITextAutocapitalizationType.words
        return textField
    }()
    
    let zipcodeTF : MainTextField = {
        let textField = MainTextField(placeholderString: "Valid until")
        textField.isSecureTextEntry = false
        textField.keyboardType = UIKeyboardType.decimalPad
        textField.autocapitalizationType = UITextAutocapitalizationType.words
        return textField
    }()
    
    let stateTF : MainTextField = {
        let textField = MainTextField(placeholderString: "Description")
        textField.isSecureTextEntry = false
        textField.keyboardType = UIKeyboardType.default
        textField.autocapitalizationType = UITextAutocapitalizationType.words
        return textField
    }()
    
    let mainButton : MainButton = {
        let button = MainButton(title: "Next")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(mainButtonPressed), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let removeButton : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitle("Expire Promo", for: UIControl.State.normal)
        button.setTitleColor(UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(removeButtonTapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    // MARK: - Overriden Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "backgroundColor")!
        
        updateViewConstraints()
        delegates()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = UIColor.mainBlue
        navigationItem.largeTitleDisplayMode = UINavigationItem.LargeTitleDisplayMode.always
        
        navigationItem.backButtonTitle = "Back"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPressed))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = UIColor.mainBlue
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = UINavigationItem.LargeTitleDisplayMode.always
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        constraints()
    }
    
    // MARK: - Private Functions
    
    private func constraints() {
        view.addSubview(zipcodeTF)
        zipcodeTF.setInputViewDatePicker(target: self, selector: #selector(donePressed))
        zipcodeTF.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        zipcodeTF.widthAnchor.constraint(equalToConstant: 135).isActive = true
        zipcodeTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        zipcodeTF.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        view.addSubview(cityTF)
        cityTF.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        cityTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        cityTF.rightAnchor.constraint(equalTo: zipcodeTF.leftAnchor, constant: -16).isActive = true
        cityTF.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        view.addSubview(stateTF)
        stateTF.topAnchor.constraint(equalTo: cityTF.bottomAnchor, constant: 16).isActive = true
        stateTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        stateTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        stateTF.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        view.addSubview(streetAddressTF)
        streetAddressTF.topAnchor.constraint(equalTo: stateTF.bottomAnchor, constant: 16).isActive = true
        streetAddressTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        streetAddressTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        streetAddressTF.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        view.addSubview(mainButton)
        mainButton.topAnchor.constraint(equalTo: streetAddressTF.bottomAnchor, constant: 27).isActive = true
        mainButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        mainButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    private func backend(withItemID id: String) {
        
        let root = Database.database().reference().child("Apps").child(globalAppId)
        let base = root.child("promotions").child(id)
        
        print(id)
        
        base.child("name").observe(DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? String {
                self.cityTF.text = value
            }
        }

        base.child("date").observe(DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? Int {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                self.zipcodeTF.text = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(value)))
            }
        }
        
        base.child("desc").observe(DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? String {
                self.stateTF.text = value
            }
        }

        base.child("code").observe(DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? String {
                self.streetAddressTF.text = value
            }
        }
    }
    
    private func delegates() {
        streetAddressTF.delegate = self
        cityTF.delegate = self
        zipcodeTF.delegate = self
        stateTF.delegate = self
    }
    
    private func addRemoveButton() {
        view.addSubview(removeButton)
        removeButton.widthAnchor.constraint(equalToConstant: 203).isActive = true
        removeButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        removeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        removeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
    }
    
    private func continueCompletion(key: String, isNew: Bool) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        if isNew {
            let values : [String : Any] = [
                "key" : key,
                "name" : "\(self.cityTF.text!)",
                "desc" : "\(self.stateTF.text!)",
                "code" : "\(self.streetAddressTF.text!)",
                "validUntil" : Int(Date(detectFromString: zipcodeTF.text!)!.timeIntervalSince1970),
                "date" : Int(Date().timeIntervalSince1970),
            ]
            uploadNew(withValues: values, key: key)
        } else {
            print("upload existing with id: " + eventId!)
            let values : [String : Any] = [
                "key" : self.eventId!,
                "name" : "\(self.cityTF.text!)",
                "desc" : "\(self.stateTF.text!)",
                "code" : "\(self.streetAddressTF.text!)",
                "validUntil" : Int(Date(detectFromString: zipcodeTF.text!)!.timeIntervalSince1970),
                "date" : Int(Date().timeIntervalSince1970),
            ]
            self.uploadExisting(withValues: values, key: self.eventId!)
        }
    }
    
    private func uploadExisting(withValues values: [String : Any], key: String) {
        let root = Database.database().reference().child("Apps").child(globalAppId).child("promotions").child(key)
        root.updateChildValues(values) { (error, ref) in
            if error != nil {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.simpleAlert(title: "Error", message: error!.localizedDescription)
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.completion()
            }
        }
    }
    
    private func uploadNew(withValues values: [String : Any], key: String) {
        let root = Database.database().reference().child("Apps").child(globalAppId).child("promotions").child(key)
        root.updateChildValues(values) { (error, ref) in
            if error != nil {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.simpleAlert(title: "Error", message: error!.localizedDescription)
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.completion()
            }
        }
    }
    
    private func completion() {
        Database.database().reference().child("Apps").child(globalAppId).child("Users").observe(DataEventType.childAdded) { snapshot in
            if let value = snapshot.value as? [String : Any] {
                var user = Customer()
                user.fcm = value["fcmToken"] as? String
                self.users.append(user)
            }
            for user in self.users {
                PushNotificationSender().sendPushNotification(to: user.fcm ?? "", title: self.cityTF.text! + "!", body: "Check the 'Promotions' tab in our app to find out more!")
            }
        }
        let alert = UIAlertController(title: "Success", message: "Added promotion", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Objective-C Functions
    
    @objc func mainButtonPressed() {
        MBProgressHUD.showAdded(to: view, animated: true)
        if action == "GET" {
            // use key from fetched source
            let root = Database.database().reference().child("Apps").child(globalAppId).child("promotions")
            let key = root.childByAutoId().key
            self.continueCompletion(key: key!, isNew: false)
        } else {
            let root = Database.database().reference().child("Apps").child(globalAppId).child("promotions")
            let key = root.childByAutoId().key
            self.continueCompletion(key: key!, isNew: true)
        }
    }
    
    @objc func cancelPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func removeButtonTapped() {
        let alert = UIAlertController(title: "Remove?", message: "Are you sure you would like to delete this location?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action) in
            Database.database().reference().child("Apps").child(globalAppId).child("promotions").child(self.eventId!).removeValue()
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "No, Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func donePressed() {
        if let datePicker = self.zipcodeTF.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            zipcodeTF.text = dateFormatter.string(from: datePicker.date)
        }
        zipcodeTF.resignFirstResponder()
    }
    
    // MARK: - UITextField Delegate Functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case cityTF:
            zipcodeTF.becomeFirstResponder()
        case stateTF:
            streetAddressTF.becomeFirstResponder()
        case streetAddressTF:
            streetAddressTF.resignFirstResponder()
            mainButtonPressed()
        default:
            textField.resignFirstResponder()
        }
        return (true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

