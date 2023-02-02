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
                    Section(header: Text("Profile pic")){
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
                    Section(header: Text("First Name")) {
                        TextField("First Name", text: $firstName)
                            .foregroundColor(Color.pink)
                            .border(Color.blue)
                    }
                    Section(header: Text("Last Name")) {
                        TextField("Last Name", text: $lastName)
                            .foregroundColor(Color.pink)
                            .border(Color.blue)
                    }
                    Section(header: Text("Pronouns")) {
                        TextField("Pronouns", text: $pronouns)
                            .foregroundColor(Color.pink)
                            .border(Color.blue)
                    }
                    
                    Section(header: Text("Birthday")) {
                        HStack {
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
                    }
                    
                    Section(header: Text("Emergency Contact Information")) {
                        TextField("Emergency contact name", text: $emergencyContactName)
                            .foregroundColor(Color.pink)
                            .border(Color.blue)
                        TextField("Contact Information", text: $emergencyContactInfo)
                            .foregroundColor(Color.pink)
                            .border(Color.blue)
                        TextField("Relationship to you", text: $emergencyContactRelationship)
                            .foregroundColor(Color.pink)
                            .border(Color.blue)
                    }
                    
                    Section(header: Text("Allergies and other medical information")) {
                        TextField("Medical Info", text: $medicalInfo)
                            .foregroundColor(Color.pink)
                            .border(Color.blue)
                    }
                    
                    
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
                            .frame(width: 200, height: 40)
                            .background(RoundedRectangle(cornerRadius: 10, style:.continuous).fill(.linearGradient(colors:[.green, .black], startPoint: .top, endPoint: .bottomTrailing)))
                            .foregroundColor(.white)
                            .bold()
                    }
                    
                    Button {
                        self.mode.wrappedValue.dismiss()
                    } label: {
                        Text("Discard changes")
                            .frame(width: 200, height: 40)
                            .background(RoundedRectangle(cornerRadius: 10, style:.continuous).fill(.linearGradient(colors:[.green, .black], startPoint: .top, endPoint: .bottomTrailing)))
                            .foregroundColor(.white)
                            .bold()
                    }
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
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
