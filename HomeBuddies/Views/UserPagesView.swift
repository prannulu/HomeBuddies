//
//  ProfilePageView.swift
//  HomeBuddies
//
//  Created by Pavi Rannulu on 1/26/23.
//

import SwiftUI
import FirebaseAuth

struct UserPagesView: View {
    @StateObject var userModel: UserViewModel
        
    var body: some View {
        TabView {
            
            VStack{
                ProfilePageView()
            }
            .tabItem {
                Image(systemName: "person")
              }
            
            Section {
                if let currentHouse = userModel.user.currentHouse, let requestedHouse = userModel.user.requestedHouse{
                    if currentHouse != "" {
                        VStack {
                            Text("You are part of the \(currentHouse)!")
                            HousePageView()
                            Button {
                                userModel.addCurrentHouse(houseID: "")
                            } label: {
                                Text("Click here to leave \(currentHouse) house").foregroundColor(.red)
                            }
                        }
                       
                        // home page!
                    } else if requestedHouse != "" {
                        VStack {
                            Text("\(userModel.user.firstName), it looks like you have requested to join \(requestedHouse). waiting to be approved")
                            Button {
                                userModel.addRequestedHouse(houseID: "")
                            } label: {
                                Text("Cancel Join Request from \(requestedHouse)").foregroundColor(.red)
                            }
                        }
                    } else {
                        HouseSearchView()
                    }
                } else {
                    // throw error?
                }
            }
                .tabItem {
                    Image(systemName: "house")
                }
            Text("This view will contain *in-app messaging*")
                .tabItem {
                    Image(systemName: "message")
                }
            
            Section {
                Text("This view will contain *Settings*")
                
            }
                .tabItem {
                    Image(systemName: "gear")
                }
        }
        .environmentObject(userModel)
    }
}

