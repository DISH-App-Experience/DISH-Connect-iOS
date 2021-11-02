//
//  MenuCategoryDetailController.swift
//  DISH Connect
//
//  Created by JJ Zapata on 4/14/21.
//

import UIKit
import Firebase
import CoreLocation
import MBProgressHUD

class MenuCategoryDetailController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Constants
    
    let imagePicker = UIImagePickerController()
    
    // MARK: - Variables
    
    var action : String? {
        didSet {
            if action == "GET" {
                title = "Edit Category"
                addRemoveButton()
            } else {
                title = "Add Category"
                nameOfCategoryTF.becomeFirstResponder()
            }
        }
    }
    
    var categoryId : String? {
        didSet {
            print("location id set")
            backend()
        }
    }
    
    // MARK: - View Objects
    
    let nameOfCategoryTF : MainTextField = {
        let textField = MainTextField(placeholderString: "Name of Category")
        textField.isSecureTextEntry = false
        textField.keyboardType = UIKeyboardType.default
        textField.autocapitalizationType = UITextAutocapitalizationType.words
        return textField
    }()
    
    let mainButton : MainButton = {
        let button = MainButton(title: "Add")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(mainButtonPressed), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let infoLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.text = "You can add items to categories when creating menu items."
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor(named: "secondaryText")
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let removeButton : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitle("Remove Category", for: UIControl.State.normal)
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
    
    override func viewWillDisappear(_ animated: Bool) {
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
        view.addSubview(nameOfCategoryTF)
        nameOfCategoryTF.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 33).isActive = true
        nameOfCategoryTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        nameOfCategoryTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        nameOfCategoryTF.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        view.addSubview(mainButton)
        mainButton.topAnchor.constraint(equalTo: nameOfCategoryTF.bottomAnchor, constant: 27).isActive = true
        mainButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        mainButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        view.addSubview(infoLabel)
        infoLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        infoLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        infoLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -144).isActive = true
    }
    
    private func backend() {
        Database.database().reference().child("Apps").child(globalAppId).child("menu").child("categories").child(categoryId!).child("name").observe(DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? String {
                self.nameOfCategoryTF.text = value
            }
        }
    }
    
    private func delegates() {
        nameOfCategoryTF.delegate = self
    }
    
    private func addRemoveButton() {
        view.addSubview(removeButton)
        removeButton.widthAnchor.constraint(equalToConstant: 203).isActive = true
        removeButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        removeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        removeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
    }
    
    private func completion() {
        print("completed")
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Objective-C Functions
    
    @objc func mainButtonPressed() {
        if action == "GET" {
            Database.database().reference().child("Apps").child(globalAppId).child("menu").child("categories").child(categoryId!).child("name").setValue(self.nameOfCategoryTF.text!)
            MBProgressHUD.hide(for: self.view, animated: true)
            let alert = UIAlertController(title: "Success", message: "Your category was added!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            let root = Database.database().reference().child("Apps").child(globalAppId).child("menu").child("categories")
            let key = root.childByAutoId().key!
            let values : [String : Any] = [
                "key" : key,
                "name" : self.nameOfCategoryTF.text!
            ]
            let feed : [String : Any] = [
                key : values
            ]
            root.updateChildValues(feed)
            MBProgressHUD.hide(for: self.view, animated: true)
            let alert = UIAlertController(title: "Success", message: "Your category was added!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func cancelPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func removeButtonTapped() {
        let alert = UIAlertController(title: "Remove?", message: "Are you sure you would like to delete this location?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action) in
            Database.database().reference().child("Apps").child(globalAppId).child("menu").child("categories").child(self.categoryId!).removeValue()
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "No, Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
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
