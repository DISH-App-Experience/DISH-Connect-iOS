//
//  RequestController.swift
//  DISH Connect
//
//  Created by JJ Zapata on 7/26/21.
//

import UIKit
import Firebase

class RequestController: UIViewController {
    
    var request : Reservation? {
        didSet {
            if let request = request {
                if let recipient = request.recipient {
                    Database.database().reference().child("Apps").child(globalAppId).child("Users").child(recipient).child("firstName").observe(DataEventType.value) { firstNameSnap in
                        if let firstNameValue = firstNameSnap.value as? String {
                            Database.database().reference().child("Apps").child(globalAppId).child("Users").child(recipient).child("lastName").observe(DataEventType.value) { lastNameSnap in
                                if let lastNameValue = lastNameSnap.value as? String {
                                    self.titleLabel.text = "\(firstNameValue) \(lastNameValue)"
                                }
                            }
                        }
                    }
                    if let day = request.startTime {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                        let date = formatter.date(from: day)
                        
                        let secondFormatter = DateFormatter()
                        secondFormatter.dateFormat = "EEEE, MMM d, yyyy"
                        
                        dateLabel.text = secondFormatter.string(from: date!)
                    }
                    if let time = request.startTime {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                        let date = formatter.date(from: time)
                        
                        let secondFormatter = DateFormatter()
                        secondFormatter.dateFormat = "h:mma"
                        
                        timeLabel.text = secondFormatter.string(from: date!)
                    }
                    if let seats = request.numberOfSeats {
                        seatsLabel.text = "\(seats) Seats"
                    }
                    
                }
            }
        }
    }
    
    private let bigView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let acceptButton : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("👍 Accept", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(accepted), for: UIControl.Event.touchUpInside)
        button.backgroundColor = UIColor(hexString: "#DAEBFF")
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let declineButton : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("👎 Decline", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(declined), for: UIControl.Event.touchUpInside)
        button.backgroundColor = UIColor(hexString: "#DAEBFF")
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    private let dateHolderLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.text = "Date"
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    private let timeHolderLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.text = "Time"
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    private let seatsHolderLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.text = "Number of Seats"
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    private let dateLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.text = "Date"
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    
    private let timeLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.text = "Time"
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    
    private let seatsLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.text = "Number of Seats"
        label.textAlignment = NSTextAlignment.right
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.mainBlue
        
        updateViewConstraints()

