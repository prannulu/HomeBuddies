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
    @Published var updates = [String]()
    
    func resetHouse() {
        self.myHouse =  House(id: "", code: "")
        self.foundHouse = nil
        self.roommates = [User]()
        self.updates = [String]()
    }
    
    func findHouse(houseID: String){
        print("running findHouse")
        if houseID == "" {
            self.foundHouse = false
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
    
    func getAndSetHouse(houseID: String, completion:(()->Void)? = nil)  {
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
                    updates: document["updates"] as? [String] ?? [])
                    self.foundHouse = true
                    if let completion = completion {
                        completion()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.foundHouse = false
                }
            }
        }
    }
    
    func addNewHouse(houseID: String, houseCode: String) {
        print("running addNewHouse")
        let db = Firestore.firestore()
        db.collection("Houses").document(houseID.lowercased()).setData(["code": houseCode, "updates": ["The \(houseID) house was created!"]]) { err in
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
                                                lastName: document.data()["lastName"] as! String,
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
                                                lastName: document.data()["lastName"] as! String,
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
    
    func addUpdate(update: String) {
        let db = Firestore.firestore()
        var updates = [String]()
        db.collection("Houses").document(myHouse.id).getDocument { document, error in
            if let document = document, document.exists {
                print(document["updates"] ?? ["somethingwrong"])
                for update in document["updates"] as! [String]{
                    updates.append(update)
                }
                
            } else {
                print("error occured when adding update: \(update)")
            }
        }
        updates.append(update)
        print(updates)
        
        db.collection("Houses").document(myHouse.id).updateData(["updates": FieldValue.arrayUnion([update])]){ err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                self.myHouse.updates = updates
                self.updates = updates
            }
        }
    }
    func getHouseUpdate() {
        print("running getRoommateUpdates")
        var newUpdates = [String]()
        let db = Firestore.firestore()
        
        db.collection("Houses").document(myHouse.id)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                
                for update in document["updates"] as! [String]{
                    newUpdates.append(update)
                }
                newUpdates.reverse()

                self.updates = newUpdates
            }
            
        }
    
    func clearHouseUpdate(clearedBy: String) {
        print("running clearHouseUpdate")
        let db = Firestore.firestore()
        
        db.collection("Houses").document(myHouse.id)
            .setData(["updates":["\(clearedBy) has cleared the House Feed"]], merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                self.updates = ["\(clearedBy) has cleared the House Feed"]
                self.myHouse.updates = ["\(clearedBy) has cleared the House Feed"]
            }
        }
    }
}
