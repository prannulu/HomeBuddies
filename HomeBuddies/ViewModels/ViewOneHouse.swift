//
//  ViewOneHouse.swift
//  HomeBuddies
//
//  Created by Pavi Rannulu on 1/26/23.
//

import Foundation
import Firebase

class ViewOneHouse: ObservableObject {
    @Published var myHouse = House(id: "", code: "")
    @Published var foundHouse: Bool?
    @Published var roommates = [User]()
    
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
                DispatchQueue.main.async {
                    self.myHouse = House(id: document.documentID,
                                         code: document["code"] as! String,
                                         pets: document["pets"] as? Bool ?? false)
                    self.foundHouse = true
                }
            } else {
                DispatchQueue.main.async {
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
    
    func getAndSetRoommates() {
        print("running getAndSetRoommates with houseiD \(myHouse.id)")
        let db = Firestore.firestore()
        db.collection("Users").whereField("currentHouse", isEqualTo: myHouse.id.lowercased()).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var roommatesLoaded = [User]()
                for document in querySnapshot!.documents {
                    print("document EXISTS")
                    roommatesLoaded.append(User(id: document.documentID,
                                                firstName: document.data()["firstName"] as! String,
                                                lastName: "lastName",
                                                pronouns: document.data()["pronouns"] as? String ?? "",
                                                birthday: document.data()["birthday"] as? [String:String] ?? [:],
                                                emergencyContact: document.data()["emergencyContact"] as? [String:String] ?? [:],
                                                medicalInfo: document.data()["medicalInfo"] as? String ?? "",
                                                profilePic: document.data()["profilePic"] as? String ?? "",
                                                currentHouse: document.data()["currentHouse"] as? String ?? ""))
                }
                self.roommates = roommatesLoaded
                
                print(self.roommates)
            }
        }
    }
    
    func getRoommateUpdates(){
        print("running getRoommateUpdates")
        
        let db = Firestore.firestore()
        
        db.collection("Users").whereField("currentHouse", isEqualTo: myHouse.id.lowercased())
            .addSnapshotListener { querySnapshot, error in
                guard (querySnapshot?.documents) != nil else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                var roommatesLoaded = [User]()
                for document in querySnapshot!.documents {
                    roommatesLoaded.append(User(id: document.documentID,
                                                firstName: document.data()["firstName"] as! String,
                                                lastName: "lastName",
                                                pronouns: document.data()["pronouns"] as? String ?? "",
                                                birthday: document.data()["birthday"] as? [String:String] ?? [:],
                                                emergencyContact: document.data()["emergencyContact"] as? [String:String] ?? [:],
                                                medicalInfo: document.data()["medicalInfo"] as? String ?? "",
                                                profilePic: document.data()["profilePic"] as? String ?? "",
                                                currentHouse: document.data()["currentHouse"] as? String ?? ""))
                }
                self.roommates = roommatesLoaded
                
            }
    }
}
