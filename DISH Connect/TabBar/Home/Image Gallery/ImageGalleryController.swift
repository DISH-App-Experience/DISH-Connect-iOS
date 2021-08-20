//
//  ImageGalleryController.swift
//  DISH Connect
//
//  Created by JJ Zapata on 4/6/21.
//

import UIKit
import Firebase
import MBProgressHUD

class ImageGalleryController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    var imagePicker = UIImagePickerController()
    
    var photos = [Photo]()
    
    var collectionView : UICollectionView?
    
    // MARK: - View Objects
    
    let nilView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nilImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emptyPhoto")!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        return imageView
    }()
    
    let nilTitleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "mainTextColor")!
        label.text = "Nothing in the gallery\nAdd some images now!"
        label.numberOfLines = 3
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    let floatingActionButton : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setImage(UIImage(systemName: "plus"), for: UIControl.State.normal)
        button.tintColor = UIColor.white
        button.layer.cornerRadius = 28
        button.backgroundColor = UIColor.mainBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addFABTapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    // MARK: - Overriden Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        title = "Image Gallery"
        
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
        guard let collectionView = collectionView else { return }
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(named: "backgroundColor")
        collectionView.register(ImageGalleryCell.self, forCellWithReuseIdentifier: ImageGalleryCell.identifier)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(floatingActionButton)
        floatingActionButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
        floatingActionButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        floatingActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        floatingActionButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
    }
    
    private func backend() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        photos.removeAll()
        Database.database().reference().child("Apps").child(globalAppId).child("photos").observe(DataEventType.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let photo = Photo()
                photo.image = value["url"] as? String ?? "nil"
                photo.key = value["key"] as? String ?? "nil"
                self.photos.append(photo)
            }
            self.collectionView!.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    private func delegates() {
        collectionView!.delegate = self
        collectionView!.dataSource = self
    }
    
    private func showNilValue() {
        view.addSubview(nilView)
        nilView.widthAnchor.constraint(equalToConstant: 249).isActive = true
        nilView.heightAnchor.constraint(equalToConstant: 232).isActive = true
        nilView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        nilView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        nilView.addSubview(nilImageView)
        nilImageView.topAnchor.constraint(equalTo: nilView.topAnchor).isActive = true
        nilImageView.leftAnchor.constraint(equalTo: nilView.leftAnchor).isActive = true
        nilImageView.rightAnchor.constraint(equalTo: nilView.rightAnchor).isActive = true
        nilImageView.heightAnchor.constraint(equalToConstant: 161).isActive = true
        
        nilView.addSubview(nilTitleLabel)
        nilTitleLabel.topAnchor.constraint(equalTo: nilImageView.bottomAnchor).isActive = true
        nilTitleLabel.leftAnchor.constraint(equalTo: nilImageView.leftAnchor).isActive = true
        nilTitleLabel.rightAnchor.constraint(equalTo: nilImageView.rightAnchor).isActive = true
        nilTitleLabel.bottomAnchor.constraint(equalTo: nilView.bottomAnchor).isActive = true
    }
    
    private func hideNilValue() {
        nilView.removeFromSuperview()
    }
    
    private func uploadImage(_ image: UIImage) {
        MBProgressHUD.showAdded(to: view, animated: true)
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let storageRef = Storage.storage().reference()
        let metadata = StorageMetadata()
        let key = Database.database().reference().child("Apps").child(globalAppId).child("photos").childByAutoId().key
        let storageProfileRef = storageRef.child(key!)
        metadata.contentType = "image/jpg"
        storageProfileRef.putData(imageData, metadata: metadata) { (storageMetadata, putDataError) in
            if putDataError == nil && storageMetadata != nil {
                storageProfileRef.downloadURL { (url, downloadUrlError) in
                    if let metalImageUrl = url?.absoluteString {
                        self.completion(withUrlString: metalImageUrl, key: key!)
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
    }
    
    private func completion(withUrlString url: String, key: String) {
        let values : [String : Any] = [
            "key" : key,
            "url" : url
        ]
        Database.database().reference().child("Apps").child(globalAppId).child("photos").child(key).updateChildValues(values) { (error, red) in
            if let error = error {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.simpleAlert(title: "Error", message: error.localizedDescription)
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)
                let alert = UIAlertController(title: "Success", message: "Your Image Has Been Uploaded", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { (action) in
                    self.backend()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Objective-C Functions
    
    @objc func addFABTapped() {
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UICollectionView Delegate & Data Source Functions
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photos.count == 0 {
            showNilValue()
            return 0
        } else {
            hideNilValue()
            return photos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageGalleryCell.identifier, for: indexPath) as! ImageGalleryCell
        cell.photoView.loadImage(from: URL(string: photos[indexPath.row].image!)!)
        print(photos[indexPath.row].image!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let half = self.view.frame.size.width / 2
        return CGSize(width: half - 35, height: half - 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = ViewPhotoController()
        controller.photo = photos[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - UIImagePickerController Delegate Functions
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            uploadImage(editedImage)
            dismiss(animated: true, completion: nil)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            uploadImage(originalImage)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: backend)
    }

}
