//
//  CustomizeThemeController.swift
//  DISH Connect
//
//  Created by JJ Zapata on 4/6/21.
//

import UIKit
import Firebase
import MBProgressHUD

class CustomizeThemeController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIColorPickerViewControllerDelegate {

    // MARK: - Constants

    let imagePickerController = UIImagePickerController()

    // MARK: - Variables

    var users = [Customer]()

    var selected : ColorProperty?

    // MARK: - View Objects

    let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor(named: "backgroundColor")!
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    let squareView1 : CustomImageView = {
        let view = CustomImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.image = UIImage(named: "unknownLogo")
        view.contentMode = UIView.ContentMode.scaleAspectFill
        view.backgroundColor = UIColor(named: "secondaryBackground")!
        return view
    }()

    let squareView2 : UIButton = {
        let view = UIButton(type: UIButton.ButtonType.system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor.clear
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.mainBlue.cgColor
        view.setTitle("Upload Logo", for: UIControl.State.normal)
        view.setTitleColor(UIColor.mainBlue, for: UIControl.State.normal)
        view.titleLabel!.font = UIFont.boldSystemFont(ofSize: 17)
        view.addTarget(self, action: #selector(uploadLogoImageButtonPressed), for: UIControl.Event.touchUpInside)
        return view
    }()

    let textFieldDesc : UILabel = {
        let label = UILabel()
        label.text = "Theme Color (Main Color)"
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor(named: "mainTextColor")!
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let themeColorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "mainTextColor")!.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let themeButton : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Change", for: UIControl.State.normal)
        button.setTitleColor(UIColor.mainBlue, for: UIControl.State.normal)
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.mainBlue.cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.layer.borderWidth = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(col1Selected), for: UIControl.Event.touchUpInside)
        return button
    }()

