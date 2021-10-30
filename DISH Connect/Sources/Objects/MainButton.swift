//
//  MainButton.swift
//  DISH Connect
//
//  Created by JJ Zapata on 4/12/21.
//

import Foundation
import UIKit

class MainButton : UIButton {
    
    init(title buttonTitle: String) {
        super.init(frame: .zero)
        
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel?.textColor = UIColor.white
        
        layer.cornerRadius = 10
        
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = UIColor.mainBlue
        
        addTarget(self, action: #selector(effects), for: UIControl.Event.touchUpInside)
        
        setTitle(buttonTitle, for: UIControl.State.normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("error fatal")
    }
    
    @objc func effects() {
        add3DMotion(withFeedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle.light)
    }
    
}
