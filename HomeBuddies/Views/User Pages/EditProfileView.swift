//
//  EditProfileView.swift
//  HomeBuddies
//
//  Created by Pavi Rannulu on 1/31/23.
//

import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var userModel: UserViewModel
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var pronouns = ""
    
    @State private var birthYear = ""
    @State private var birthMonth = ""
    @State private var birthDate = ""
    
    @State private var emergencyContactName = ""
    @State private var emergencyContactInfo = ""
    @State private var emergencyContactRelationship = ""
    
    @State private var medicalInfo = ""
    
    @State private var profilePic = ""
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    
    var body: some View {
        NavigationView {
            ScrollView{
                VStack {
                    HStack {
                        VStack {
                            if profilePic == "" {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                            } else {
                                Image(profilePic)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .frame(width: 100, height: 100)
                            }
                            NavigationLink(destination: ChangeProfilePicView()) {
                                Text("Change profile pic")
                                    .padding()
                            }
                        }
                        .padding(10)
                        .overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.themeAccent, lineWidth: 2).opacity(0.3)
                        )
                        VStack{
                            
                            HStack {
                                Text("First Name:")
                                TextField("First Name", text: $firstName)
                                    .foregroundColor(Color.themeTertiary)
                                    .padding(5)
                                    .overlay( /// apply a rounded border
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.themeAccent, lineWidth: 2).opacity(0.3)
                                    )
                            }
                            
                            HStack {
                                Text("Last Name:")
                                TextField("Last Name", text: $lastName)
                                    .foregroundColor(Color.themeTertiary)
                                    .padding(5)
                                    .overlay( /// apply a rounded border
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.themeAccent, lineWidth: 2).opacity(0.3)
                                    )
                                    
                            }
                            HStack {
                                Text("Pronouns:")
                                TextField("Pronouns", text: $pronouns)
                                    .foregroundColor(Color.themeTertiary)
                                    .padding(5)
                                    .overlay( /// apply a rounded border
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.themeAccent, lineWidth: 2).opacity(0.3)
                                    )
                                    
                            }
                            HStack {
                                Text("Birthday:")
                                VStack (spacing: 10){
                                    Picker(selection: $birthDate, label: Text("Day")) {
                                        ForEach(1...31, id: \.self) { date in
                                            let dateAsStr = String(date)
                                            Text("\(dateAsStr)").tag(dateAsStr)
                                        }
                                        Text("-").tag("")
                                    }
                                    Picker(selection: $birthMonth, label: Text("Month")) {
                                        let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
                                        ForEach(months, id: \.self) { month in
                                            Text("\(month)").tag(month)
                                        }
                                        Text("-").tag("")
                                    }
                                    Picker(selection: $birthYear, label: Text("Year")) {
                                        ForEach(1906...2023, id: \.self) { year in
                                            let yearAsStr = String(year)
                                            Text("\(yearAsStr)").tag(yearAsStr)
                                        }
                                        Text("-").tag("")
                                    }
                                }
                                .padding(5)
                                .overlay( /// apply a rounded border
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.themeAccent, lineWidth: 2).opacity(0.3)
                                ).frame(maxWidth: .infinity)
                            }
                        }.padding(.horizontal, 10)
                       
                    }.padding(.horizontal, 10)
                    
                   
                    
                   
                    VStack {
                    
                        Text("Emergency Contact Information").bold()
                        TextField("Emergency contact name", text: $emergencyContactName)
                            .foregroundColor(Color.themeTertiary)
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.themeAccent, lineWidth: 1).opacity(0.1)
                            )
                            
                        TextField("Contact Information", text: $emergencyContactInfo)
                            .foregroundColor(Color.themeTertiary)
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.themeAccent, lineWidth: 1).opacity(0.1)
                            )
                            
                        TextField("Relationship to you", text: $emergencyContactRelationship)
                            .foregroundColor(Color.themeTertiary)
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.themeAccent, lineWidth: 1).opacity(0.1)
                            )
                            
                    }.padding(10)
                        .overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.themeAccent, lineWidth: 2).opacity(0.3)
                        )
                        .padding(.horizontal, 20)
                    Spacer().frame(height: 20)
                    VStack {
                        Text("Allergies and other medical information").bold()
                    TextField("Medical Info", text: $medicalInfo)
                            .foregroundColor(Color.themeTertiary)
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.themeAccent, lineWidth: 1).opacity(0.1)
                            )
                    }.padding(10)
                        .overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.themeAccent, lineWidth: 2).opacity(0.3)
                        )
                        .padding(.horizontal, 20)
                    
                    Spacer().frame(height: 20)
                    
                    Button {
                        userModel.addNameAndPronouns(firstName: firstName, lastName: lastName, pronouns: pronouns)
                        
                        
                        userModel.addBirthday(year: birthYear, month: birthMonth, day: birthDate)
                        
                        userModel.addEmergencyContact(name: emergencyContactName, info: emergencyContactInfo, relationship: emergencyContactRelationship)
                        
                        userModel.addProfilePic(profilePicName: profilePic)
                        
                        userModel.addMedicalInfo(medicalInfo: medicalInfo)
                        
                        userModel.user.medicalInfo = medicalInfo
                        
                        // call function that sets all this data
                        
                        self.mode.wrappedValue.dismiss()
                        
                    } label: {
                        Text("Save")
                            .foregroundColor(.white)
                            .bold()
                            .padding()
                    }.frame(width: 200, height: 40)
                        .background(RoundedRectangle(cornerRadius: 10))
                        .foregroundColor(Color.themeTertiary)
                    
                   
                    
                    Button {
                        self.mode.wrappedValue.dismiss()
                    } label: {
                        Text("Discard changes")
                            .foregroundColor(.white)
                            .bold()
                            .padding()
                    }.frame(width: 200, height: 40)
                        .background(RoundedRectangle(cornerRadius: 10))
                        .foregroundColor(Color.themeTertiary)
                }
                .onAppear {
                    firstName = userModel.user.firstName
                    lastName = userModel.user.lastName
                    pronouns = userModel.user.pronouns ?? ""
                    birthYear = userModel.user.birthday?["year"] ?? ""
                    birthMonth = userModel.user.birthday?["month"] ?? ""
                    birthDate = userModel.user.birthday?["day"] ?? ""
                    emergencyContactName = userModel.user.emergencyContact?["name"] ?? ""
                    emergencyContactInfo = userModel.user.emergencyContact?["info"] ?? ""
                    emergencyContactRelationship = userModel.user.emergencyContact?["relationship"] ?? ""
                    medicalInfo = userModel.user.medicalInfo ?? ""
                    profilePic = userModel.user.profilePic ?? ""
                }
            }
            .clipped()
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Edit Profile")
        //.navigationBarTitleDisplayMode(.inline)
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
