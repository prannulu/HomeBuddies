//
//  Task.swift
//  HomeBuddies
//
//  Created by Pavi Rannulu on 2/2/23.
//

import Foundation

struct Task: Identifiable {
    var id: String
    var description: String
    var houseID: String
    var createdBy: String
    var notes: String? = "N/A"
    var assignedTo: String
    var status: String? = "Not yet started"
}
