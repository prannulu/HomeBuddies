//
//  ProfilePageView.swift
//  HomeBuddies
//
//  Created by Pavi Rannulu on 1/30/23.
//

import SwiftUI

struct ProfilePageView: View {
    @EnvironmentObject var userModel: UserViewModel
   
    var body: some View {
        NavigationView {
            ZStack {
                Color.pink
                    .opacity(0.4)
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        profilePicView
                        
                        VStack {
                            Section {
                                Text("\(userModel.user.firstName) \(userModel.user.lastName)")
                                    .font(.largeTitle)
                                
                                if let pronouns = userModel.user.pronouns{
                                    if pronouns != "" {
                                        Text("\(pronouns)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                    }
                    aboutMeView
                    emergencyContactView
                    NavigationLink(destination: EditProfileView()) {
                        Text("Edit profile information")
                            .padding()
                    }
                }
            }
            .navigationTitle("Profile Page")
        }
    }
    
    var aboutMeView : some View {
        VStack(alignment: .leading) {
            Text("About Me")
                .bold()
                .underline()
            if let birthday = userModel.user.birthday{
                if birthday != [:] && birthday["month"] != "" {
                    Text("Birthday: \(birthday["day"] ?? "") \(birthday["month"] ?? ""), \(birthday["year"] ?? "")")
                }
            }
            
            if let currentHouse = userModel.user.currentHouse{
                if currentHouse != "" {
                    Text("Current House: \(currentHouse)")
                }
            }
        }
        .padding()
        .cornerRadius(20) /// make the background rounded
        .overlay( /// apply a rounded border
            RoundedRectangle(cornerRadius: 20)
                .stroke(.red, lineWidth: 2)
        )
    }
    
    var emergencyContactView : some View {
        VStack(alignment: .leading) {
            Text("Emergency Contact")
                .bold()
                .underline()
            if let emergency = userModel.user.emergencyContact{
                if emergency != [:] && emergency["name"] != "" {
                    Text("Name: \(emergency["name"] ?? "")")
                    Text("Contact info: \(emergency["info"] ?? "")")
                    Text("Relationship to me: \(emergency["relationship"] ?? "")")
                } else {
                    Text("Please fill out emergency contact info").italic().foregroundColor(.red)
                }
            }
        }
        .padding()
        .cornerRadius(20) /// make the background rounded
        .overlay( /// apply a rounded border
            RoundedRectangle(cornerRadius: 20)
                .stroke(.red, lineWidth: 2)
        )
    }
    
    var medicalInfoView : some View {
        Section {
            if let medicalInfo = userModel.user.medicalInfo{
                if medicalInfo != "" {
                    Text("Allergies/Medical Info").bold().underline()
                    Text("\(medicalInfo)")
                }
            }
        }
    }
    
    var profilePicView : some View {
        ZStack {
            Circle()
                .fill(.secondary)
                .frame(width: 150, height: 150)
            if let pic = userModel.user.profilePic {
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
        }
    }
}

struct ProfilePageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePageView()
    }
}
