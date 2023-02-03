//
//  ViewOneHouse.swift
//  HomeBuddies
//
//  Created by Pavi Rannulu on 1/26/23.
//

import Foundation
import Firebase

class ViewOneHouse: ObservableObject {
    @Published var myHouse = House(id: "", code: "", roommates: [ : ])
    @Published var foundHouse: Bool?
    
    func findHouse(houseID: String){
        print("running findHouse")
        if houseID == "" {
            return
        }
        let db = Firestore.firestore()
        
        db.collection("Houses").document(houseID.lowercased()).getDocument { document, error in
            if let document = document, document.exists {
                self.foundHouse = true
            } else {
                self.foundHouse = false
            }
        }
    }
    
    func getAndSetHouse(houseID: String)  {
        print("running getAndSetHouse")
        if houseID == "" {
            print("running getAndSetHouse but houseID empty")
            return
        }
        
        let db = Firestore.firestore()
        
        let houseRef = db.collection("Houses").document(houseID.lowercased())
        
        houseRef.getDocument { document, error in
            if let document = document, document.exists {
                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                DispatchQueue.main.async {
                    self.myHouse = House(id: document.documentID,
                                         code: document["code"] as! String,
                                         roommates: document["roommates"] as? [String:String] ?? [:],
                                         nickname: document["nickname"] as? String ?? "",
                                         pets: document["pets"] as? Bool ?? false)
                    //print("Document data: \(dataDescription)")
                    self.foundHouse = true
                }
            } else {
                DispatchQueue.main.async {
                    //print("Document does not exist")
                    self.foundHouse = false
                }
            }
        }
    }
    
    func addNewHouse(houseID: String, houseCode: String, creatorID: String, creatorName: String) {
        print("running addNewHouse")
        let db = Firestore.firestore()
        db.collection("Houses").document(houseID.lowercased()).setData(["roommates": [creatorID:creatorName], "code": houseCode]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func addRoommate(houseCode: String, userID: String, firstName: String){
        print("running addRoommate")
        if houseCode != myHouse.code {
            return
        }
        var roommates = ["":""]
        let db = Firestore.firestore()
        let houseRef = db.collection("Houses").document(self.myHouse.id.lowercased())
        houseRef.getDocument { document, error in
            if let document = document, document.exists {
                roommates = document["roommates"] as? [String:String] ?? ["":""]
                
                roommates[userID] = firstName
                houseRef.setData(["roommates": roommates], merge: true) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("roommate successfully added to house!")
                    }
                }
            }
        }
    }
    func removeRoommate(userID: String){
        print("running removeRoommate")
        var roommates = ["":""]
        let db = Firestore.firestore()
        let houseRef = db.collection("Houses").document(self.myHouse.id.lowercased())
        houseRef.getDocument { document, error in
            if let document = document, document.exists {
                roommates = document["roommates"] as? [String:String] ?? ["":""]
                roommates.removeValue(forKey: userID)
                houseRef.setData(["roommates": roommates], merge: true) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("roommate successfully removed from house!")
                    }
                }
            }
        }
    }
}
