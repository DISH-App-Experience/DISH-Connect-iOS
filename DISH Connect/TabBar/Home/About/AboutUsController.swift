//
//  AboutUsController.swift
//  DISH Connect
//
//  Created by JJ Zapata on 4/6/21.
//

import UIKit
import Firebase
import MBProgressHUD
import PhoneNumberKit

class AboutUsController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    var isSelected = false
    
    // MARK: - View Objects
    
    let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(named: "backgroundColor")!
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let textView : MainTextView = {
        let textView = MainTextView()
        return textView
    }()
    
    let websiteLink : MainTextField = {
        let textField = MainTextField(placeholderString: "Website Link")
        return textField
    }()
    
    let phoneNumber : MainTextField = {
        let textField = MainTextField(placeholderString: "Phone Number")
        textField.keyboardType = UIKeyboardType.phonePad
        return textField
    }()
    
    let mainButton : MainButton = {
        let button = MainButton(title: "Save")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(mainButtonPressed), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    // MARK: - Overriden Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "backgroundColor")!
        
        title = "About Us"
        
        textView.text = "Write Here.."
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.textColor = UIColor(named: "placeholderColor")!
        
        updateViewConstraints()
        delegates()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = UIColor.mainBlue
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.backButtonTitle = "Back"
        
        backend()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        constraints()
    }
    
    // MARK: - Private Functions
    
    private func constraints() {
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: view.frame.width - 50, height: 900)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        
        scrollView.addSubview(textView)
        textView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        textView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        textView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 279).isActive = true
        
        scrollView.addSubview(websiteLink)
        websiteLink.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 19).isActive = true
        websiteLink.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        websiteLink.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        websiteLink.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        scrollView.addSubview(phoneNumber)
        phoneNumber.topAnchor.constraint(equalTo: websiteLink.bottomAnchor, constant: 19).isActive = true
        phoneNumber.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        phoneNumber.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        phoneNumber.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        scrollView.addSubview(mainButton)
        mainButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainButton.leftAnchor.constraint(equalTo: phoneNumber.leftAnchor).isActive = true
        mainButton.rightAnchor.constraint(equalTo: phoneNumber.rightAnchor).isActive = true
        mainButton.topAnchor.constraint(equalTo: phoneNumber.bottomAnchor, constant: 60).isActive = true
    }
    
    private func backend() {
        MBProgressHUD.showAdded(to: view, animated: true)
        Database.database().reference().child("Apps").child(globalAppId).child("about").child("aboutUs").observe(DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? String {
                if value != "nil" {
                    self.textView.text = value
                    self.textView.font = UIFont.systemFont(ofSize: 17)
                    self.textView.textColor = UIColor(named: "mainTextColor")!
                }
            }
        }
        
        Database.database().reference().child("Apps").child(globalAppId).child("about").child("websiteLink").observe(DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? String {
                if value != "nil" {
                    self.websiteLink.text = value
                }
            }
        }
        
        Database.database().reference().child("Apps").child(globalAppId).child("about").child("phoneNumber").observe(DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? String {
                if value != "nil" {
                    let phoneNumberKit = PhoneNumberKit()
                    do {
                        let phoneNumber = try phoneNumberKit.parse(value)
                        self.phoneNumber.text = phoneNumberKit.format(phoneNumber, toType: PhoneNumberFormat.international)
                    } catch {
                        print("error parsing phone number")
                    }
                }
            }
        }
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    private func delegates() {
        textView.delegate = self
        websiteLink.delegate = self
        phoneNumber.delegate = self
    }
    
    // MARK: - Objective-C Functions
    
    @objc func mainButtonPressed() {
        textView.resignFirstResponder()
        phoneNumber.resignFirstResponder()
        websiteLink.resignFirstResponder()

        MBProgressHUD.showAdded(to: view, animated: true)

        if textView.text != "" {
            Database.database().reference().child("Apps").child(globalAppId).child("about").child("aboutUs").setValue(textView.text!)
        }

        if websiteLink.text != "" {
            Database.database().reference().child("Apps").child(globalAppId).child("about").child("websiteLink").setValue(websiteLink.text!)
        }

        if phoneNumber.text != "" {
            let phoneNumberKit = PhoneNumberKit()
            do {
                let phoneNumberInfo = try phoneNumberKit.parse(phoneNumber.text!)
                Database.database().reference().child("Apps").child(globalAppId).child("about").child("phoneNumber").setValue(phoneNumberKit.format(phoneNumberInfo, toType: PhoneNumberFormat.e164))
            } catch {
                print("could not upload a valid e164 value")
            }
        }

        if textView.text! == "" && websiteLink.text! == "" && phoneNumber.text! == "" {
            simpleAlert(title: "Error Submitting Data", message: "No Data Has Been Inputted")
            return
        }

        MBProgressHUD.hide(for: view, animated: true)
        let alert = UIAlertController(title: "Success", message: "Your information has been updated", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UITextView Delegate Functions
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write Here.." {
            textView.text = ""
            textView.font = UIFont.systemFont(ofSize: 17)
            textView.textColor = UIColor(named: "mainTextColor")!
        }
    }
    
    // MARK: - UITextField Delegate Functions
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNumber {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = format(with: "+X XXX-XXX-XXXX", phone: newString)
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
