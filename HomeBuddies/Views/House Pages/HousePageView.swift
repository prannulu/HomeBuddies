//
//  HousePageView.swift
//  HomeBuddies
//
//  Created by Pavi Rannulu on 1/26/23.
//

import SwiftUI

struct HousePageView: View {
    @EnvironmentObject var houseModel: ViewOneHouse
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var taskModel: TaskViewModel
    @State private var showingLeaveHouseAlert = false
    
    var body: some View {
        NavigationView{
            ZStack {
                Color.themeBackground
                    .edgesIgnoringSafeArea(.all)
                
                VStack(){
                    VStack{
                        Rectangle()
                            .fill(Color.themeTertiary)
                            .frame(height: 250)
                            .edgesIgnoringSafeArea(.top)
                            .overlay(
                                VStack {
                                    Text("Welcome Home!")
                                        .font(.title)
                                        .fontWeight(.bold)
                                    Text("House ID: \(houseModel.myHouse.id)").font(.subheadline)
                                    Text("House Code: \(houseModel.myHouse.code)").font(.subheadline)
                                }
                                //.offset(y:-10)
                            )
                        
                            .overlay(
                                Rectangle()
                                    .fill(Color.themeSecondary)
                                    .frame(height: 150)
                                    .overlay(roommates)
                                    .offset(y:120)
                            )
                            .offset(y:-80)
                        
                    }
                    ScrollView {
                        
                        Group{
                            RoundedRectangle(cornerRadius: 20)
                                .frame(height: 300)
                                .foregroundColor(Color.themeAccent).opacity(0.2)
                                .overlay(
                                    VStack{
                                        Text("Home Feed").font(.headline).padding()
//                                        Button{
//                                            houseModel.clearHouseUpdate(clearedBy: userModel.user.firstName)
//                                        }label: {
//                                            Text("Clear the Home feed").font(.subheadline).foregroundColor(.red)
//                                        }.buttonStyle(.plain)
                                        ScrollView{
                                            VStack (alignment: .leading, spacing: 3){
                                                
                                                ForEach(self.houseModel.updates, id: \.self) { update in
                                                    Rectangle()
                                                        .frame(width: 350, height:1).opacity(0.6)
                                                        .foregroundColor(Color.themeAccent)
                                                    Text(update).foregroundColor(Color.themeTertiary).font(.system(size: 15))
                                                }
                                            }
                                        }
                                    }
                                )
                         
                            RoundedRectangle(cornerRadius: 20)
                                .frame(height: 200)
                                .foregroundColor(Color.themeAccent).opacity(0.2)
                                .overlay(
                                    VStack{
                                        Text("Housekeeping Notes:").font(.headline)
                                        Text("You can add shared information like wifi password, guest policy, house rules, quiet hours, etc here!")
                                    }
                                )
                            
                        }
                        .padding(.horizontal)
                        
                        
                        
                        Button {
                            showingLeaveHouseAlert = true
                        } label: {
                            Text("Click here to leave \(houseModel.myHouse.id) house").foregroundColor(.red)
                        }.alert(isPresented:$showingLeaveHouseAlert) {
                            Alert(
                                title: Text("Are you sure you want to leave \(houseModel.myHouse.id)?"),
                                message: Text("All your task progress in this house will be deleted."),
                                primaryButton: .destructive(Text("Leave this house")) {
                                    userModel.addCurrentHouse(houseID: "")
                                    houseModel.resetHouse()
                                    taskModel.unassignTasks(userID: userModel.user.id)
                                    
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    }
                    .offset(y:10)
                }
            }
        }
    }
    
    var roommates : some View {
        VStack {
            //Text("Roommates at a glance").font(.headline)
            ScrollView(.horizontal) {
                HStack{
                    Spacer()
                    ForEach(houseModel.roommates){ roommate in
                        Spacer()
                        NavigationLink {
                            // roommate detail view goes here
                            RoommateDetailView(roommate: roommate)
                        } label: {
                            Group {
                                VStack{
                                    if let pic = roommate.profilePic {
                                        if pic != "" {
                                            Image(pic)
                                                .resizable()
                                                .scaledToFit()
                                                .clipShape(Circle())
                                                .frame(width: 70, height: 70)
                                        } else {
                                            Image(systemName: "person.crop.circle.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 70, height: 70)
                                        }
                                    }
                                    Text(roommate.firstName)
                                }
                            }.foregroundColor(.black)
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

struct HousePageView_Previews: PreviewProvider {
    static var previews: some View {
        HousePageView()
    }
}
