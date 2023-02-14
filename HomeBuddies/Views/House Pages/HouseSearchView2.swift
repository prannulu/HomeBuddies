//
//  HouseSearchView2.swift
//  HomeBuddies
//
//  Created by Pavi Rannulu on 2/8/23.
//

import SwiftUI

struct HouseSearchView2: View {
    @State var houseID = ""
    @State var houseCode = ""
    @State var message = ""
    @StateObject var searchedHouse = ViewOneHouse()
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var houseModel: ViewOneHouse
    @EnvironmentObject var taskModel: TaskViewModel
    @State private var whatsShowing = 0
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.themeBackground
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Section {
                        Text("Welcome to Homebuddies, \(userModel.user.firstName)!")
                            .font(.title)
                            .multilineTextAlignment(.center)
                        Text(Image(systemName: "info.circle")) + Text("To access all the features, you will have to join a house.")
                            .font(.subheadline)
                        Text("Are any of the people you are living with already have a house on Homebuddies?")
                            .font(.title3)
                            .foregroundColor(Color.themeAccent)
                            .bold()
                        HStack{
                            Group {
                                Button {
                                    whatsShowing = 1
                                } label: {
                                    Text("Yes").bold()
                                }
                                .opacity((whatsShowing == 1) ? 1 : 0.3)
                                .foregroundColor((whatsShowing == 1) ? Color.white : Color.black)
                                
                                Button {
                                    whatsShowing = 2
                                } label: {
                                    Text("No").bold()
                                }
                                .opacity((whatsShowing == 2) ? 1 : 0.3)
                                .foregroundColor((whatsShowing == 2) ? Color.white : Color.black)
                            }
                            .buttonStyle(MyActionButtonStyle())
                        }
                    }.padding()
                    
                    
                    if whatsShowing == 1 {
                        yesView
                    } else if whatsShowing == 2 {
                        noView
                    }
                        
                        
                    if whatsShowing == 1 || whatsShowing == 2 {
                        Spacer()
                            .frame(height: 30)
                        Button {
                            houseID = ""
                            houseCode = ""
                            message = ""
                            searchedHouse.resetHouse()
                            whatsShowing = 0
                        } label: {
                            Text("Start Over")
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.regular)
                        .font(.headline.bold())
                        .tint(Color.themeTertiary)
                        .cornerRadius(10)
                    }
                        
                    
                }
            }
        }
    }
    var yesView : some View {
        RoundedRectangle(cornerRadius: 20)
            .frame(height: 250)
            .opacity(0.2)
            .overlay(
                ScrollView {
                    VStack{
                        
                        if let foundHouse = searchedHouse.foundHouse{
                            if foundHouse {
                                positiveResults
                            } else {
                                negativeResults
                            }
                        } else {
                            searchButton
                        }
                    }
                    .padding()
                }
            )
            .foregroundColor(Color.themeAccent)
            .padding(.horizontal)
        
    }
    
  
    
    var positiveResults: some View {
        VStack {
            Text("We found your house: \(searchedHouse.myHouse.id)").foregroundColor(Color.green)
            VStack{
                Text("Who lives here? ")
                ForEach(searchedHouse.roommates){ roommate in
                    Text("  - \(roommate.firstName)")
                }
            }.onAppear {
                searchedHouse.getAndSetHouse(houseID: houseID)
                searchedHouse.getAndSetRoommates()
            }
            Text("If this is the house you're trying to join, please enter House Code:")
            HStack {
                Image(systemName: "lock")
                TextField("House Code", text: $houseCode)
            }.multilineTextAlignment(.center).padding()
            
            
            Button {
                message = ""
                _Concurrency.Task{
                    taskModel.loadTasks(houseID: searchedHouse.myHouse.id)
                    taskModel.getTaskUpdates(houseID: searchedHouse.myHouse.id)
                    houseModel.getAndSetHouse(houseID: searchedHouse.myHouse.id){
                        houseModel.getAndSetRoommates()
                        houseModel.getRoommateUpdates()
                    }
                    userModel.addToRequestedHouse(houseID: houseModel.myHouse.id, houseCode: self.houseCode) { codeMatches in
                        DispatchQueue.main.async {
                            if !codeMatches {
                                self.message = "Code doesn't match. Try again"
                            }
                        }
                    }
                }
                
            } label: {
                Text("Join House")
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.themeTertiary)
            .foregroundColor(.white)
            .bold()
            
            if message != "" {
                Text(message).foregroundColor(.red)
            }
        }.padding()
    }
    
    var negativeResults: some View {
        VStack {
            Spacer()
            Text("We were not able to find a house with ID \"\(houseID)\".").foregroundColor(Color.red).bold()
            Spacer()
            Text(Image(systemName: "info.circle")) + Text(" Make sure you got the correct house ID by asking someone who is already in the house you are trying to join. Then, click the \"Start Over\" button and try again.").italic()
        }
    }
    
    var searchButton: some View {
        VStack{
            Text("Find your House using the House ID and request to join it").bold().foregroundColor(.themeFive)
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Enter House ID here", text: $houseID).multilineTextAlignment(.center).padding()
            }.multilineTextAlignment(.center).padding()
            Button {
                searchedHouse.getAndSetHouse(houseID: houseID)
                
            } label: {
                Text("Find my House").foregroundColor(.white)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.themeFive)
            .foregroundColor(.white)
        }
    }
    
    
    var noView : some View {
        RoundedRectangle(cornerRadius: 20)
            .frame(height: 250)
            .opacity(0.2)
            .overlay(
                ScrollView {
                    VStack{
                        Text("Create a new House and House ID")
                            .bold()
                            .foregroundColor(.themeFive)
                        Spacer()
                        Text(Image(systemName: "info.circle")).foregroundColor(.themeFour) + Text("Your House ID is a unique phrase/word that will let others find your house and request to join it. Kind of like a username!").italic().foregroundColor(.themeFour)
                        
                        TextField("Enter a new House ID here", text: $houseID).multilineTextAlignment(.center).padding()
                            .foregroundColor(.themeFour)
                        
                        if let foundHouse = searchedHouse.foundHouse{
                            if foundHouse == true {
                                Text("This ID already exists. Try a different ID").foregroundColor(.red)
                                checkIfHouseIDexists
                            } else {
                                Text("You got a unique House ID").foregroundColor(.green)
                                Text("Would you like to create house with this ID? You will not be able to change it later.").bold()
                                Spacer()
                                Spacer()
                                        .frame(height: 10)
                                Text(Image(systemName: "arrow.turn.down.right")) + Text("Yes, I want to create a house using this HouseID").foregroundColor(Color.themeFive)
                                    .bold()
                                + Text(" - Great! Just enter a secret code (which will allow others to join this house), and click \"Create House\"")
                                
                                TextField("Code", text: $houseCode)
                                Button {
                                    _Concurrency.Task{
                                        houseModel.addNewHouse(houseID: houseID, houseCode: houseCode)
                                        houseModel.getAndSetHouse(houseID: houseID) {
                                            houseModel.getAndSetRoommates()
                                            houseModel.getRoommateUpdates()
                                        }
                                        taskModel.loadTasks(houseID: houseID)
                                        taskModel.getTaskUpdates(houseID: houseID)
                                        userModel.addCurrentHouse(houseID: houseID)
                                    }
                                } label: {
                                    Text("Create House")
                                }
                                .disabled(houseCode.isEmpty)
                                .buttonStyle(.borderedProminent)
                                .tint(Color.themeFive)
                                .foregroundColor(.white)
                                .bold()
                                Text(Image(systemName: "arrow.turn.down.right")) +
                                Text("No, I want  to use a different House ID")
                                    .foregroundColor(Color.themeFive)
                                        .bold()
                                    + Text(" - No Problem, just click the \"Start Over\" button and try again.")
                            }
                        } else {
                            checkIfHouseIDexists
                        }
                    }.padding()
                }
            )
            .foregroundColor(Color.themeAccent)
            .padding(.horizontal)
    }

    var checkIfHouseIDexists: some View {
        Button {
            print("You searched for \(houseID)")
            searchedHouse.getAndSetHouse(houseID: houseID)

        } label: {
            Text("Check if this House ID is available").foregroundColor(.white)
        }
        .buttonStyle(.borderedProminent)
        .tint(Color.themeFive)
    }
}
    
    
    
    
    

struct HouseSearchView2_Previews: PreviewProvider {
    static var previews: some View {
        HouseSearchView2()
    }
}
