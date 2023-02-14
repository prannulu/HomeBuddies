//
//  RoommateDetailView.swift
//  HomeBuddies
//
//  Created by Pavi Rannulu on 2/13/23.
//

import SwiftUI

struct RoommateDetailView: View {
    var roommate : User
    var body: some View {
        ZStack {
            Color.themeTertiary
                .opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                        HStack {
                            profilePicView
                            
                            VStack {
                                Section {
                                    Text("\(roommate.firstName) \(roommate.lastName)")
                                        .font(.largeTitle).foregroundColor(Color.themeTertiary)
                                    
                                    if let pronouns = roommate.pronouns{
                                        if pronouns != "" {
                                            Text("\(pronouns)").italic()
                                                .font(.subheadline)
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                            }
                        }
                            .padding(.horizontal, 2)
                    
                    .fontWeight(.bold)
                
                Group {
                    VStack(spacing: 30) {
                        aboutMeView
                        emergencyContactView
                    }
                }
            }
        }
    }
        var profilePicView : some View {
            ZStack {
                Circle()
                    .fill(.secondary)
                    .frame(width: 150, height: 150)
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
            }
        }
        
        var aboutMeView : some View {
            VStack(alignment: .leading) {
                Text("About Me")
                    .bold()
                    .underline()
                if let birthday = roommate.birthday{
                    if birthday != [:] && birthday["month"] != "" {
                        Text("Birthday: \(birthday["day"] ?? "") \(birthday["month"] ?? ""), \(birthday["year"] ?? "")")
                    }
                }
                if let medicalInfo = roommate.medicalInfo{
                    if medicalInfo != "" {
                        Text("Allergies/Medical Info").bold().underline()
                        Text("\(medicalInfo)")
                    }
                }
            }
            .padding()
            .cornerRadius(20) /// make the background rounded
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.themeAccent, lineWidth: 1)
            )
        }
        
        var emergencyContactView : some View {
            VStack(alignment: .leading) {
                Text("Emergency Contact")
                    .bold()
                    .underline()
                if let emergency = roommate.emergencyContact{
                    if emergency != [:] && emergency["name"] != "" {
                        Text("Name: \(emergency["name"] ?? "")")
                        Text("Contact info: \(emergency["info"] ?? "")")
                        Text("Relationship to me: \(emergency["relationship"] ?? "")")
                    } else {
                        Text("\(roommate.firstName) has not filled out emergency contact information").italic().foregroundColor(.red)
                    }
                }
            }
            .padding()
            .cornerRadius(20) /// make the background rounded
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.themeAccent, lineWidth: 1)
            )
        }
    }
    

