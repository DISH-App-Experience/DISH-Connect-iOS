//
//  FeatureModel.swift
//  DISH Connect
//
//  Created by JJ Zapata on 4/6/21.
//

import Foundation

struct Feature {
    
    var name : String
    var isOn : Bool
    var imageName : String
    
    init(name: String, isOn: Bool, imageName: String) {
        self.name = name
        self.isOn = isOn
        self.imageName = imageName
    }
    
}