    let textFieldDesc2 : UILabel = {
        let label = UILabel()
        label.text = "Background Color (Normally White)"
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor(named: "mainTextColor")!
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let backgroundColorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "mainTextColor")!.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let backgroundButton : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Change", for: UIControl.State.normal)
        button.setTitleColor(UIColor.mainBlue, for: UIControl.State.normal)
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.mainBlue.cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.layer.borderWidth = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(col2Selected), for: UIControl.Event.touchUpInside)
        return button
    }()

    let textFieldDesc3 : UILabel = {
        let label = UILabel()
        label.text = "Text Color (Presented on Background Color)"
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor(named: "mainTextColor")!
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let textColorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "mainTextColor")!.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let textButton : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Change", for: UIControl.State.normal)
        button.setTitleColor(UIColor.mainBlue, for: UIControl.State.normal)
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.mainBlue.cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.layer.borderWidth = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(col3Selected), for: UIControl.Event.touchUpInside)
        return button
    }()

    let textFieldDesc4 : UILabel = {
        let label = UILabel()
        label.text = "Text Color (Presented on Theme Color)"
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor(named: "mainTextColor")!
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let textButtonColorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "mainTextColor")!.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let textButtonButton : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Change", for: UIControl.State.normal)
        button.setTitleColor(UIColor.mainBlue, for: UIControl.State.normal)
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.mainBlue.cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.layer.borderWidth = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(col4Selected), for: UIControl.Event.touchUpInside)
        return button
    }()

    let textFieldDesc5 : UILabel = {
        let label = UILabel()
        label.text = "Secondary Background (Background For Smaller Views)"
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor(named: "mainTextColor")!
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let secondaryBackgroundView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "mainTextColor")!.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let secondaryBackgroundButton : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Change", for: UIControl.State.normal)
        button.setTitleColor(UIColor.mainBlue, for: UIControl.State.normal)
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.mainBlue.cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.layer.borderWidth = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(col5Selected), for: UIControl.Event.touchUpInside)
        return button
    }()

    lazy var colorPicker: UIColorPickerViewController = {
        let picker = UIColorPickerViewController()
        picker.delegate = self
        return picker
    }()

    // MARK: - Overriden Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.backgroundColor = UIColor(named: "backgroundColor")!

        navigationItem.title = "Customize Theme"

        updateViewConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = UIColor.mainBlue
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.backButtonTitle = "Back"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.saveInformmation))
        MBProgressHUD.hide(for: self.view, animated: true)

        backend()
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()

        constraints()
    }

    // MARK: - Private Functions

    private func constraints() {

        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.size.width - 50, height: 800)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        scrollView.addSubview(squareView1)
        squareView1.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30).isActive = true
        squareView1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        squareView1.widthAnchor.constraint(equalToConstant: (self.view.frame.size.width / 2) - 37.5).isActive = true
        squareView1.heightAnchor.constraint(equalToConstant: (self.view.frame.size.width / 2) - 37.5).isActive = true

        scrollView.addSubview(squareView2)
        squareView2.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30).isActive = true
        squareView2.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        squareView2.widthAnchor.constraint(equalToConstant: (self.view.frame.size.width / 2) - 37.5).isActive = true
        squareView2.heightAnchor.constraint(equalToConstant: (self.view.frame.size.width / 2) - 37.5).isActive = true

        scrollView.addSubview(textFieldDesc)
        textFieldDesc.topAnchor.constraint(equalTo: squareView1.bottomAnchor, constant: 17).isActive = true
        textFieldDesc.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        textFieldDesc.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        textFieldDesc.heightAnchor.constraint(equalToConstant: 25).isActive = true

        scrollView.addSubview(themeButton)
        themeButton.topAnchor.constraint(equalTo: textFieldDesc.bottomAnchor, constant: 6).isActive = true
        themeButton.widthAnchor.constraint(equalToConstant: 95).isActive = true
        themeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        themeButton.heightAnchor.constraint(equalToConstant: 39).isActive = true

        scrollView.addSubview(themeColorView)
        themeColorView.topAnchor.constraint(equalTo: textFieldDesc.bottomAnchor, constant: 6).isActive = true
        themeColorView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        themeColorView.rightAnchor.constraint(equalTo: themeButton.leftAnchor, constant: -10).isActive = true
        themeColorView.heightAnchor.constraint(equalToConstant: 39).isActive = true

        scrollView.addSubview(textFieldDesc2)
        textFieldDesc2.topAnchor.constraint(equalTo: themeColorView.bottomAnchor, constant: 17).isActive = true
        textFieldDesc2.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        textFieldDesc2.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        textFieldDesc2.heightAnchor.constraint(equalToConstant: 25).isActive = true

        scrollView.addSubview(backgroundButton)
        backgroundButton.topAnchor.constraint(equalTo: textFieldDesc2.bottomAnchor, constant: 6).isActive = true
        backgroundButton.widthAnchor.constraint(equalToConstant: 95).isActive = true
        backgroundButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        backgroundButton.heightAnchor.constraint(equalToConstant: 39).isActive = true

        scrollView.addSubview(backgroundColorView)
        backgroundColorView.topAnchor.constraint(equalTo: textFieldDesc2.bottomAnchor, constant: 6).isActive = true
        backgroundColorView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        backgroundColorView.rightAnchor.constraint(equalTo: backgroundButton.leftAnchor, constant: -10).isActive = true
        backgroundColorView.heightAnchor.constraint(equalToConstant: 39).isActive = true

        scrollView.addSubview(textFieldDesc3)
        textFieldDesc3.topAnchor.constraint(equalTo: backgroundColorView.bottomAnchor, constant: 17).isActive = true
        textFieldDesc3.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        textFieldDesc3.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        textFieldDesc3.heightAnchor.constraint(equalToConstant: 25).isActive = true

        scrollView.addSubview(textButton)
        textButton.topAnchor.constraint(equalTo: textFieldDesc3.bottomAnchor, constant: 6).isActive = true
        textButton.widthAnchor.constraint(equalToConstant: 95).isActive = true
        textButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        textButton.heightAnchor.constraint(equalToConstant: 39).isActive = true

        scrollView.addSubview(textColorView)
        textColorView.topAnchor.constraint(equalTo: textFieldDesc3.bottomAnchor, constant: 6).isActive = true
        textColorView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        textColorView.rightAnchor.constraint(equalTo: textButton.leftAnchor, constant: -10).isActive = true
        textColorView.heightAnchor.constraint(equalToConstant: 39).isActive = true

        scrollView.addSubview(textFieldDesc4)
        textFieldDesc4.topAnchor.constraint(equalTo: textColorView.bottomAnchor, constant: 17).isActive = true
        textFieldDesc4.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        textFieldDesc4.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        textFieldDesc4.heightAnchor.constraint(equalToConstant: 25).isActive = true

        scrollView.addSubview(textButtonButton)
        textButtonButton.topAnchor.constraint(equalTo: textFieldDesc4.bottomAnchor, constant: 6).isActive = true
        textButtonButton.widthAnchor.constraint(equalToConstant: 95).isActive = true
        textButtonButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        textButtonButton.heightAnchor.constraint(equalToConstant: 39).isActive = true

        scrollView.addSubview(textButtonColorView)
        textButtonColorView.topAnchor.constraint(equalTo: textFieldDesc4.bottomAnchor, constant: 6).isActive = true
        textButtonColorView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        textButtonColorView.rightAnchor.constraint(equalTo: textButton.leftAnchor, constant: -10).isActive = true
        textButtonColorView.heightAnchor.constraint(equalToConstant: 39).isActive = true

        scrollView.addSubview(textFieldDesc5)
        textFieldDesc5.topAnchor.constraint(equalTo: textButtonColorView.bottomAnchor, constant: 17).isActive = true
        textFieldDesc5.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        textFieldDesc5.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        textFieldDesc5.heightAnchor.constraint(equalToConstant: 25).isActive = true

        scrollView.addSubview(secondaryBackgroundButton)
        secondaryBackgroundButton.topAnchor.constraint(equalTo: textFieldDesc5.bottomAnchor, constant: 6).isActive = true
        secondaryBackgroundButton.widthAnchor.constraint(equalToConstant: 95).isActive = true
        secondaryBackgroundButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        secondaryBackgroundButton.heightAnchor.constraint(equalToConstant: 39).isActive = true

        scrollView.addSubview(secondaryBackgroundView)
        secondaryBackgroundView.topAnchor.constraint(equalTo: textFieldDesc5.bottomAnchor, constant: 6).isActive = true
        secondaryBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        secondaryBackgroundView.rightAnchor.constraint(equalTo: secondaryBackgroundButton.leftAnchor, constant: -10).isActive = true
        secondaryBackgroundView.heightAnchor.constraint(equalToConstant: 39).isActive = true
    }

    func backend() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Database.database().reference().child("Apps").child(globalAppId).child("theme").child("themeColor").observe(DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? String {
                self.themeColorView.backgroundColor = UIColor(hexString: value)
            }
        }
        Database.database().reference().child("Apps").child(globalAppId).child("theme").child("backgroundColor").observe(DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? String {
                self.backgroundColorView.backgroundColor = UIColor(hexString: value)
            }
        }
        Database.database().reference().child("Apps").child(globalAppId).child("theme").child("textColor").observe(DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? String {
                self.textColorView.backgroundColor = UIColor(hexString: value)
            }
        }
        Database.database().reference().child("Apps").child(globalAppId).child("theme").child("themeColorOnButton").observe(DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? String {
                self.textButtonColorView.backgroundColor = UIColor(hexString: value)
            }
        }
        Database.database().reference().child("Apps").child(globalAppId).child("theme").child("secondaryBackground").observe(DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? String {
                self.secondaryBackgroundView.backgroundColor = UIColor(hexString: value)
            } else {
                self.secondaryBackgroundView.backgroundColor = UIColor(hexString: "#F2F2F2")
            }
        }
        Database.database().reference().child("Apps").child(globalAppId).child("appIcon").observe(DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? String {
                self.squareView1.loadImageUsingUrlString(urlString: value)
            }
        }
        MBProgressHUD.hide(for: self.view, animated: true)
    }

    // MARK: - Objective-C Functions

    @objc func uploadLogoImageButtonPressed() {
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }

    @objc func saveInformmation() {
        MBProgressHUD.showAdded(to: view, animated: true)

        Database.database().reference().child("Apps").child(globalAppId).child("theme").child("themeColor").setValue(self.themeColorView.backgroundColor?.toHexString())
        Database.database().reference().child("Apps").child(globalAppId).child("theme").child("backgroundColor").setValue(self.backgroundColorView.backgroundColor?.toHexString())
        Database.database().reference().child("Apps").child(globalAppId).child("theme").child("textColor").setValue(self.textColorView.backgroundColor?.toHexString())
        Database.database().reference().child("Apps").child(globalAppId).child("theme").child("themeColorOnButton").setValue(self.textButtonColorView.backgroundColor?.toHexString())
        Database.database().reference().child("Apps").child(globalAppId).child("theme").child("secondaryBackground").setValue(self.secondaryBackgroundView.backgroundColor?.toHexString())

        guard let imageData = squareView1.image?.jpegData(compressionQuality: 0.75) else { return }
        let storageRef = Storage.storage().reference()
        let storageProfileRef = storageRef.child("App").child(globalAppId).child("appIcon")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        storageProfileRef.putData(imageData, metadata: metadata) { (storageMetadata, putDataError) in
            if putDataError == nil && storageMetadata != nil {
                storageProfileRef.downloadURL { (url, downloadUrlError) in
                    if let metalImageUrl = url?.absoluteString {
                        Database.database().reference().child("Apps").child(globalAppId).child("appIcon").setValue(metalImageUrl, withCompletionBlock: { (addInfoError, result) in
                            if addInfoError == nil {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                let alert = UIAlertController(title: "Success", message: "Your information has been saved!", preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { (action) in
                                    self.navigationController?.popViewController(animated: true)
                                }))
                                self.present(alert, animated: true, completion: nil)
                            } else {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                let alert = UIAlertController(title: "Error", message: addInfoError?.localizedDescription, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        })
                    } else {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        let alert = UIAlertController(title: "Error", message: "There was an error processing your request", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)
                let alert = UIAlertController(title: "Error", message: putDataError?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    @objc func col1Selected() {
        selected = ColorProperty.themeColor
        present(colorPicker, animated: true, completion: nil)
    }

    @objc func col2Selected() {
        selected = ColorProperty.backgroundColor
        present(colorPicker, animated: true, completion: nil)
    }

    @objc func col3Selected() {
        selected = ColorProperty.textColor
        present(colorPicker, animated: true, completion: nil)
    }

    @objc func col4Selected() {
        selected = ColorProperty.textButtonColor
        present(colorPicker, animated: true, completion: nil)
    }

    @objc func col5Selected() {
        selected = ColorProperty.secondaryBackgroundColor
        present(colorPicker, animated: true, completion: nil)
    }

    // MARK: - UIImagePickerController Delegate Functions

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            self.squareView1.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage{
            self.squareView1.image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - UIColorPickerViewController Delegate Functions

    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        switch selected! {
        case ColorProperty.themeColor:
            themeColorView.backgroundColor = viewController.selectedColor
        case ColorProperty.backgroundColor:
            backgroundColorView.backgroundColor = viewController.selectedColor
        case ColorProperty.textColor:
            textColorView.backgroundColor = viewController.selectedColor
        case ColorProperty.textButtonColor:
            textButtonColorView.backgroundColor = viewController.selectedColor
        case ColorProperty.secondaryBackgroundColor:
            secondaryBackgroundView.backgroundColor = viewController.selectedColor
        }
    }

}
