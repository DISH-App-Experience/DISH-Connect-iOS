//
//  LocationsCell.swift
//  DISH Connect
//
//  Created by JJ Zapata on 4/10/21.
//

import UIKit
import MapKit

class LocationsCell: UICollectionViewCell {
    
    let mapView : MKMapView = {
        let mapView = MKMapView()
        mapView.isScrollEnabled = false
        mapView.isUserInteractionEnabled = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    let firstServiceView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "secondaryBackground")!
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let firstServiceImage : MainImageView = {
        let imageView = MainImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.mainBlue
        return imageView
    }()
    
    let firstTitle : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "mainTextColor")!
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "Title"
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        addSubview(firstServiceView)
        firstServiceView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        firstServiceView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        firstServiceView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        firstServiceView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        
        firstServiceView.addSubview(firstServiceImage)
        firstServiceImage.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        firstServiceImage.layer.cornerRadius = 25
        firstServiceImage.clipsToBounds = true
        firstServiceImage.topAnchor.constraint(equalTo: firstServiceView.topAnchor).isActive = true
        firstServiceImage.leftAnchor.constraint(equalTo: firstServiceView.leftAnchor).isActive = true
        firstServiceImage.rightAnchor.constraint(equalTo: firstServiceView.rightAnchor).isActive = true
        firstServiceImage.bottomAnchor.constraint(equalTo: firstServiceView.bottomAnchor, constant: -44).isActive = true
        
        firstServiceView.addSubview(firstTitle)
        firstTitle.topAnchor.constraint(equalTo: firstServiceImage.bottomAnchor, constant: 7).isActive = true
        firstTitle.leftAnchor.constraint(equalTo: firstServiceView.leftAnchor, constant: 12).isActive = true
        firstTitle.rightAnchor.constraint(equalTo: firstServiceView.rightAnchor, constant: -12).isActive = true
        firstTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func isNil() {
        firstServiceView.addSubview(mapView)
        mapView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        mapView.layer.cornerRadius = 25
        mapView.clipsToBounds = true
        mapView.topAnchor.constraint(equalTo: firstServiceView.topAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: firstServiceView.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: firstServiceView.rightAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: firstServiceView.bottomAnchor, constant: -44).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
