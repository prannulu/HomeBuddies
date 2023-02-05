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
    @State private var showingLeaveHouseAlert = false
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading, spacing: 20){
                Text("House ID: \(houseModel.myHouse.id)").font(.title)
                Text("Roommates at a glance:").font(.headline)
                ScrollView(.horizontal) {
                    HStack(spacing: 20){
                        ForEach(houseModel.roommates){ roommate in
                            VStack{
                                if let pic = roommate.profilePic {
                                    if pic != "" {
                                        Image(pic)
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(Circle())
                                            .frame(width: 150, height: 150)
                                    } else {
                                        Image(systemName: "person.crop.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 150, height: 150)
                                    }
                                }
                                Text(roommate.firstName).bold()
                                
                            }
                        }
                    }
                }
                ZStack{
                    Rectangle()
                        .frame(width: 350, height:300)
                        .foregroundColor(.pink).opacity(0.2)
                        .cornerRadius(15)
                    Text("House Updates:").font(.headline)
                }
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
                        },
                        secondaryButton: .cancel()
                    )
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
