//
//  ViewOneHouse.swift
//  HomeBuddies
//
//  Created by Pavi Rannulu on 1/26/23.
//

import Foundation
import Firebase

class ViewOneHouse: ObservableObject {
    @Published var myHouse = House(id: "", roommates: [:])
    @Published var foundHouse: Bool?
    
    func getAndSetHouse(houseID: String)  {
        if houseID == "" {
            return
        }
        
        let db = Firestore.firestore()
        
        let houseRef = db.collection("Houses").document(houseID.lowercased())
        
        houseRef.getDocument { document, error in
            if let document = document, document.exists {
                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                DispatchQueue.main.async {
                    self.myHouse = House(id: document.documentID,
                                         nickname: document["nickname"] as? String ?? "",
                                         roommates: document["roommates"] as? [String:String] ?? [:],
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
    
    func addNewHouse(houseID: String, creatorID: String, creatorName: String) {
        let db = Firestore.firestore()
        db.collection("Houses").document(houseID.lowercased()).setData(["roommates": [creatorID:creatorName]]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func addRoommate(userID: String, firstName: String){
        let db = Firestore.firestore()
        db.collection("Houses").document(self.myHouse.id).updateData(["roommates": FieldValue.arrayUnion([[userID:firstName]])]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}
