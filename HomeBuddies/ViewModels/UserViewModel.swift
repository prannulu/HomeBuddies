//
//  UserViewModel.swift
//  HomeBuddies
//
//  Created by Pavi Rannulu on 1/26/23.
//

import Foundation
import Firebase

class UserViewModel: ObservableObject {
    @Published var user = User(id: "", firstName: "", lastName: "")
    @Published var userExists: Bool?
    
    func getUser(userID: String, completion: ((User)->Void)? = nil){
        print("running getUser")
        let db = Firestore.firestore()
        
        let userRef = db.collection("Users").document(userID)
        
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                DispatchQueue.main.async {
                    self.user = User(id: document.documentID,
                                     firstName: document["firstName"] as? String ?? "",
                                     lastName: document["lastName"] as? String ?? "",
                                     pronouns: document["pronouns"] as? String ?? "",
                                     birthday: document["birthday"] as? [String:String] ?? [:],
                                     emergencyContact: document["emergencyContact"] as? [String:String] ?? [:],
                                     medicalInfo: document["medicalInfo"] as? String ?? "",
                                     profilePic: document["profilePic"] as? String ?? "",
                                     currentHouse: document["currentHouse"] as? String ?? "")
                    
                    self.userExists = true
                    if let completion = completion {
                        completion(self.user)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.userExists = false
                }
            }
        }
    }
    func addAndGetUser(userID: String, firstName: String, lastName: String){
        print("running addAndGetUser")
        let db = Firestore.firestore()
        db.collection("Users").document(userID).setData(["firstName" : firstName, "lastName": lastName]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                self.user = User(id: userID,
                                 firstName: firstName,
                                 lastName: lastName)
            }
        }
    }
    
    func addToRequestedHouse(houseID: String, houseCode: String, completion:((Bool)->Void)?) {
        print("running addToRequestedHouse")
        if houseID == "" {
            return
        }
        let db = Firestore.firestore()
        let houseRef = db.collection("Houses").document(houseID.lowercased())
        
        houseRef.getDocument { document, error in
            if let document = document, document.exists {
                let codeMatches = document["code"] as! String == houseCode
                if codeMatches{
                    db.collection("Users").document(self.user.id).setData(["currentHouse" : houseID], merge: true) { err in
                        if let err = err {
                            print("Error adding user to house: \(err)")
                        } else {
                            print("User added to house")
                            DispatchQueue.main.async {
                                self.user.currentHouse = houseID
                            }
                        }
                    }
                }
                if let completion = completion {
                    completion(codeMatches)
                }
            }
        }
    }
    
    func addCurrentHouse(houseID: String) {
        print("running addCurrentHouse")
        let db = Firestore.firestore()
        db.collection("Users").document(self.user.id).setData(["currentHouse" : houseID.lowercased()], merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                self.user.currentHouse = houseID
            }
        }
    }
    
    func addNameAndPronouns(firstName: String, lastName: String, pronouns: String) {
        print("running addNameAndPronouns")
        let db = Firestore.firestore()
        db.collection("Users").document(self.user.id).setData(["firstName":firstName, "lastName":lastName, "pronouns" : pronouns], merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                self.user.firstName = firstName
                self.user.lastName = lastName
                self.user.pronouns = pronouns
            }
        }
    }
    
    func addBirthday(year: String, month: String, day: String) {
        print("running addBirthday")
        let db = Firestore.firestore()
        let birthdayDict = ["year": year, "month": month, "day": day]
        db.collection("Users").document(self.user.id)
            .setData(["birthday" : birthdayDict], merge: true) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                    self.user.birthday = birthdayDict
                }
            }
    }
    
    func addEmergencyContact(name: String, info: String, relationship: String) {
        print("running addEmergencyContact")
        let db = Firestore.firestore()
        let emergencyContactDict = ["name": name, "info": info, "relationship": relationship]
        db.collection("Users").document(self.user.id)
            .setData(["emergencyContact" : emergencyContactDict], merge: true) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                    self.user.emergencyContact = emergencyContactDict
                }
            }
    }
    
    func addMedicalInfo(medicalInfo: String) {
        print("running addMedicalInfo")
        let db = Firestore.firestore()
        db.collection("Users").document(self.user.id).setData(["medicalInfo" : medicalInfo], merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                self.user.medicalInfo = medicalInfo
            }
        }
    }
    
    func addProfilePic(profilePicName: String) {
        print("running addProfilePic")
        let db = Firestore.firestore()
        db.collection("Users").document(self.user.id).setData(["profilePic" : profilePicName], merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                self.user.profilePic = profilePicName
            }
        }
    }
}
