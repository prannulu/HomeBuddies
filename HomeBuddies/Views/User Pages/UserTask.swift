//
//  UserTask.swift
//  HomeBuddies
//
//  Created by Pavi Rannulu on 2/9/23.
//

import SwiftUI
import ConfettiSwiftUI

struct UserTask: View {
    var thisTask: Task
    @EnvironmentObject var taskModel: TaskViewModel
    @EnvironmentObject var houseModel: ViewOneHouse
    @EnvironmentObject var userModel: UserViewModel
    @State var flipped = false // state variable used to update the card
    @State var isWorkingOnTask = false
    @State var confettiCounter = 0
    @State var isCompleted = false
    @State var notesDraft = ""
    @State var selectedStatus = "Not yet started"
    var statusList = ["Not yet started", "Actively working on it","Started but taking a break", "Need supplies", "Almost done"]
   
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .frame(width: 110, height: 150)
            .foregroundColor(self.flipped ? Color.themeAccent : .themeFive) // change the card color when flipped
            .overlay(self.flipped ? AnyView(flippedView) : AnyView(unflippedView))
            
            .rotation3DEffect(self.flipped ? Angle(degrees: 360): Angle(degrees: 0), axis: (x: CGFloat(0), y: CGFloat(10), z: CGFloat(0)))
            .animation(.default) // implicitly applying animation
           
            .onTapGesture {
                // explicitly apply animation on toggle (choose either or)
                //withAnimation {
                    self.flipped.toggle()
                //}
            
        }
    }
    
    var flippedView : some View {
        VStack {
            Text(thisTask.description)
                .foregroundColor(.white)
                .bold()
                .multilineTextAlignment(.center)
                .font(.system(size: 15))
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(2)
                .padding()
            Text("Notes: \(thisTask.notes ?? "")")
                .foregroundColor(.white)
                .font(.system(size: 12))
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(2)
            Text("Status: \(thisTask.status ?? "")")
                .foregroundColor(.black)
                .font(.system(size: 12))
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(2)
            NavigationLink(destination: workingOnTask) {
                Text(Image(systemName: "bolt")).padding().foregroundColor(.white)
                .bold()
            }.navigationBarBackButtonHidden(true)
            
        }
    }
    
    var unflippedView : some View {
        VStack {
            Text(thisTask.description).foregroundColor(.white).bold().padding()
        }
    }
    
    var workingOnTask : some View {
        RoundedRectangle(cornerRadius: 20)
            .frame(width: 330, height: 450)
            .foregroundColor(Color.themeAccent)
            .opacity(0.7)
            .overlay(textForWorkingOnTask)
    }
    
    var textForWorkingOnTask : some View {
        VStack{
            Spacer()
            if isCompleted == false {
                Text("Details for task: \(thisTask.description)").font(.title).padding()
                if isWorkingOnTask == false {
                    VStack {
                        Spacer()
                        Text("Notes: \(thisTask.notes ?? "")").bold()
                        Text("Status: \(thisTask.status ?? "Not yet started")").bold()
                        Spacer()
                        Button {
                            isWorkingOnTask.toggle()
                        } label : {
                            Text("Start working on this task")
                        }.buttonStyle(.borderedProminent)
                            .foregroundColor(.white)
                            .bold()
                            .tint(Color.themeFive)
                            .padding()
                            .cornerRadius(20)
                        
                       
                    }
                } else {
                    VStack {
                        HStack {
                            Text("Notes:")
                            TextEditor(text: $notesDraft)
                                .onAppear{notesDraft = thisTask.notes ?? ""}
                                .frame(height: 100)
                                .foregroundColor(.themeAccent)
                                .overlay( /// apply a rounded border
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.themeAccent, lineWidth: 2).opacity(0.3)
                                )
                        }
                        HStack {
                            Text("Status of this task:")
                            Picker("Status of this task:", selection: $selectedStatus) {
                                ForEach(statusList, id: \.self) { status in
                                    Text(status).tag(status)
                                }
                            }
                        }.onAppear{selectedStatus = thisTask.status ?? "Not yet started"}
                        
                        Button {
                            taskModel.editTask(taskID: thisTask.id, notes: notesDraft)
                            taskModel.updateStatus(taskID: thisTask.id, status: selectedStatus)
                            houseModel.addUpdate(update: "🔥 \(userModel.user.firstName) is working on a task: \(thisTask.description)")
                            isWorkingOnTask.toggle()
                        } label : {
                            Text("Save Changes")
                        }
                        
                        Button("Discard changes"){
                            isWorkingOnTask.toggle()
                        }
                    }.buttonStyle(.borderedProminent)
                        .foregroundColor(.white)
                        .bold()
                        .tint(Color.themeFive)
                        .padding()
                        .cornerRadius(20)
                }
                Spacer()
                
                Button {
                    confettiCounter += 1
                    isCompleted.toggle()
                    
                } label: {
                    Text("⭐ Mark as complete ⭐")
                }
                .buttonStyle(.borderedProminent)
                    .padding()
                    .foregroundColor(.white)
                    .bold()
                    .tint(Color.themeTertiary)
                    .cornerRadius(20)
                Spacer()
            } else {
                Text("Great job! You completed the task \"\(thisTask.description)\"!").bold()
                Spacer()
                Text("💕👏 Give yourself a pat on the back, treat yourself to a little break, and then check what other tasks you can work on.").padding().italic()
                Spacer()
                HStack {
                    Text("Was that a mistake? Did you not mean to click on that button?")
                    Button {
                        isCompleted.toggle()
                    } label: {
                        Text("Click here to undo completing this task").foregroundColor(.red).opacity(0.5)
                    }
                }.padding()
                Spacer()
                
                Button {
                    taskModel.updateStatus(taskID: thisTask.id, status: "completed")
                    houseModel.addUpdate(update: "✅ \(userModel.user.firstName) completed the task: \(thisTask.description)")
                } label : {
                    Text("Return to Profile Page")
                }.buttonStyle(.borderedProminent)
                    .padding()
                    .cornerRadius(20)
                    .foregroundColor(.white)
                    .bold()
                    .tint(Color.themeFive)
                    .navigationBarBackButtonHidden(true)
            }
        }.confettiCannon(counter: $confettiCounter, num: 100, colors: [.themeTertiary, .themeSecondary], rainHeight: 1000.0, radius: 500.0)
           
    }
}

//struct UserTask_Previews: PreviewProvider {
//    static var previews: some View {
//        UserTask()
//    }
//}
