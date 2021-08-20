//
//  ManageFeatureCell.swift
//  DISH Connect
//
//  Created by JJ Zapata on 4/6/21.
//

import UIKit

class ManageFeatureCell: UITableViewCell {
    
    let iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let title : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "mainTextColor")!
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        return label
    }()
    
    let switcher : UISwitch = {
        let switcher = UISwitch()
        switcher.isOn = true
        switcher.translatesAutoresizingMaskIntoConstraints = false
        return switcher
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(iconImageView)
        iconImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        contentView.addSubview(switcher)
        switcher.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        switcher.heightAnchor.constraint(equalToConstant: 31).isActive = true
        switcher.widthAnchor.constraint(equalToConstant: 51).isActive = true
        switcher.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        contentView.addSubview(title)
        title.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 12).isActive = true
        title.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        title.widthAnchor.constraint(equalToConstant: 200).isActive = true
        title.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
        backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
