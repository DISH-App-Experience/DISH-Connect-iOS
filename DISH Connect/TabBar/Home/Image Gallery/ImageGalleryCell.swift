//
//  ImageGalleryCell.swift
//  DISH Connect
//
//  Created by JJ Zapata on 4/12/21.
//

import UIKit

class ImageGalleryCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    static let identifier = "ImageGalleryCollectionViewCellID"
    
    // MARK: - View Objects
    
    let photoView : MainImageView = {
        let imageView = MainImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor(named: "secondaryBackground")!
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    // MARK: - Overriden Functions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(photoView)
        contentView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        photoView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
