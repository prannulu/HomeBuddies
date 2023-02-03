//
//  User.swift
//  HomeBuddies
//
//  Created by Pavi Rannulu on 1/26/23.
//

import Foundation

struct User: Identifiable {
    var id: String
    var firstName: String
    var lastName: String
    var pronouns: String? = ""
    var birthday: [String : String]? = [:]
    var emergencyContact: [String : String]? = [:]
    var medicalInfo: String? = ""
    var profilePic: String? = ""
    
    var currentHouse: String? = ""
    
    
}
