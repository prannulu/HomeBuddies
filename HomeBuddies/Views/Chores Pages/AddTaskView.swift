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
    
    var body: some View {
        ZStack {
            if show {
                    // PopUp background color
                    Color.green.opacity(show ? 0.3 : 0)
                    .edgesIgnoringSafeArea(.all)
                    .cornerRadius(2)
                    // PopUp Window
                    VStack(alignment: .center, spacing: 0) {
                        Text("Add New Task")
                            .frame(maxWidth: .infinity)
                            .frame(height: 45, alignment: .center)
                            .font(Font.system(size: 23, weight: .semibold))
                            .foregroundColor(Color.white)
                        TextField("Description", text: $description)
                            .multilineTextAlignment(.center)
                            .font(Font.system(size: 16, weight: .semibold))
                            .padding(EdgeInsets(top: 20, leading: 25, bottom: 20, trailing: 25))
                            .foregroundColor(Color.white)
                        Button(action: {
                            // Add task to backend
                            taskModel.addNewTask(houseID: houseModel.myHouse.id, description: description, creatorID: userModel.user.id)
                            print(description)
                            description = ""
                            withAnimation(.linear(duration: 0.3)) {
                                show = false
                            }
                        }, label: {
                            Text("Create new task")
                                .frame(width: 200, height: 40)
                                .background(RoundedRectangle(cornerRadius: 10, style:.continuous).fill(.linearGradient(colors:[.green, .white], startPoint: .top, endPoint: .bottomTrailing)))
                                .foregroundColor(.black)
                                .bold()
                        }).buttonStyle(PlainButtonStyle())
                    }
                    .frame(maxWidth: 300)
                    .border(Color.white, width: 2)
                }
            }
        }
    }


//struct AddTaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTaskView()
//    }
//}
