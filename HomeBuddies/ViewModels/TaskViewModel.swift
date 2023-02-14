//
//  TaskViewModel.swift
//  HomeBuddies
//
//  Created by Pavi Rannulu on 2/2/23.
//

import Foundation
import Firebase

class TaskViewModel: ObservableObject {
    @Published var taskList = [Task]()
    
    func loadTasks(houseID: String) {
        print("running loadTasks")
        if houseID == "" {
            print("running getTask, but houseID empty")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("Tasks")
            .whereField("houseID", isEqualTo: houseID.lowercased())
            //.whereField("status", isNotEqualTo: "completed")
            .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var tasksLoaded = [Task]()
                for document in querySnapshot!.documents {
                    if document.data()["status"] as! String != "completed"{
                        tasksLoaded.append(Task(id: document.documentID,
                                                description: document.data()["description"] as! String,
                                                houseID: houseID,
                                                createdBy: document.data()["createdBy"] as! String,
                                                notes: document.data()["notes"] as? String,
                                                assignedTo: document.data()["assignedTo"] as! String,
                                                status: document.data()["status"] as? String))
                        
                    }
                }
                self.taskList = tasksLoaded
            }
        }
    }
    
    func getTaskUpdates(houseID: String){
        print("running getTaskUpdates")
        if houseID == "" {
            print("running getTask, but houseID empty")
            return
        }
        
        let db = Firestore.firestore()
        
        db.collection("Tasks")
            .whereField("houseID", isEqualTo: houseID.lowercased())
            //.whereField("status", isNotEqualTo: "completed")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                var tasksLoaded = [Task]()
                for document in documents {
                    if document.data()["status"] as! String != "completed"{
                        tasksLoaded.append(Task(id: document.documentID,
                                                description: document.data()["description"] as! String,
                                                houseID: houseID,
                                                createdBy: document.data()["createdBy"] as? String ?? "",
                                                notes: document.data()["notes"] as? String ?? "",
                                                assignedTo: document.data()["assignedTo"] as? String ?? "",
                                                status: document.data()["status"] as? String
                                               ))
                    }
                    }
                self.taskList = tasksLoaded
            }
    }
    
    func addNewTask(houseID: String, description: String, creatorID: String, notes: String){
        print("running addNewTask")
        if houseID == "" {
            print("running getTask, but houseID empty")
            return
        }
        let db = Firestore.firestore()
        db.collection("Tasks").addDocument(data: [
            "houseID": houseID,
            "description": description,
            "createdBy": creatorID,
            "notes": notes,
            "assignedTo": "",
            "status": "Not yet started"
        ]) { err in
            if let err = err {
                print("Error adding task to DB: \(err)")
            } else {
                print("Add task to DB successfully!")
            }
        }
    }
    
    func deleteTask(taskID: String){
        print("running deleteTask")
        let db = Firestore.firestore()
        db.collection("Tasks").document(taskID).delete() { err in
            if let err = err {
                print("Error deleting task from DB: \(err)")
            } else {
                print("Deleted task from DB successfully!")
            }
        }
    }
    
    func editTask(taskID: String, notes: String){
        print("running editTask")
        let db = Firestore.firestore()
        db.collection("Tasks").document(taskID).setData(["notes": notes], merge: true) { err in
            if let err = err {
                print("Error adding note to task: \(err)")
            } else {
                print("Notes added to task")
            }
        }
    }
    func updateStatus(taskID: String, status: String){
        print("running updateStatus")
        let db = Firestore.firestore()
        db.collection("Tasks").document(taskID).setData(["status": status], merge: true) { err in
            if let err = err {
                print("Error adding status to task: \(err)")
            } else {
                print("Status added to task")
            }
        }
    }
    
    func assignTaskTo(taskID: String, userID: String){
        print("running assignTaskTo")
        let db = Firestore.firestore()
        db.collection("Tasks").document(taskID).setData(["assignedTo": userID], merge: true) { err in
            if let err = err {
                print("Error adding user to house: \(err)")
            } else {
                print("Task Assigned to user")
            }
        }
    }
    
    func getTasksForUser(userID: String) -> [Task] {
        var tasksForUser = [Task]()
        for task in taskList {
            if task.assignedTo == userID {
                tasksForUser.append(task)
            }
        }
        return tasksForUser
    }
    
    func unassignTasks(userID: String) {
        let db = Firestore.firestore()
        for task in taskList {
            if task.assignedTo == userID {
                db.collection("Tasks").document(task.id).setData(["assignedTo": ""], merge: true) { err in
                    if let err = err {
                        print("Error adding user to house: \(err)")
                    } else {
                        print("Task unassigned from user")
                    }
                }
            }
        }
        self.taskList = [Task]()
    }
}
