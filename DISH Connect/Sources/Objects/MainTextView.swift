//
//  MainTextView.swift
//  DISH Connect
//
//  Created by JJ Zapata on 4/12/21.
//

import UIKit

class MainTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        tintColor = UIColor.mainBlue
        
        backgroundColor = UIColor(named: "textFieldBackground")!
        
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError()
    }
    
}
