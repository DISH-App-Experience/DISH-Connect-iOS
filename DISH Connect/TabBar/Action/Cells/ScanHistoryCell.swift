//
//  ScanHistoryCell.swift
//  DISH Connect
//
//  Created by JJ Zapata on 8/9/21.
//

import UIKit
import Firebase

class ScanHistoryCell: UITableViewCell {
    
    static let identifier = "ScanHistoryCellIdentifier"
    
    var scan : Scan? {
        didSet {
            if let scan = scan {
                if let scanner = scan.userId {
                    Database.database().reference().child("Apps").child(globalAppId).child("Users").child(scanner).child("lastName").observe(DataEventType.value) { lastNameSnap in
                        Database.database().reference().child("Apps").child(globalAppId).child("Users").child(scanner).child("firstName").observe(DataEventType.value) { firstNameSnap in
                            if let firstName = firstNameSnap.value as? String, let lastName = lastNameSnap.value as? String {
                                self.itemTitleLabel.text = "\(firstName) \(lastName)"
                            }
                        }
                    }
                }
                if let timeScanned = scan.time {
                    let formatter = RelativeDateTimeFormatter()
                    formatter.unitsStyle = .full
                    let relativeDate = formatter.localizedString(for: Date(timeIntervalSince1970: TimeInterval(timeScanned)), relativeTo: Date())
                    self.itemDescLabel.text = relativeDate
                }
            }
        }
    }
    
    let largeView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "textFieldBackground")!
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        return view
    }()
    
    let itemTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor(named: "mainTextColor")!
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let itemDescLabel : UILabel = {
        let label = UILabel()
        label.text = "Desc"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(named: "placeholderColor")!
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = UITableViewCell.SelectionStyle.none
        
        backgroundColor = UIColor(named: "backgroundColor")!
        
        addSubview(largeView)
        largeView.topAnchor.constraint(equalTo: topAnchor, constant: 7).isActive = true
        largeView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        largeView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        largeView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7).isActive = true
        
        addSubview(itemTitleLabel)
        itemTitleLabel.topAnchor.constraint(equalTo: largeView.topAnchor, constant: 15).isActive = true
        itemTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 13).isActive = true
        itemTitleLabel.rightAnchor.constraint(equalTo: largeView.rightAnchor, constant: -22).isActive = true
        itemTitleLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        addSubview(itemDescLabel)
        itemDescLabel.topAnchor.constraint(equalTo: itemTitleLabel.bottomAnchor, constant: 1).isActive = true
        itemDescLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 13).isActive = true
        itemDescLabel.rightAnchor.constraint(equalTo: largeView.rightAnchor, constant: -22).isActive = true
        itemDescLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