        // Do any additional setup after loading the view.
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        view.addSubview(bigView)
        bigView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bigView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60).isActive = true
        bigView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 110).isActive = true
        bigView.heightAnchor.constraint(equalToConstant: view.frame.size.height - 600).isActive = true
        
        bigView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: bigView.topAnchor, constant: 16).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: bigView.leftAnchor, constant: 16).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: bigView.rightAnchor, constant: -16).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        bigView.addSubview(dateHolderLabel)
        dateHolderLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        dateHolderLabel.leftAnchor.constraint(equalTo: bigView.leftAnchor, constant: 16).isActive = true
        dateHolderLabel.rightAnchor.constraint(equalTo: bigView.rightAnchor, constant: -16).isActive = true
        dateHolderLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        bigView.addSubview(timeHolderLabel)
        timeHolderLabel.topAnchor.constraint(equalTo: dateHolderLabel.bottomAnchor).isActive = true
        timeHolderLabel.leftAnchor.constraint(equalTo: bigView.leftAnchor, constant: 16).isActive = true
        timeHolderLabel.rightAnchor.constraint(equalTo: bigView.rightAnchor, constant: -16).isActive = true
        timeHolderLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        bigView.addSubview(seatsHolderLabel)
        seatsHolderLabel.topAnchor.constraint(equalTo: timeHolderLabel.bottomAnchor).isActive = true
        seatsHolderLabel.leftAnchor.constraint(equalTo: bigView.leftAnchor, constant: 16).isActive = true
        seatsHolderLabel.rightAnchor.constraint(equalTo: bigView.rightAnchor, constant: -16).isActive = true
        seatsHolderLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        bigView.addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: bigView.leftAnchor, constant: 16).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: bigView.rightAnchor, constant: -16).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        bigView.addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: dateHolderLabel.bottomAnchor).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: bigView.leftAnchor, constant: 16).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: bigView.rightAnchor, constant: -16).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        bigView.addSubview(seatsLabel)
        seatsLabel.topAnchor.constraint(equalTo: timeHolderLabel.bottomAnchor).isActive = true
        seatsLabel.leftAnchor.constraint(equalTo: bigView.leftAnchor, constant: 16).isActive = true
        seatsLabel.rightAnchor.constraint(equalTo: bigView.rightAnchor, constant: -16).isActive = true
        seatsLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(acceptButton)
        acceptButton.topAnchor.constraint(equalTo: bigView.bottomAnchor, constant: 16).isActive = true
        acceptButton.leftAnchor.constraint(equalTo: bigView.leftAnchor).isActive = true
        acceptButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        acceptButton.widthAnchor.constraint(equalToConstant: ((view.frame.size.height - 470) / 2) - 60).isActive = true
        
        view.addSubview(declineButton)
        declineButton.topAnchor.constraint(equalTo: bigView.bottomAnchor, constant: 16).isActive = true
        declineButton.rightAnchor.constraint(equalTo: bigView.rightAnchor).isActive = true
        declineButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        declineButton.widthAnchor.constraint(equalToConstant: ((view.frame.size.height - 470) / 2) - 60).isActive = true
    }
    
    @objc func accepted() {
        let alert = UIAlertController(title: "Sure to accept this invitation?", message: "Your recipient will be notified", preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "Yes, Accept", style: UIAlertAction.Style.default, handler: { action in
            if let recipient = self.request?.recipient {
                self.actionNotifyAndPop(recipient: recipient, status: RequestProperty.accepted)
            }
        }))
        alert.addAction(UIAlertAction(title: "No, Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func declined() {
        let alert = UIAlertController(title: "Sure to decline this invitation?", message: "Your recipient will be notified", preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "Yes, Decline", style: UIAlertAction.Style.default, handler: { action in
            if let recipient = self.request?.recipient {
                self.actionNotifyAndPop(recipient: recipient, status: RequestProperty.declined)
            }
        }))
        alert.addAction(UIAlertAction(title: "No, Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func actionNotifyAndPop(recipient uid: String, status: RequestProperty) {
        if let key = request?.key {
            if status == RequestProperty.accepted {
                Database.database().reference().child("Apps").child(globalAppId).child("reservations").child(key).child("status").setValue("accepted") { error, ref in
                    if error == nil {
                        Database.database().reference().child("Apps").child(globalAppId).child("Users").child(self.request!.recipient!).child("fcmToken").observe(DataEventType.value) { snapshot in
                            if let fcmValue = snapshot.value as? String {
                                PushNotificationSender().sendPushNotification(to: fcmValue, title: "Reservation Request Update", body: "Your reservation has been accepted! See you then!")
                            }
                        }
                        let alert = UIAlertController(title: "Success", message: "Your customer has been notified of their reservation", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { action in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        self.simpleAlert(title: "Error", message: error!.localizedDescription)
                    }
                }
            } else {
                Database.database().reference().child("Apps").child(globalAppId).child("reservations").child(key).child("status").setValue("declined") { error, ref in
                    if error == nil {
                        Database.database().reference().child("Apps").child(globalAppId).child("Users").child(self.request!.recipient!).child("fcmToken").observe(DataEventType.value) { snapshot in
                            if let fcmValue = snapshot.value as? String {
                                PushNotificationSender().sendPushNotification(to: fcmValue, title: "Reservation Request Update", body: "Your reservation has been declined, please open the Reservations tab to see more information.")
                            }
                        }
                        let alert = UIAlertController(title: "Success", message: "Your customer has been notified of their reservation", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { action in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        self.simpleAlert(title: "Error", message: error!.localizedDescription)
                    }
                }
            }
        } else {
            simpleAlert(title: "Error", message: "Reservation does not have valid key.")
        }
    }

}
