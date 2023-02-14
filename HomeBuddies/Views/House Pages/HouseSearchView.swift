////
////  HouseSearchView.swift
////  HomeBuddies
////
////  Created by Pavi Rannulu on 1/26/23.
////
//
//import SwiftUI
//
//struct HouseSearchView: View {
//// This is if they haven't joined or requested a house yet.
//    @State var houseID = ""
//    @StateObject var searchedHouse = ViewOneHouse()
//    @EnvironmentObject var userModel: UserViewModel
//
//    var body: some View {
//        NavigationView{
//            ZStack{
//                Color.themeBackground
//                    .edgesIgnoringSafeArea(.all)
//                VStack{
//                    Section {
//                        Text("Hi there \(userModel.user.firstName)!")
//                        Text("Find your House using the House ID and request to join it").bold()
//                        TextField("Enter House ID here", text: $houseID).multilineTextAlignment(.center).padding()
//                        if let foundHouse = searchedHouse.foundHouse{
//                            if foundHouse {
//                                positiveResults
//                            } else {
//                                searchButton
//                                negativeResults
//                            }
//                        } else {
//                            searchButton
//                        }
//                    }.padding()
//                    Divider().frame(height: 4).overlay(.yellow)
//                    Section {
//                        Text("Or create a new house!").bold()
//                        NavigationLink(destination: CreateNewHouse()) { Text("Click here to create new house") }
//                    }.padding()
//                }
//            }
//        }
//    }
//
//    var positiveResults: some View {
//        VStack {
//            Text("We found your house: \(searchedHouse.myHouse.id)").foregroundColor(Color.green)
//            NavigationLink(destination: JoinHouseView(houseID: houseID)) { Text("Tap to show details") }
//            Text("Not the house you were looking for? Try searching again").italic()
//            searchButton
//        }.padding()
//    }
//
//    var negativeResults: some View {
//        VStack {
//            Text("We were not able to find your house. Try again!").foregroundColor(Color.red)
//        }
//    }
//
//    var searchButton: some View {
//        Button {
//            print("You searched for \(houseID)")
//            searchedHouse.getAndSetHouse(houseID: houseID)
//
//        } label: {
//            Text("Find my House").foregroundColor(.black)
//        }
//        .buttonStyle(.borderedProminent)
//        .tint(.orange)
//    }
//}
//
//
//// CREATE NEW HOUSE VIEW:
//struct CreateNewHouse: View {
//    @State var houseID = ""
//    @State var houseCode = ""
//    @EnvironmentObject var houseModel: ViewOneHouse
//    @EnvironmentObject var userModel: UserViewModel
//    @EnvironmentObject var taskModel: TaskViewModel
//
//    var body: some View {
//        NavigationView {
//            VStack{
//                Text("You're about to create a new house!")
//                    .bold()
//                Text("First, you will need to create a House ID")
//
//                Text(Image(systemName: "info.circle")) + Text("Your House ID is a unique phrase/word that will let others find your house and request to join it. Kind of like a username!").italic()
//
//                TextField("Enter a new House ID here", text: $houseID).multilineTextAlignment(.center).padding()
//
//                if let foundHouse = houseModel.foundHouse{
//                    if foundHouse == true {
//                        Text("This ID already exists. Try a different ID").foregroundColor(.red)
//                        checkIfHouseIDexists
//                    } else {
//                        Text("You got a unique House ID").foregroundColor(.green)
//                        Text("Would you like to create house with this ID? You will not be able to change it later")
//                        Text("Please enter a secret code. This will allow others to join the house")
//                        TextField("Code", text: $houseCode)
//                        Button {
//                            houseModel.addNewHouse(houseID: houseID, houseCode: houseCode)
//                            houseModel.getAndSetHouse(houseID: houseID)
//                            taskModel.loadTasks(houseID: houseID)
//                            taskModel.getTaskUpdates(houseID: houseID)
//                            userModel.addCurrentHouse(houseID: houseID)
//                            houseModel.getAndSetRoommates()
//                            houseModel.getRoommateUpdates()
//                            // goes to housepage view when the current house is updated
//                        } label: {
//                            Text("Create House")
//                        }.disabled(houseCode.isEmpty)
//                    }
//                } else {
//                    checkIfHouseIDexists
//                }
//            }
//            .foregroundColor(Color.themeSecondary)
//            .padding(.horizontal)
//        }
//    }
//    var checkIfHouseIDexists: some View {
//        Button {
//            print("You searched for \(houseID)")
//            houseModel.getAndSetHouse(houseID: houseID)
//
//        } label: {
//            Text("Check if this House ID is available").foregroundColor(.black)
//        }
//        .buttonStyle(.borderedProminent)
//        .tint(.orange)
//    }
//}
//
//// JOIN HOUSE VIEW
//struct JoinHouseView: View {
//    var houseID: String
//    @State var houseCode = ""
//    @State var message = ""
//    @EnvironmentObject var houseModel: ViewOneHouse
//    @EnvironmentObject var userModel: UserViewModel
//    @EnvironmentObject var taskModel: TaskViewModel
//
//    var body: some View {
//        VStack{
//            Text("House Name: \(houseModel.myHouse.id)")
//            Text("Who lives here? ")
//            ForEach(houseModel.roommates){ roommate in
//                Text("  - \(roommate.firstName)")
//            }
//        }.onAppear {houseModel.getAndSetHouse(houseID: houseID) }
//        Text("Enter House Code to join:")
//        TextField("House Code", text: $houseCode)
//            .foregroundColor(Color.pink)
//            .border(Color.blue)
//
//        Button {
//            let queue = DispatchQueue(label: "join house tasks")
//            queue.asyncAfter(deadline: .now()+1){
//                taskModel.loadTasks(houseID: houseID)
//                taskModel.getTaskUpdates(houseID: houseID)
//                houseModel.getAndSetRoommates()
//                houseModel.getRoommateUpdates()
//            }
////            let doesCodeMatch = userModel.addToRequestedHouse(houseID: houseModel.myHouse.id, houseCode: self.houseCode)
//            //if doesCodeMatch == false {
//                self.message = "Code doesn't match. Try again"
//            } else {
//                houseModel.addUpdate(update: "\(userModel.user.firstName) has joined this house!")
//            }
//        } label: {
//            Text("Join House")
//        }.buttonStyle(.borderedProminent)
//        .tint(.green)
//
//        if message != "" {
//            Text(message).foregroundColor(.red)
//        }
//
//    }
//
//    var doesntMatch : some View {
//        Text("Code doesn't match")
//    }
//}
//
//struct HouseSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        HouseSearchView()
//    }
//}
