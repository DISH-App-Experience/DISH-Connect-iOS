//
//  ViewReservationController.swift
//  DISH Connect
//
//  Created by JJ Zapata on 7/27/21.
//

import UIKit
import Firebase
import EventKit
import KVKCalendar

class ViewReservationController: UIViewController {
    
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
    }
    
}
