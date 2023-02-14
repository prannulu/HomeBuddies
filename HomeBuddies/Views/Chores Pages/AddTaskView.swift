//
//  AddTaskView.swift
//  HomeBuddies
//
//  Created by Pavi Rannulu on 2/3/23.
//

import SwiftUI

struct AddTaskView: View {
    @Binding var show: Bool
    @EnvironmentObject var houseModel: ViewOneHouse
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var taskModel: TaskViewModel
    
    @State var description = ""
    @State var notes = ""
    
    var body: some View {
        ZStack {
            if show {
                    // PopUp background color
                    Color.themeSecondary.opacity(show ? 0.3 : 0)
                    .edgesIgnoringSafeArea(.all)
                    .cornerRadius(50)
                    .padding(.horizontal, 30)
                    // PopUp Window
                    VStack(alignment: .center, spacing: 0) {
                        Text("Add New Task")
                            .frame(maxWidth: .infinity)
                            .frame(height: 30, alignment: .center)
                            .font(.title2)
                            .foregroundColor(Color.black)
                            .underline()
                        HStack{
                            Text("Name of Task:")
                            TextField("Enter Description", text: $description)
                                .textFieldStyle(.plain)
                                .padding(EdgeInsets(top: 20, leading: 25, bottom: 20, trailing: 25))
                                .foregroundColor(Color.themeTertiary)
                        }
                        HStack{
                            Text("Additional notes about the task:")
                            TextField("Enter Notes (Optional)", text: $notes)
                                .textFieldStyle(.plain)
                                .padding(EdgeInsets(top: 20, leading: 25, bottom: 20, trailing: 25))
                                .foregroundColor(Color.themeTertiary)
                        }
                        Button(action: {
                            // Add task to backend
                            taskModel.addNewTask(houseID: houseModel.myHouse.id, description: description, creatorID: userModel.user.id,
                                                 notes: notes)
                            
                            houseModel.addUpdate(update: "➕ \(userModel.user.firstName) added a new task: \(description)")
                            print(description)
                            description = ""
                            notes = ""
                            withAnimation(.linear(duration: 0.3)) {
                                show = false
                            }
                        }, label: {
                            Text("Create new task")
                                .frame(width: 200, height: 40)
                                .background(RoundedRectangle(cornerRadius: 10, style:.continuous).fill(.linearGradient(colors:[Color.themeTertiary, .white], startPoint: .top, endPoint: .bottomTrailing)))
                                .foregroundColor(.black)
                                .bold()
                                .padding()
                        }).buttonStyle(PlainButtonStyle())
                            .disabled(description.isEmpty)
                    }
                   .frame(maxWidth: 300)
//                    .border(Color.white, width: 2)
                }
            }
        }
    }


//struct AddTaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTaskView()
//    }
//}
