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
    @State private var showingDeleteAlert = false
    @State private var showingEditView: Bool = false
    @State private var notesDraft = ""
    @State private var selectedUser = User(id: "", firstName: "", lastName: "")

    
    
    var body: some View {
        if isExpanded == false {
            HStack {
                VStack(alignment: .leading){
                    Text(task.description).bold()
                    if task.assignedTo == "" {
                        Text("Needs to be assigned").italic().foregroundColor(.yellow)
                    }
                }
                Image(systemName: "chevron.right.2")
                    .onTapGesture {
                        isExpanded.toggle()
                    }
            }
        } else {
            VStack(alignment: .leading, spacing: 20){
                HStack {
                    Text(task.description).bold()
                    Spacer()
                    Image(systemName: "chevron.down")
                        .onTapGesture {
                            isExpanded.toggle()
                        }
                    
                }
                
                ForEach(houseModel.roommates){ roommate in
                    if roommate.id == task.createdBy {
                        Text("Created by: \(roommate.firstName)")
                    }
                }
                    
                if showingEditView == true {
                    VStack {
                            // texteditor for notes
                        HStack {
                            Text("Notes:")
                            TextEditor(text: $notesDraft)
                                .onAppear{notesDraft = task.notes ?? ""}
                                .frame(height: 100)
                                .overlay( /// apply a rounded border
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(.gray, lineWidth: 4)
                                )
                        }
                            // assigned to is a picker
                        VStack {
                            Picker("Assign to:", selection: $selectedUser) {
                                            ForEach(houseModel.roommates) { roommate in
                                                Text(roommate.firstName).tag(roommate)
                                            }
                            }
                            Text("You selected: \(selectedUser.firstName)")
                        }
                            // save button
                        Button("Save changes") {
                            taskModel.editTask(taskID: task.id, notes: notesDraft)
                            taskModel.assignTaskTo(taskID: task.id, userID: selectedUser.id)
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
                            .stroke(.pink.opacity(0.2), lineWidth: 5)
                    )
                        
                } else {
                    VStack{
                        Text("Notes: \(task.notes ?? "N/A")")
                        ForEach(houseModel.roommates){ roommate in
                            if roommate.id == task.assignedTo {
                                Text("Assigned to: \(roommate.firstName)")
                            }
                        }
                    }
                    Button {
                        showingEditView.toggle()
                    } label: {
                        Text("Edit Task").foregroundColor(Color.blue)
                    }
                }
                }
            }
        }
    }
//struct ExpandTaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExpandTaskView()
//    }
//}
