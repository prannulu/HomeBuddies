//
//  HouseSearchView.swift
//  HomeBuddies
//
//  Created by Pavi Rannulu on 1/26/23.
//

import SwiftUI

struct HouseSearchView: View {
// This is if they haven't joined or requested a house yet.
    @State var houseID = ""
    @StateObject var thisHouse = ViewOneHouse()
    @EnvironmentObject var userModel: UserViewModel
   
    var body: some View {
        NavigationView{
            VStack{
                Section {
                    Text("Hi there \(userModel.user.firstName)!")
                    Text("Find your House using the House ID and request to join it").bold()
                    TextField("Enter House ID here", text: $houseID).multilineTextAlignment(.center).padding()
                    if let foundHouse = thisHouse.foundHouse{
                        if foundHouse {
                            positiveResults
                        } else {
                            searchButton
                            negativeResults
                        }
                    } else {
                        searchButton
                    }
                }.padding()
                Divider().frame(height: 4).overlay(.yellow)
                Section {
                    Text("Or create a new house!").bold()
                    NavigationLink(destination: CreateNewHouse()) { Text("Click here to create new house") }
                }.padding()
            }
        }
    }
    var positiveResults: some View {
        VStack {
            Text("We found your house: \(thisHouse.myHouse.nickname ?? "")").foregroundColor(Color.green)
            NavigationLink(destination: JoinHouseView(thisHouse: thisHouse.myHouse)) { Text("Tap to show details!!!!") }
            Text("Not the house you were looking for? Try searching again").italic()
            searchButton
        }.padding()
    }
    
    var negativeResults: some View {
        VStack {
            Text("We were not able to find your house. Try again!").foregroundColor(Color.red)
        }
    }
    
    var searchButton: some View {
        Button {
            print("You searched for \(houseID)")
            thisHouse.getAndSetHouse(houseID: houseID)

        } label: {
            Text("Find my House").foregroundColor(.black)
        }
        .buttonStyle(.borderedProminent)
        .tint(.orange)
    }
}


// CREATE NEW HOUSE VIEW:
struct CreateNewHouse: View {
    @State var houseID = ""
    @StateObject var thisHouse = ViewOneHouse()
    @EnvironmentObject var userModel: UserViewModel
    
    var body: some View {
        NavigationView {
            VStack{
                Text("Hello again \(userModel.user.firstName)!")
                Text("You're about to create a new house!").bold().foregroundColor(.purple)
                Text("First, you will need to create a House ID This is a unique ID that will let others find your house and request to join it. Kind of like a username!")
                TextField("Enter a new House ID here", text: $houseID).multilineTextAlignment(.center).padding()
                
                if let foundHouse = thisHouse.foundHouse{
                    if foundHouse {
                        Text("This ID already exists. Try a different ID").foregroundColor(.red)
                        checkIfHouseIDexists
                    } else {
                        Text("You got a unique House ID").foregroundColor(.green)
                        Text("Would you like to create house with this ID? You will not be able to change it later")
                        
                        Button {
                            thisHouse.addNewHouse(houseID: houseID, creatorID: userModel.user.id, creatorName: userModel.user.firstName)
                            thisHouse.getAndSetHouse(houseID: houseID)
                            userModel.addCurrentHouse(houseID: houseID)
                            // goes to housepage view when the current house is updated
                        } label: {
                            Text("Yes!")
                        }
                    }
                } else {
                    checkIfHouseIDexists
                }
            }
        }
    }
    var checkIfHouseIDexists: some View {
        Button {
            print("You searched for \(houseID)")
            thisHouse.getAndSetHouse(houseID: houseID)

        } label: {
            Text("Check if this House ID is available").foregroundColor(.black)
        }
        .buttonStyle(.borderedProminent)
        .tint(.orange)
    }
}

// JOIN HOUSE VIEW
struct JoinHouseView: View {
    var thisHouse: House
    @EnvironmentObject var userModel: UserViewModel
    
    var body: some View {
        VStack{
            Text("House Nickname: \(thisHouse.nickname ?? "")")
            Text("Who lives here? ")
            ForEach(thisHouse.roommates.sorted(by: >), id: \.key){ key, value in
                Text("  - \(value)")
            }
            Text("Any pets? \(String(thisHouse.pets ?? false))")
        }
        Button {
            // request to join
            userModel.addRequestedHouse(houseID: thisHouse.id)
            // Needs to: update requestedhouse in user
        } label: {
            Text("Request to join")
        }.buttonStyle(.borderedProminent)
        .tint(.green)

    }
}

struct HouseSearchView_Previews: PreviewProvider {
    static var previews: some View {
        HouseSearchView()
    }
}
