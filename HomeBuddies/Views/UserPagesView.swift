//
//  ProfilePageView.swift
//  HomeBuddies
//
//  Created by Pavi Rannulu on 1/26/23.
//

import SwiftUI
import FirebaseAuth

struct UserPagesView: View {
    var signoutFunc: () -> Void
    @EnvironmentObject var houseModel: ViewOneHouse
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var taskModel: TaskViewModel
    
    var body: some View {
        TabView {
            
            Section {
                if let currentHouse = userModel.user.currentHouse{
                    
                    if currentHouse == "" {
                        HouseSearchView2()
                        
                    } else {
                        //                        let _ = self.taskModel.getTask(houseID: currentHouse)
                        VStack {
                            HousePageView()
                            
                        }
                    }
                }
            }
            
            .tabItem {
                Image(systemName: "house")
            }
            
            
            if userModel.user.currentHouse != "" {
                VStack{
                    ChoresView()
                }
                .tabItem {
                    Image(systemName: "hands.sparkles")
                }
                
                VStack{
                    Text("Coming Soon: In-app messaging!")
                }
                .tabItem {
                    Image(systemName: "message")
                }
                
            }
            
            
            VStack{
                ProfilePageView(signoutFunc: signoutFunc)
            }
            .tabItem {
                Image(systemName: "person")
            }
            
        }
        .edgesIgnoringSafeArea(.all)
    }
    
}
