//
//  ProfilePageView.swift
//  HomeBuddies
//
//  Created by Pavi Rannulu on 1/30/23.
//

import SwiftUI

struct ProfilePageView: View {
    var signoutFunc: () -> Void
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var taskModel: TaskViewModel
   
    var body: some View {
        NavigationView {
            ZStack {
                Color.themeBackground
                    .edgesIgnoringSafeArea(.all)
                
                    VStack {
                        Rectangle()
                            .fill(Color.themeTertiary)
                            .frame(height: 250)
                            .edgesIgnoringSafeArea(.top)
                            .overlay(
                                HStack {
                                    profilePicView
                                    
                                    VStack {
                                        Section {
                                            Text("\(userModel.user.firstName) \(userModel.user.lastName)")
                                                .font(.largeTitle).foregroundColor(Color.themeFour)
                                            
                                            if let pronouns = userModel.user.pronouns{
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
                                    .offset(y:40)
                            )
                                .fontWeight(.bold)
                                .offset(y:-80)
                            
                        Group {
                            HStack {
                                aboutMeView
                                emergencyContactView
                            }
                            HStack (spacing: 50){
                                NavigationLink(destination: EditProfileView()) {
                                    Text("Edit profile information")
                                }
                                signoutbutton
                            }
                            Divider().frame(height: 2).overlay(Color.themeTertiary)
                          
                        }.offset(y:-80)
                            .font(.system(size: 14))
                        
                            //Spacer()
                        VStack {
                            Text("Tasks assigned to me").bold()
                            myTasks
                        }.offset(y:-80)
                            
                            
                        
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            
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
            if let medicalInfo = userModel.user.medicalInfo{
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
                .stroke(Color.themeAccent, lineWidth: 1)
        )
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
    
    var myTasks : some View {
        ScrollView{
            VStack{
                if let usersTasks = taskModel.getTasksForUser(userID: userModel.user.id){
                    if usersTasks.isEmpty {
                        Text("No assigned tasks")
                    } else {
                        LazyVGrid(columns: [.init(.adaptive(minimum: 100, maximum: .infinity), spacing: 8)], spacing: 3) {
                            ForEach(usersTasks) { task in
                                UserTask(thisTask: task)
                            }
                        }
                    }
                }
            }
        }.frame(maxHeight: .infinity)
            
//        .padding()
//        .cornerRadius(20) /// make the background rounded
//        .overlay( /// apply a rounded border
//            RoundedRectangle(cornerRadius: 20)
//                .stroke(.purple, lineWidth: 2)
//        )
    }
    
    var signoutbutton : some View {
        Button {
            self.signoutFunc()
        } label: {
            Text("Sign Out")
        }
    }
}

//struct ProfilePageView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfilePageView()
//    }
//}
