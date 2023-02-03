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
  
    var body: some View {
        Text("Welcome Home!")
        Text("Name: \(userModel.user.firstName)")
        Text("House ID: \(houseModel.myHouse.id)")
        Button {
            userModel.addCurrentHouse(houseID: "")
            houseModel.removeRoommate(userID: userModel.user.id)
        } label: {
            Text("Click here to leave \(houseModel.myHouse.id) house").foregroundColor(.red)
        }
    }
}

struct HousePageView_Previews: PreviewProvider {
    static var previews: some View {
        HousePageView()
    }
}
