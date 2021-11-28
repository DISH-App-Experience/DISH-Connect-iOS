//
//  ReservationsRequestsCell.swift
//  DISH Connect
//
//  Created by JJ Zapata on 7/26/21.
//

import UIKit

class ReservationsRequestsCell: UITableViewCell {
    
    // MARK: - Constants
    
    static let identifier : String = "ReservationsRequestsCellREUSEID"
    
    // MARK: - Variables
    
    var reservation : Reservation? {
        didSet {
            if let reservation = reservation {
                if let lastName = reservation.userId {
                    lastNameLabel.text = lastName
                }
                if let time = reservation.startTime {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    let date = formatter.date(from: time)
                    
                    let secondFormatter = DateFormatter()
                    secondFormatter.dateFormat = "MMM. d h:mma"
                    
                    startTimeLabel.text = secondFormatter.string(from: date!)
                }
                if let seats = reservation.numberOfSeats {
                    seatsLabel.text = "\(seats) Seats"
                }
            }
        }
    }
    
    // MARK: - View Objects
    
    let lastNameLabel : UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "mainTextColor")!
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let startTimeLabel : UILabel = {
        let label = UILabel()
        label.text = "Time"
//        label.backgroundColor = .orange
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "mainTextColor")!
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let seatsLabel : UILabel = {
        let label = UILabel()
        label.text = "Seats"
//        label.backgroundColor = .yellow
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "mainTextColor")!
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let viewMoreLabel : UILabel = {
        let label = UILabel()
        label.text = "View More"
        label.textAlignment = NSTextAlignment.right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.mainBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    // MARK: - Overriden Functions
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = UITableViewCell.SelectionStyle.none
        
        backgroundColor = UIColor(named: "backgroundColor")!
        
        addSubview(lastNameLabel)
        lastNameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        lastNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        lastNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        lastNameLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        addSubview(startTimeLabel)
        startTimeLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        startTimeLabel.leftAnchor.constraint(equalTo: lastNameLabel.rightAnchor).isActive = true
        startTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        startTimeLabel.widthAnchor.constraint(equalToConstant: 115).isActive = true
        
        addSubview(seatsLabel)
        seatsLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        seatsLabel.leftAnchor.constraint(equalTo: startTimeLabel.rightAnchor).isActive = true
        seatsLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        seatsLabel.widthAnchor.constraint(equalToConstant: 75).isActive = true
        
        addSubview(viewMoreLabel)
        viewMoreLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        viewMoreLabel.leftAnchor.constraint(equalTo: seatsLabel.rightAnchor).isActive = true
        viewMoreLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        viewMoreLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

}
