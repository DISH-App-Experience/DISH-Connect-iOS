//
//  EventsDetailController.swift
//  DISH Connect
//
//  Created by JJ Zapata on 4/27/21.
//

import UIKit
import Firebase
import Foundation
import CoreLocation
import MBProgressHUD

class EventsDetailController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Constants
    
    let imagePicker = UIImagePickerController()
    
    let pickerView = UIPickerView()
    
    // MARK: - Variables
    
    var locations = [Location]()
    
    var ogLocation = ""
    
    var users = [Customer]()
    
    var selectedLocation : Location?
    
    var hasSelectedLocation = false
    
    var action : String? {
        didSet {
            if action == "GET" {
                title = "Edit Event"
                addRemoveButton()
                photoButton.setTitle("Edit Photo", for: UIControl.State.normal)
            } else {
                title = "Add Event"
                photoButton.setTitle("Add Photo", for: UIControl.State.normal)
            }
        }
    }
    
    var eventId : String? {
        didSet {
            backend(withItemID: eventId!)
        }
    }
    
    // MARK: - View Objects
    
    let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let locationImage : MainImageView = {
        let imageView = MainImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(named: "secondaryBackground")!
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        return imageView
    }()
    
    let streetAddressTF : MainTextField = {
        let textField = MainTextField(placeholderString: "Location")
        textField.isSecureTextEntry = false
        textField.keyboardType = UIKeyboardType.default
        return textField
    }()
    
    let cityTF : MainTextField = {
        let textField = MainTextField(placeholderString: "Name")
        textField.isSecureTextEntry = false
        textField.keyboardType = UIKeyboardType.default
        return textField
    }()
    
    let zipcodeTF : MainTextField = {
        let textField = MainTextField(placeholderString: "Start")
        textField.isSecureTextEntry = false
        textField.keyboardType = UIKeyboardType.decimalPad
        return textField
    }()
    
    let endDateTF : MainTextField = {
        let textField = MainTextField(placeholderString: "End")
        textField.isSecureTextEntry = false
        textField.keyboardType = UIKeyboardType.decimalPad
        return textField
    }()
    
    let stateTF : MainTextField = {
        let textField = MainTextField(placeholderString: "Description")
        textField.isSecureTextEntry = false
        textField.keyboardType = UIKeyboardType.default
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
        button.setTitleColor(UIColor.mainBlue, for: UIControl.State.normal)
        button.addTarget(self, action: #selector(photoButtonPressed), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let removeButton : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitle("Remove Event", for: UIControl.State.normal)
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
        checkCategories()
        
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
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: 800)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        scrollView.addSubview(locationImage)
        locationImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30).isActive = true
        locationImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        locationImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        locationImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        scrollView.addSubview(photoButton)
        photoButton.topAnchor.constraint(equalTo: locationImage.bottomAnchor, constant: 16).isActive = true
        photoButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        photoButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        photoButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(zipcodeTF)
        zipcodeTF.setInputViewDatePicker(target: self, selector: #selector(donePressed))
        zipcodeTF.topAnchor.constraint(equalTo: photoButton.bottomAnchor, constant: 30).isActive = true
        zipcodeTF.widthAnchor.constraint(equalToConstant: 135).isActive = true
        zipcodeTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        zipcodeTF.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        scrollView.addSubview(cityTF)
        cityTF.topAnchor.constraint(equalTo: photoButton.bottomAnchor, constant: 30).isActive = true
        cityTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        cityTF.rightAnchor.constraint(equalTo: zipcodeTF.leftAnchor, constant: -16).isActive = true
        cityTF.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        scrollView.addSubview(endDateTF)
        endDateTF.setInputViewDatePicker(target: self, selector: #selector(donePressedEnd))
        endDateTF.topAnchor.constraint(equalTo: cityTF.bottomAnchor, constant: 16).isActive = true
        endDateTF.widthAnchor.constraint(equalToConstant: 135).isActive = true
        endDateTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        endDateTF.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        scrollView.addSubview(streetAddressTF)
        streetAddressTF.inputView = pickerView
        streetAddressTF.topAnchor.constraint(equalTo: cityTF.bottomAnchor, constant: 16).isActive = true
        streetAddressTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        streetAddressTF.rightAnchor.constraint(equalTo: endDateTF.leftAnchor, constant: -16).isActive = true
        streetAddressTF.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        scrollView.addSubview(stateTF)
        stateTF.topAnchor.constraint(equalTo: streetAddressTF.bottomAnchor, constant: 16).isActive = true
        stateTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        stateTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        stateTF.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        scrollView.addSubview(mainButton)
        mainButton.topAnchor.constraint(equalTo: stateTF.bottomAnchor, constant: 27).isActive = true
        mainButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        mainButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    private func backend(withItemID id: String) {
        
        let root = Database.database().reference().child("Apps").child(globalAppId)
        let base = root.child("events").child(id)
        
        base.child("imageString").observe(DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? String {
                self.locationImage.loadImage(from: URL(string: value)!)
            }
        }
        
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
        
        base.child("location").observe(DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? String {
                root.child("locations").child(value).child("street").observe(DataEventType.value) { (name) in
                    self.streetAddressTF.text = name.value as? String
                }
                self.ogLocation = value
            }
        }
    }
    
    private func delegates() {
        streetAddressTF.delegate = self
        cityTF.delegate = self
        zipcodeTF.delegate = self
        endDateTF.delegate = self
        stateTF.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    private func addRemoveButton() {
        scrollView.addSubview(removeButton)
        removeButton.widthAnchor.constraint(equalToConstant: 203).isActive = true
        removeButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        removeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        removeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
    }
    
    private func continueCompletion(withImageString imageString: String, key: String, isNew: Bool) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        if isNew {
            if let location = selectedLocation?.key {
                let values : [String : Any] = [
                    "key" : key,
                    "name" : "\(self.cityTF.text!)",
                    "desc" : "\(self.stateTF.text!)",
                    "date" : Int(Date(detectFromString: self.zipcodeTF.text!)!.timeIntervalSince1970),
                    "endDate" : Int(Date(detectFromString: self.endDateTF.text!)!.timeIntervalSince1970),
                    "imageString" : imageString,
                    "location" : location
                ]
                uploadNew(withValues: values, key: key)
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)
                simpleAlert(title: "Error", message: "Please select a valid location")
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        } else {
            print("upload existing with id: " + self.eventId!)
            if hasSelectedLocation == true {
                let values : [String : Any] = [
                    "key" : self.eventId!,
                    "name" : "\(self.cityTF.text!)",
                    "desc" : "\(self.stateTF.text!)",
                    "date" : Int(Date(detectFromString: self.zipcodeTF.text!)!.timeIntervalSince1970),
                    "endDate" : Int(Date(detectFromString: self.endDateTF.text!)!.timeIntervalSince1970),
                    "imageString" : imageString,
                    "location" : selectedLocation?.key!
                ]
                self.uploadExisting(withValues: values, key: self.eventId!)
            } else {
                let values : [String : Any] = [
                    "key" : self.eventId!,
                    "name" : "\(self.cityTF.text!)",
                    "desc" : "\(self.stateTF.text!)",
                    "date" : Int(Date(detectFromString: self.zipcodeTF.text!)!.timeIntervalSince1970),
                    "endDate" : Int(Date(detectFromString: self.endDateTF.text!)!.timeIntervalSince1970),
                    "imageString" : imageString,
                    "location" : self.ogLocation
                ]
                self.uploadExisting(withValues: values, key: self.eventId!)
            }
        }
    }
    
    private func uploadExisting(withValues values: [String : Any], key: String) {
        let root = Database.database().reference().child("Apps").child(globalAppId).child("events").child(key)
        root.updateChildValues(values) { (error, ref) in
            if error != nil {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.simpleAlert(title: "Error", message: error!.localizedDescription)
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.completion(isNew: false)
            }
        }
    }
    
    private func uploadNew(withValues values: [String : Any], key: String) {
        let root = Database.database().reference().child("Apps").child(globalAppId).child("events").child(key)
        root.updateChildValues(values) { (error, ref) in
            if error != nil {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.simpleAlert(title: "Error", message: error!.localizedDescription)
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.completion(isNew: true)
            }
        }
    }
    
    private func completion(isNew: Bool) {
        if isNew {
            Database.database().reference().child("Apps").child(globalAppId).child("Users").observe(DataEventType.childAdded) { snapshot in
                if let value = snapshot.value as? [String : Any] {
                    var user = Customer()
                    user.fcm = value["fcmToken"] as! String
                    self.users.append(user)
                }
                if let datePicker = self.zipcodeTF.inputView as? UIDatePicker {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MMMM d"
                    for user in self.users {
                        PushNotificationSender().sendPushNotification(to: user.fcm!, title: self.cityTF.text! + "!", body: "What're you doing on \(formatter.string(from: datePicker.date))?")
                    }
                }
            }
            let alert = UIAlertController(title: "Success", message: "Added event", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Success", message: "Added event", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func checkCategories() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        locations.removeAll()
        Database.database().reference().child("Apps").child(globalAppId).child("locations").observe(DataEventType.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let location = Location()
                location.image = value["image"] as? String ?? "nil"
                location.long = value["long"] as? Double
                location.lat = value["lat"] as? Double
                location.street = value["street"] as? String ?? "nil"
                location.city = value["city"] as? String ?? "nil"
                location.zip = value["zip"] as? String ?? "nil"
                location.state = value["state"] as? String ?? "nil"
                location.key = snapshot.key
                if location.long != nil, location.lat != nil {
                    self.locations.append(location)
                }
            }
            self.pickerView.reloadInputViews()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    // MARK: - Objective-C Functions
    
    @objc func mainButtonPressed() {
        MBProgressHUD.showAdded(to: view, animated: true)
        if action == "GET" {
            // use key from fetched source
            guard let imageData = locationImage.image!.jpegData(compressionQuality: 0.75) else { return }
            let storageRef = Storage.storage().reference()
            let metadata = StorageMetadata()
            let root = Database.database().reference().child("Apps").child(globalAppId).child("events")
            let key = root.childByAutoId().key
            let storageProfileRef = storageRef.child(key!)
            metadata.contentType = "image/jpg"
            storageProfileRef.putData(imageData, metadata: metadata) { (storageMetadata, putDataError) in
                if putDataError == nil && storageMetadata != nil {
                    storageProfileRef.downloadURL { (url, downloadUrlError) in
                        if let metalImageUrl = url?.absoluteString {
                            self.continueCompletion(withImageString: metalImageUrl, key: key!, isNew: false)
                        } else {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            self.simpleAlert(title: "Error", message: downloadUrlError!.localizedDescription)
                        }
                    }
                } else {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.simpleAlert(title: "Error", message: putDataError!.localizedDescription)
                }
            }
        } else {
            if streetAddressTF.text != "" && cityTF.text != "" && zipcodeTF.text != "" && stateTF.text != "" {
                // image upload
                if locationImage.image != nil {
                    guard let imageData = locationImage.image!.jpegData(compressionQuality: 0.75) else { return }
                    let storageRef = Storage.storage().reference()
                    let metadata = StorageMetadata()
                    let root = Database.database().reference().child("Apps").child(globalAppId).child("menu").child("items")
                    let key = root.childByAutoId().key
                    let storageProfileRef = storageRef.child(key!)
                    metadata.contentType = "image/jpg"
                    storageProfileRef.putData(imageData, metadata: metadata) { (storageMetadata, putDataError) in
                        if putDataError == nil && storageMetadata != nil {
                            storageProfileRef.downloadURL { (url, downloadUrlError) in
                                if let metalImageUrl = url?.absoluteString {
                                    self.continueCompletion(withImageString: metalImageUrl, key: key!, isNew: true)
                                } else {
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                    self.simpleAlert(title: "Error", message: downloadUrlError!.localizedDescription)
                                }
                            }
                        } else {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            self.simpleAlert(title: "Error", message: putDataError!.localizedDescription)
                        }
                    }
                } else {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    simpleAlert(title: "Error", message: "Please choose an image to continue")
                }
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)
                simpleAlert(title: "Error", message: "Please make all fields are filled in.")
            }
        }
    }
    
    @objc func cancelPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func removeButtonTapped() {
        let alert = UIAlertController(title: "Remove?", message: "Are you sure you would like to delete this event?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action) in
            Database.database().reference().child("Apps").child(globalAppId).child("events").child(self.eventId!).removeValue()
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
    
    @objc func donePressed() {
        if let datePicker = self.zipcodeTF.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M/d @ h:mma"
            zipcodeTF.text = dateFormatter.string(from: datePicker.date)
        } else if let datePicker = self.endDateTF.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M/d @ h:mma"
            endDateTF.text = dateFormatter.string(from: datePicker.date)
        }
        zipcodeTF.resignFirstResponder()
    }
    
    @objc func donePressedEnd() {
        if let datePicker = self.endDateTF.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M/d @ h:mma"
            endDateTF.text = dateFormatter.string(from: datePicker.date)
        }
        endDateTF.resignFirstResponder()
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
    
    // MARK: - UIPickerView Delegate Functions
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locations.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return locations[row].street!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        hasSelectedLocation = true
        selectedLocation = locations[row]
        streetAddressTF.text = locations[row].street!
        if let datePicker = self.zipcodeTF.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            zipcodeTF.text = dateFormatter.string(from: datePicker.date)
        }
    }
    
}

