//
//  MenuItemPhotoSettingsController.swift
//  DISH Connect
//
//  Created by JJ Zapata on 12/29/21.
//

import UIKit
import Firebase

class MenuItemPhotoSettingsController: UIViewController {
    
    var usesImages = true
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "mainTextColor")!
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.center
        label.text = "Which Menu UI Suits Best?"
        return label
    }()
    
    private let bigView1 : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor(named: "imageBackgroundColor")!
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bigView2 : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor(named: "imageBackgroundColor")!
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let subheading1 : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "mainTextColor")!
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.center
        label.text = "With Images"
        return label
    }()
    
    private let subheading2 : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "mainTextColor")!
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.center
        label.text = "Without Images"
        return label
    }()
    
    private let withImageImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "withMenuImage")!
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        return imageView
    }()
    
    private let withoutImageImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "withoutMenuImage")!
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        return imageView
    }()
    
    private let checkButton1 : UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(selectsYes), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let checkButton2 : UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(selectsNo), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let bigButton1 : UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(selectsYes), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let bigButton2 : UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(selectsNo), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "backgroundColor")!
        
        backend()
        updateViewConstraints()

        // Do any additional setup after loading the view.
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 75).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 31).isActive = true
        
        view.addSubview(bigView1)
        bigView1.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        bigView1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        bigView1.heightAnchor.constraint(equalToConstant: 300).isActive = true
        bigView1.widthAnchor.constraint(equalToConstant: ((self.view.frame.size.width - 75) / 2)).isActive = true
        
        view.addSubview(bigView2)
        bigView2.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        bigView2.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        bigView2.heightAnchor.constraint(equalToConstant: 300).isActive = true
        bigView2.widthAnchor.constraint(equalToConstant: ((self.view.frame.size.width - 75) / 2)).isActive = true
        
        bigView1.addSubview(subheading1)
        subheading1.topAnchor.constraint(equalTo: bigView1.topAnchor, constant: 12).isActive = true
        subheading1.leftAnchor.constraint(equalTo: bigView1.leftAnchor).isActive = true
        subheading1.rightAnchor.constraint(equalTo: bigView1.rightAnchor).isActive = true
        subheading1.heightAnchor.constraint(equalToConstant: 13).isActive = true
        
        bigView2.addSubview(subheading2)
        subheading2.topAnchor.constraint(equalTo: bigView2.topAnchor, constant: 12).isActive = true
        subheading2.leftAnchor.constraint(equalTo: bigView2.leftAnchor).isActive = true
        subheading2.rightAnchor.constraint(equalTo: bigView2.rightAnchor).isActive = true
        subheading2.heightAnchor.constraint(equalToConstant: 13).isActive = true
        
        bigView1.addSubview(withImageImageView)
        withImageImageView.topAnchor.constraint(equalTo: subheading1.bottomAnchor, constant: 12).isActive = true
        withImageImageView.leftAnchor.constraint(equalTo: bigView1.leftAnchor, constant: 12).isActive = true
        withImageImageView.rightAnchor.constraint(equalTo: bigView1.rightAnchor, constant: -12).isActive = true
        withImageImageView.heightAnchor.constraint(equalToConstant: 179).isActive = true
        
        bigView2.addSubview(withoutImageImageView)
        withoutImageImageView.topAnchor.constraint(equalTo: subheading2.bottomAnchor, constant: 12).isActive = true
        withoutImageImageView.leftAnchor.constraint(equalTo: bigView2.leftAnchor, constant: 12).isActive = true
        withoutImageImageView.rightAnchor.constraint(equalTo: bigView2.rightAnchor, constant: -12).isActive = true
        withoutImageImageView.heightAnchor.constraint(equalToConstant: 166).isActive = true
        
        bigView1.addSubview(checkButton1)
        checkButton1.bottomAnchor.constraint(equalTo: bigView1.bottomAnchor, constant: -24).isActive = true
        checkButton1.centerXAnchor.constraint(equalTo: withImageImageView.centerXAnchor).isActive = true
        checkButton1.heightAnchor.constraint(equalToConstant: 30).isActive = true
        checkButton1.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        bigView2.addSubview(checkButton2)
        checkButton2.bottomAnchor.constraint(equalTo: bigView2.bottomAnchor, constant: -24).isActive = true
        checkButton2.centerXAnchor.constraint(equalTo: withoutImageImageView.centerXAnchor).isActive = true
        checkButton2.heightAnchor.constraint(equalToConstant: 30).isActive = true
        checkButton2.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        bigView1.addSubview(bigButton1)
        bigButton1.topAnchor.constraint(equalTo: bigView1.topAnchor).isActive = true
        bigButton1.leftAnchor.constraint(equalTo: bigView1.leftAnchor).isActive = true
        bigButton1.rightAnchor.constraint(equalTo: bigView1.rightAnchor).isActive = true
        bigButton1.bottomAnchor.constraint(equalTo: bigView1.bottomAnchor).isActive = true
        
        bigView2.addSubview(bigButton2)
        bigButton2.topAnchor.constraint(equalTo: bigView2.topAnchor).isActive = true
        bigButton2.leftAnchor.constraint(equalTo: bigView2.leftAnchor).isActive = true
        bigButton2.rightAnchor.constraint(equalTo: bigView2.rightAnchor).isActive = true
        bigButton2.bottomAnchor.constraint(equalTo: bigView2.bottomAnchor).isActive = true
    }
    
    private func backend() {
        Database.database().reference().child("Apps").child(globalAppId).child("usesMenuImages").observeSingleEvent(of: DataEventType.value) { snapshot in
            if let value = snapshot.value as? Bool {
                self.setCheckMarks(usesImages: value)
            } else {
                self.setCheckMarks(usesImages: true)
            }
        }
    }
    
    private func setCheckMarks(usesImages bool: Bool) {
        switch bool {
        case true:
            checkButton1.setImage(UIImage(named: "selected"), for: UIControl.State.normal)
            checkButton2.setImage(UIImage(named: "unselected"), for: UIControl.State.normal)
        case false:
            checkButton1.setImage(UIImage(named: "unselected"), for: UIControl.State.normal)
            checkButton2.setImage(UIImage(named: "selected"), for: UIControl.State.normal)
        }
    }
    
    @objc func selectsYes() {
        self.usesImages = true
        self.setCheckMarks(usesImages: self.usesImages)
        Database.database().reference().child("Apps").child(globalAppId).child("usesMenuImages").setValue(self.usesImages)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func selectsNo() {
        usesImages = false
        setCheckMarks(usesImages: usesImages)
        Database.database().reference().child("Apps").child(globalAppId).child("usesMenuImages").setValue(usesImages)
        self.dismiss(animated: true, completion: nil)
    }

}
