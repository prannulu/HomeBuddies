//
//  ExpandTaskView.swift
//  HomeBuddies
//
//  Created by Pavi Rannulu on 2/3/23.
//

import SwiftUI

struct ExpandTaskView: View {
    var task : Task
    @State private var isExpanded = false
    @EnvironmentObject var taskModel: TaskViewModel
    @EnvironmentObject var houseModel: ViewOneHouse
    @EnvironmentObject var userModel: UserViewModel

    @State private var showingDeleteAlert = false
    @State private var showingEditView: Bool = false
    @State private var notesDraft = ""
    @State private var selectedUser = User(id: "", firstName: "", lastName: "")
    
    var body: some View {
        if isExpanded == false {
            HStack {
                VStack(alignment: .leading){
                    Text(task.description).bold()
                    let assignedPerson = findFirstName(userID: task.assignedTo)
                    if assignedPerson == "" {
                        Text("Needs to be assigned").italic().foregroundColor(Color.themeAccent)
                    } else {
                        Text("Assigned to: \(assignedPerson)").italic().foregroundColor(Color.themeTertiary)
                    }
                }
                Image(systemName: "chevron.right.2")
                    .onTapGesture {
                        isExpanded.toggle()
                    }
            }
        } else {
            VStack(alignment: .leading, spacing: 10){
                HStack {
                    Text(task.description).bold().font(.title2)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .onTapGesture {
                            isExpanded.toggle()
                        }
                }
                Text("Created by: \(findFirstName(userID:task.createdBy))")
                Text("Status: \(task.status ?? "Not started yet")")
                if showingEditView == true {
                    editTaskView
                    
                } else {
                    previewTaskView
                }
            }
        }
    }
    
    var editTaskView : some View {
        VStack(alignment: .leading){
            // texteditor for notes
            HStack {
                Text("Notes:")
                TextEditor(text: $notesDraft)
                    .onAppear{notesDraft = task.notes ?? ""}
                    .frame(height: 100)
                    .overlay( /// apply a rounded border
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.themeAccent, lineWidth: 2).opacity(0.3)
                    )
            }
            // assigned to is a picker
            VStack {
                Picker("Assign to:", selection: $selectedUser) {
                    ForEach(houseModel.roommates) { roommate in
                        Text(roommate.firstName).tag(roommate)
                    }
                    Text("Not assigned").tag(User(id: "", firstName: "", lastName: ""))
                }
                if selectedUser.id != task.assignedTo {
                    if selectedUser.id != "" {
                    Text("This task will be assigned to: \(selectedUser.firstName)").foregroundColor(.green)
                    } else {
                        Text("This task will be unassigned").foregroundColor(.red)
                    }
                }
            }.onAppear{
                for roommate in houseModel.roommates {
                    if task.assignedTo == roommate.id {
                        selectedUser = roommate
                    } else if task.assignedTo == "" {
                        selectedUser = User(id: "", firstName: "", lastName: "")
                    }
                }
            }
            
            Button("Save changes") {
                taskModel.editTask(taskID: task.id, notes: notesDraft)
                taskModel.assignTaskTo(taskID: task.id, userID: selectedUser.id)
                houseModel.addUpdate(update: "✏️ \(userModel.user.firstName) made changes to task: \(task.description)")
                showingEditView = false
            }
            Spacer()
            Button("Discard changes"){
                showingEditView = false
            }
            Spacer()
            
            Button("Delete Task"){
                showingDeleteAlert = true
            }.alert(isPresented:$showingDeleteAlert) {
                Alert(
                    title: Text("Are you sure you want to delete this task?"),
                    message: Text("There is no way to undo this. All task information will be deleted"),
                    primaryButton: .destructive(Text("Delete")) {
                        taskModel.deleteTask(taskID: task.id)
                        houseModel.addUpdate(update: "🗑️ \(userModel.user.firstName) deleted task: \(task.description)")
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .buttonStyle(.bordered)
        .padding()
        .cornerRadius(20) /// make the background rounded
        .overlay( /// apply a rounded border
            RoundedRectangle(cornerRadius: 20)
                //.stroke(.pink.opacity(0.2), lineWidth: 5)
                .foregroundColor(Color.themeSecondary).opacity(0.2)
                
        )
    }
    
    var previewTaskView : some View {
        VStack (alignment: .leading){
            let assignedPerson = findFirstName(userID: task.assignedTo)
            if assignedPerson == "" {
                Text("Needs to be assigned").italic().foregroundColor(.themeAccent)
            } else {
                Text("Assigned to: \(assignedPerson)").italic().foregroundColor(.themeTertiary)
            }
            if task.notes != "" {
                HStack {
                    Text("Notes: ").bold()
                    Text("\(task.notes ?? "N/A")")
                }
            }
            Button("Edit Task"){
                showingEditView.toggle()
            }.buttonStyle(.bordered).padding()
            
        }
    }
    
    func findFirstName (userID: String) -> String {
        var name = ""
        for roommate in houseModel.roommates {
            if roommate.id == userID {
                name = roommate.firstName
            }
        }
        return name
    }
}

//struct ExpandTaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExpandTaskView()
//    }
//}
