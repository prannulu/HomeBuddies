//
//  House.swift
//  HomeBuddies
//
//  Created by Pavi Rannulu on 1/25/23.
//

import Foundation

struct House: Identifiable {
    var id: String
    var code: String
    var roommates: [String: String]
    
    var nickname: String? = ""
    var pets: Bool? = false
}
