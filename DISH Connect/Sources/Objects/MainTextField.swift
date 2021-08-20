//
//  MainTextField.swift
//  DISH Connect
//
//  Created by JJ Zapata on 4/12/21.
//

import Foundation
import UIKit

class MainTextField: UITextField {
    
    let insets : UIEdgeInsets

    init(insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12), placeholderString: String) {
        self.insets = insets
        super.init(frame: CGRect.zero)
        
        let placeholderStringAttr = NSAttributedString(string: placeholderString, attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "placeholderColor")!])
        
        textColor = UIColor(named: "mainTextColor")!
        
        attributedPlaceholder = placeholderStringAttr
        
        tintColor = UIColor.mainBlue
        
        backgroundColor = UIColor(named: "textFieldBackground")!
        
        borderStyle = BorderStyle.none
        
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not yet been implemented")
    }
    
}
