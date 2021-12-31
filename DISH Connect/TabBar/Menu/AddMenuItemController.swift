//
//  AddMenuItemController.swift
//  DISH Connect
//
//  Created by JJ Zapata on 4/14/21.
//

import UIKit
import Firebase
import Foundation
import CoreLocation
import MBProgressHUD

class AddMenuItemController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Constants
    
    let imagePicker = UIImagePickerController()
    
    let pickerView = UIPickerView()
    
    // MARK: - Variables
    
    var categories = [Category]()
    
    var items = [MenuItem]()
    
    var selectedCategory : Category?
    
    var action : String? {
        didSet {
            if action == "GET" {
                title = "Edit Menu Item"
                addRemoveButton()
                photoButton.setTitle("Edit Photo", for: UIControl.State.normal)
            } else {
                title = "Add Menu Item"
                photoButton.setTitle("Add Photo", for: UIControl.State.normal)
            }
        }
    }
    
    var iconURL = ""
    
    var menuItemId : String? {
        didSet {
            backend(withItemID: menuItemId!)
        }
    }
    
    // MARK: - View Objects
    
    let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor.clear
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
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
        let textField = MainTextField(placeholderString: "Category")
        textField.isSecureTextEntry = false
        textField.keyboardType = UIKeyboardType.default
        return textField
    }()
    
    let cityTF : MainTextField = {
        let textField = MainTextField(placeholderString: "Title")
        textField.isSecureTextEntry = false
        textField.keyboardType = UIKeyboardType.default
        return textField
    }()
    
    let zipcodeTF : MainTextField = {
        let textField = MainTextField(placeholderString: "Price ($)")
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
    
    let scanPriceTF : MainTextField = {
        let textField = MainTextField(placeholderString: "Scan Price")
        textField.isSecureTextEntry = false
        textField.keyboardType = UIKeyboardType.numberPad
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
        button.setTitle("Remove Menu Item", for: UIControl.State.normal)
        button.setTitleColor(UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(removeButtonTapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    // MARK: - Overriden Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "backgroundColor")!
        
        Database.database().reference().child("Apps").child(globalAppId).child("appIcon").observeSingleEvent(of: DataEventType.value) { snapshot in
            if let value = snapshot.value as? String {
                self.iconURL = value
            }
        }
        
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
        scrollView.contentSize = CGSize(width: self.view.frame.size.width - 50, height: 900)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
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
        zipcodeTF.topAnchor.constraint(equalTo: photoButton.bottomAnchor, constant: 30).isActive = true
        zipcodeTF.widthAnchor.constraint(equalToConstant: 135).isActive = true
        zipcodeTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        zipcodeTF.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        scrollView.addSubview(cityTF)
        cityTF.topAnchor.constraint(equalTo: photoButton.bottomAnchor, constant: 30).isActive = true
        cityTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        cityTF.rightAnchor.constraint(equalTo: zipcodeTF.leftAnchor, constant: -16).isActive = true
        cityTF.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        scrollView.addSubview(stateTF)
        stateTF.topAnchor.constraint(equalTo: cityTF.bottomAnchor, constant: 16).isActive = true
        stateTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        stateTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        stateTF.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        scrollView.addSubview(streetAddressTF)
        streetAddressTF.inputView = pickerView
        streetAddressTF.topAnchor.constraint(equalTo: stateTF.bottomAnchor, constant: 16).isActive = true
        streetAddressTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        streetAddressTF.widthAnchor.constraint(equalToConstant: (view.frame.width - 60) / 2).isActive = true
        streetAddressTF.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        scrollView.addSubview(scanPriceTF)
        scanPriceTF.topAnchor.constraint(equalTo: stateTF.bottomAnchor, constant: 16).isActive = true
        scanPriceTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        scanPriceTF.widthAnchor.constraint(equalToConstant: (view.frame.width - 60) / 2).isActive = true
        scanPriceTF.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        scrollView.addSubview(mainButton)
        mainButton.topAnchor.constraint(equalTo: streetAddressTF.bottomAnchor, constant: 27).isActive = true
        mainButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        mainButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    private func backend(withItemID id: String) {
        print("ID")
        print(id)
        print("ID")
        
        Database.database().reference().child("Apps").child(globalAppId).child("menu").child("items").child(id).child("image").observe(DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? String {
                if value != "" {
                    self.locationImage.loadImage(from: URL(string: value)!)
                }
            }
        }
        
        Database.database().reference().child("Apps").child(globalAppId).child("menu").child("items").child(id).child("title").observe(DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? String {
                self.cityTF.text = value
            }
        }
        
        Database.database().reference().child("Apps").child(globalAppId).child("menu").child("items").child(id).child("price").observe(DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? Double {
                self.zipcodeTF.text = "\(value)"
            }
        }
        
        Database.database().reference().child("Apps").child(globalAppId).child("menu").child("items").child(id).child("description").observe(DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? String {
                self.stateTF.text = value
            }
        }
        
        Database.database().reference().child("Apps").child(globalAppId).child("menu").child("items").child(id).child("scanPrice").observe(DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? Int {
                self.scanPriceTF.text = "\(value)"
            }
        }
        
        Database.database().reference().child("Apps").child(globalAppId).child("menu").child("items").child(id).child("category").observe(DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? String {
                Database.database().reference().child("Apps").child(globalAppId).child("menu").child("categories").child(value).child("name").observe(DataEventType.value) { (name) in
                    self.streetAddressTF.text = name.value as? String
                }
            }
        }
    }
    
    private func checkCategories() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        categories.removeAll()
        Database.database().reference().child("Apps").child(globalAppId).child("menu").child("categories").observe(DataEventType.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let category = Category()
                category.name = value["name"] as? String
                category.key = value["key"] as? String
                category.selected = false
                self.categories.append(category)
            }
            self.pickerView.reloadInputViews()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    private func delegates() {
        streetAddressTF.delegate = self
        cityTF.delegate = self
        zipcodeTF.delegate = self
        stateTF.delegate = self
        scanPriceTF.delegate = self
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
    
    private func checkItems2(withImageString imageString: String, key: String, isNew: Bool) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        items.removeAll()
        Database.database().reference().child("Apps").child(globalAppId).child("menu").child("items").observe(DataEventType.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let item = MenuItem()
                item.title = value["title"] as? String
                item.desc = value["description"] as? String
                item.price = value["price"] as? Double
                item.category = value["category"] as? String
                item.image = value["image"] as? String
                item.timeStamp = value["time"] as? Int
                item.key = value["key"] as? String ?? snapshot.key
                self.items.append(item)
            }
            print("checking items done")
            
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    private func continueCompletion(withImageString imageString: String?, key: String, isNew: Bool) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        // get a new
        if isNew {
            let values : [String : Any] = [
                "key" : key,
                "title" : "\(self.cityTF.text!)",
                "description" : "\(self.stateTF.text!)",
                "price" : Double(self.zipcodeTF.text!)!,
                "category" : String(self.selectedCategory!.key!),
                "time" : Int(Date().timeIntervalSince1970),
                "scanPrice" : Int(self.scanPriceTF.text!)!,
                "image" : imageString ?? self.iconURL,
            ]
            uploadNew(withValues: values, key: key)
        } else {
            print("upload existing with id: " + menuItemId!)
            Database.database().reference().child("Apps").child(globalAppId).child("menu").child("items").child(menuItemId!).child("category").observe(DataEventType.value) { (snapshot) in
                if let string = snapshot.value as? String {
                    let values : [String : Any] = [
                        "key" : self.menuItemId!,
                        "title" : "\(self.cityTF.text!)",
                        "description" : "\(self.stateTF.text!)",
                        "price" : Double(self.zipcodeTF.text!)!,
                        "category" : String(self.selectedCategory?.key ?? string),
                        "scanPrice" : Int(self.scanPriceTF.text!)!,
                        "image" : imageString ?? self.iconURL,
                    ]
                    self.uploadExisting(withValues: values, key: self.menuItemId!)
                }
            }
        }
    }
    
    private func uploadExisting(withValues values: [String : Any], key: String) {
        let root = Database.database().reference().child("Apps").child(globalAppId).child("menu").child("items").child(key)
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
        let root = Database.database().reference().child("Apps").child(globalAppId).child("menu").child("items").child(key)
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
        print("completed")
        let alert = UIAlertController(title: "Success", message: "Added menu item", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Objective-C Functions
    
    @objc func mainButtonPressed() {
        MBProgressHUD.showAdded(to: view, animated: true)
        if action == "GET" {
            if streetAddressTF.text != "" && cityTF.text != "" && zipcodeTF.text != "" && stateTF.text != "" && scanPriceTF.text != "" {
                if locationImage.image != nil {
                    // use key from fetched source
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
                                    print("all good")
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
                    let root = Database.database().reference().child("Apps").child(globalAppId).child("menu").child("items")
                    let key = root.childByAutoId().key
                    self.continueCompletion(withImageString: nil, key: key!, isNew: false)
                }
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)
                simpleAlert(title: "Error", message: "Please make all fields are filled in.")
            }
        } else {
            if streetAddressTF.text != "" && cityTF.text != "" && zipcodeTF.text != "" && stateTF.text != "" && scanPriceTF.text != "" {
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
                                    print("all good")
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
                    let root = Database.database().reference().child("Apps").child(globalAppId).child("menu").child("items")
                    let key = root.childByAutoId().key
                    self.continueCompletion(withImageString: nil, key: key!, isNew: true)
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
        let alert = UIAlertController(title: "Remove?", message: "Are you sure you would like to delete this menu item?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action) in
            Database.database().reference().child("Apps").child(globalAppId).child("menu").child("items").child(self.menuItemId!).removeValue()
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
        return categories.count
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].name!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = categories[row]
        streetAddressTF.text = categories[row].name!
    }

}

