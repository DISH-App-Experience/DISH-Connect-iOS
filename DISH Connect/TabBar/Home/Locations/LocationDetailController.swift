//
//  LocationDetailController.swift
//  DISH Connect
//
//  Created by JJ Zapata on 4/10/21.
//

import UIKit
import Firebase
import CoreLocation
import MBProgressHUD

class LocationDetailController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Constants
    
    let imagePicker = UIImagePickerController()
    
    // MARK: - Variables
    
    var action : String? {
        didSet {
            if action == "GET" {
                title = "Edit Address"
                addRemoveButton()
                photoButton.setTitle("Edit Photo", for: UIControl.State.normal)
            } else {
                title = "Add Address"
                photoButton.setTitle("Add Photo", for: UIControl.State.normal)
            }
        }
    }
    
    var locationId : String? {
        didSet {
            print("location id set")
            backend()
        }
    }
    
    // MARK: - View Objects
    
    let locationImage : CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(named: "secondaryBackground")!
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        return imageView
    }()
    
    let streetAddressTF : MainTextField = {
        let textField = MainTextField(placeholderString: "Street Address")
        textField.isSecureTextEntry = false
        textField.keyboardType = UIKeyboardType.default
        textField.autocapitalizationType = UITextAutocapitalizationType.words
        return textField
    }()
    
    let cityTF : MainTextField = {
        let textField = MainTextField(placeholderString: "City")
        textField.isSecureTextEntry = false
        textField.keyboardType = UIKeyboardType.default
        textField.autocapitalizationType = UITextAutocapitalizationType.words
        return textField
    }()
    
    let zipcodeTF : MainTextField = {
        let textField = MainTextField(placeholderString: "Zipcode")
        textField.isSecureTextEntry = false
        textField.keyboardType = UIKeyboardType.numberPad
        textField.autocapitalizationType = UITextAutocapitalizationType.words
        return textField
    }()
    
    let stateTF : MainTextField = {
        let textField = MainTextField(placeholderString: "State")
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
    
    let photoButton : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.mainBlue.cgColor
        button.setTitleColor(UIColor.mainBlue, for: UIControl.State.normal)
        button.addTarget(self, action: #selector(photoButtonPressed), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let removeButton : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitle("Remove Location", for: UIControl.State.normal)
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
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.backButtonTitle = "Back"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPressed))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = UIColor.mainBlue
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        constraints()
    }
    
    // MARK: - Private Functions
    
    private func constraints() {
        view.addSubview(locationImage)
        locationImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        locationImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        locationImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        locationImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        view.addSubview(streetAddressTF)
        streetAddressTF.topAnchor.constraint(equalTo: locationImage.bottomAnchor, constant: 30).isActive = true
        streetAddressTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        streetAddressTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        streetAddressTF.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        view.addSubview(zipcodeTF)
        zipcodeTF.topAnchor.constraint(equalTo: streetAddressTF.bottomAnchor, constant: 16).isActive = true
        zipcodeTF.widthAnchor.constraint(equalToConstant: 135).isActive = true
        zipcodeTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        zipcodeTF.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        view.addSubview(cityTF)
        cityTF.topAnchor.constraint(equalTo: streetAddressTF.bottomAnchor, constant: 16).isActive = true
        cityTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        cityTF.rightAnchor.constraint(equalTo: zipcodeTF.leftAnchor, constant: -16).isActive = true
        cityTF.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        view.addSubview(stateTF)
        stateTF.topAnchor.constraint(equalTo: cityTF.bottomAnchor, constant: 16).isActive = true
        stateTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        stateTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        stateTF.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        view.addSubview(photoButton)
        photoButton.topAnchor.constraint(equalTo: stateTF.bottomAnchor, constant: 16).isActive = true
        photoButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        photoButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        photoButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        view.addSubview(mainButton)
        mainButton.topAnchor.constraint(equalTo: photoButton.bottomAnchor, constant: 27).isActive = true
        mainButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        mainButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    private func backend() {
        Database.database().reference().child("Apps").child(globalAppId).child("locations").child(locationId!).child("street").observe(DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? String {
                self.streetAddressTF.text = value
            }
        }
        
        Database.database().reference().child("Apps").child(globalAppId).child("locations").child(locationId!).child("city").observe(DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? String {
                self.cityTF.text = value
            }
        }
        
        Database.database().reference().child("Apps").child(globalAppId).child("locations").child(locationId!).child("zip").observe(DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? NSNumber {
                self.zipcodeTF.text = String(Int(truncating: value))
            }
        }
        
        Database.database().reference().child("Apps").child(globalAppId).child("locations").child(locationId!).child("state").observe(DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? String {
                self.stateTF.text = value
            }
        }
        
        Database.database().reference().child("Apps").child(globalAppId).child("locations").child(locationId!).child("image").observe(DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? String {
                self.locationImage.loadImageUsingUrlString(urlString: value)
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
    
    private func continueCompletion(withImageString imageString: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let address = "\(streetAddressTF.text!), \(cityTF.text!), \(stateTF.text!) \(zipcodeTF.text!)"
        // STREET, CITY, STATE ZIPCODE
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.simpleAlert(title: "Error", message: "Didn't find location coordinates. Please try again")
                return
            }
            let values : [String : Any] = [
                "street" : "\(self.streetAddressTF.text!)",
                "city" : "\(self.cityTF.text!)",
                "state" : "\(self.stateTF.text!)",
                "lat" : Float(location.coordinate.latitude),
                "long" : Float(location.coordinate.longitude),
                "zip" : Int(self.zipcodeTF.text!)!,
                "image" : imageString
            ]
            if self.action == "GET" {
                Database.database().reference().child("Apps").child(globalAppId).child("locations").child(self.locationId!).updateChildValues(values) { (error, ref) in
                    if error != nil {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.simpleAlert(title: "Error", message: error!.localizedDescription)
                    } else {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.completion()
                    }
                }
            } else {
                MBProgressHUD.showAdded(to: self.view, animated: true)
                // add new information information
                // update all parameters except image
                let key = Database.database().reference().child("Apps").child(globalAppId).child("locations").childByAutoId().key
                let feed : [String : Any] = [key! : values]
                Database.database().reference().child("Apps").child(globalAppId).child("locations").updateChildValues(feed) { (error, ref) in
                    if error != nil {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.simpleAlert(title: "Error", message: error!.localizedDescription)
                    } else {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.completion()
                    }
                }
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
    
    private func completion() {
        print("completed")
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Objective-C Functions
    
    @objc func mainButtonPressed() {
        MBProgressHUD.showAdded(to: view, animated: true)
        if streetAddressTF.text != "" && cityTF.text != "" && zipcodeTF.text != "" && stateTF.text != "" {
            if locationImage.image == nil {
                continueCompletion(withImageString: "nil")
            } else {
                // image upload
                guard let imageData = locationImage.image!.jpegData(compressionQuality: 0.75) else { return }
                let storageRef = Storage.storage().reference()
                let metadata = StorageMetadata()
                let key = Database.database().reference().child("Apps").child(globalAppId).child("locations").childByAutoId().key
                let storageProfileRef = storageRef.child(key!)
                metadata.contentType = "image/jpg"
                storageProfileRef.putData(imageData, metadata: metadata) { (storageMetadata, putDataError) in
                    if putDataError == nil && storageMetadata != nil {
                        storageProfileRef.downloadURL { (url, downloadUrlError) in
                            if let metalImageUrl = url?.absoluteString {
                                self.continueCompletion(withImageString: metalImageUrl)
                            } else {
                                self.simpleAlert(title: "Error", message: downloadUrlError!.localizedDescription)
                            }
                        }
                    } else {
                        self.simpleAlert(title: "Error", message: putDataError!.localizedDescription)
                    }
                }
            }
        } else {
            simpleAlert(title: "Error", message: "Please make all fields are filled in.")
        }
    }
    
    @objc func cancelPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func removeButtonTapped() {
        let alert = UIAlertController(title: "Remove?", message: "Are you sure you would like to delete this location?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action) in
            Database.database().reference().child("Apps").child(globalAppId).child("locations").child(self.locationId!).removeValue()
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "No, Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func photoButtonPressed() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UITextField Delegate Functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case streetAddressTF:
            cityTF.becomeFirstResponder()
        case cityTF:
            zipcodeTF.becomeFirstResponder()
        case zipcodeTF:
            stateTF.becomeFirstResponder()
        case stateTF:
            textField.resignFirstResponder()
            mainButtonPressed()
        default:
            textField.resignFirstResponder()
        }
        return (true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - UIImagePickerController Delegate Functions
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.locationImage.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.locationImage.image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}

