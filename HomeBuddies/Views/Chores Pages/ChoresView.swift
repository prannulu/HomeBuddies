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
                Color.themeBackground
                    .edgesIgnoringSafeArea(.all)
                if self.taskModel.taskList.count == 0 {
                    VStack {
                        Text("No tasks available!").font(.title2).padding()
                        Text(Image(systemName: "info.circle")) + Text(" Click on the \"+\" to add a new task")
                    }
                } else {
                    List(self.taskModel.taskList) { task in
                        VStack{
                            ExpandTaskView(task: task)
                        }
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
                        .background(Color.themeAccent)
                        .cornerRadius(38.5)
                        .padding()
                        .shadow(color: Color.black.opacity(0.3),
                                radius: 3,
                                x: 3,
                                y: 3)
                    }
                }
            }
            .navigationTitle("To-do List for \(houseModel.myHouse.id)")
            .toolbarBackground(
                            Color.themeTertiary,
                            for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        AddTaskView(show: $showAddTask)
    }
}



struct ChoresView_Previews: PreviewProvider {
    static var previews: some View {
        ChoresView()
    }
}
