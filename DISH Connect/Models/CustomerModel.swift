//
//  CustomerModel.swift
//  DISH Connect
//
//  Created by JJ Zapata on 4/6/21.
//

import Foundation

//struct Customer {
//    
//    var name : String
//    var email : String
//    var fcm : String?
//    
//    init(name: String, email: String) {
//        self.name = name
//        self.email = email
//    }
//    
//}

class Customer : NSObject {
    
    var fcm : String?
    var name : String?
    var email : String?
    var gender : String?
    var birthday : String?
}
