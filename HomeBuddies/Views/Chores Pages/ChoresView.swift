//
//  ChoresView.swift
//  HomeBuddies
//
//  Created by Pavi Rannulu on 2/2/23.
//

import SwiftUI

struct ChoresView: View {
    @EnvironmentObject var houseModel: ViewOneHouse
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var taskModel: TaskViewModel
    @State private var showAddTask: Bool = false
    @ObservedObject private var taskOwner = UserViewModel()
    
    var body: some View {
        NavigationView {
            ZStack{
                Text("Name: \(userModel.user.firstName)")
                
                List(self.taskModel.taskList) { task in
                    VStack{
                        ExpandTaskView(task: task)
//                        
                       
                    }
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            withAnimation(.linear(duration: 0.3)) {showAddTask.toggle()}
                            
                        } label: {
                            let buttonText = showAddTask ? "-" : "+"
                            
                            Text(buttonText)
                                .font(.system(.largeTitle))
                                .frame(width: 77, height: 70)
                                .foregroundColor(Color.white)
                                .padding(.bottom, 7)
                        }
                        .background(Color.blue)
                        .cornerRadius(38.5)
                        .padding()
                        .shadow(color: Color.black.opacity(0.3),
                                radius: 3,
                                x: 3,
                                y: 3)
                    }
                }
            }
        }
        AddTaskView(show: $showAddTask)
            .navigationTitle("Chores List for \(houseModel.myHouse.id)")
    }
    }



struct ChoresView_Previews: PreviewProvider {
    static var previews: some View {
        ChoresView()
    }
}
