//
//  ChangeProfilePicView.swift
//  HomeBuddies
//
//  Created by Pavi Rannulu on 2/1/23.
//

import SwiftUI

struct ChangeProfilePicView: View {
    @EnvironmentObject var userModel: UserViewModel
    private let pics = ["bunny", "mushroom", "gunther", "lion", "axolotl", "rat"]
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Please select a picture")
                ScrollView {
                    LazyVGrid(columns: [.init(.adaptive(minimum: 100, maximum: .infinity), spacing: 3)], spacing: 3) {
                        ForEach(pics, id:\.self) { pic in
                            Image(pic)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                .clipped()
                                .aspectRatio(1, contentMode: .fit)
                                .onTapGesture{
                                    userModel.user.profilePic = pic
                                    self.mode.wrappedValue.dismiss()
                                }
                        }
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            .clipped()
                            .aspectRatio(1, contentMode: .fit)
                            .onTapGesture{
                                userModel.user.profilePic = ""
                                self.mode.wrappedValue.dismiss()
                            }
                    }
                }
                
            }
            .navigationTitle("Select Profile Picture")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ChangeProfilePicView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeProfilePicView()
    }
}
