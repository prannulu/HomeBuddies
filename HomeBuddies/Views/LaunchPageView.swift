//
//  ContentView.swift
//  HomeBuddies
//
//  Created by Pavi Rannulu on 1/23/23.
//

import SwiftUI
import FirebaseAuth

struct LaunchPageView: View {
    @StateObject var userModel = UserViewModel()
    @StateObject var houseModel = ViewOneHouse()
    @StateObject var taskModel = TaskViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var error = ""
    @State private var userIsLoggedIn = false
    
    
    var body: some View {
        if userIsLoggedIn{
            UserPagesView(signoutFunc: signout)
                .environmentObject(userModel)
                .environmentObject(houseModel)
                .environmentObject(taskModel)
        } else {
            content
        }
        
    }
    
    var content: some View {
        NavigationView {
            ZStack {
                Color.themeLaunch
                    .ignoresSafeArea()
                
                Image("Appicon-alt")
                    .resizable()
                    .scaledToFit()
                    .offset(y:-50)
                
                VStack{
//                    Image("Image 1")
//                        .resizable()
//                        .scaledToFit()
//                        .clipShape(Circle())
//                        .frame(width: 200, height: 200)
//                    Text("~ HomeBuddies ~").font(.title)
//                        .foregroundColor(Color.themeAccent)
//                        .bold()
//                    Divider()
                   
                    Capsule()
                        .fill(Color.themeTertiary)
                        .padding(.horizontal, 60)
                        .frame(height: 50)
                        .overlay(NavigationLink(destination: signin) {
                            Text("Login to existing account").padding().foregroundColor(.white)
                                .bold()
                        })
                    Spacer()
                        .frame(height: 20)
                    Capsule()
                        .fill(Color.themeTertiary)
                        .padding(.horizontal, 60)
                        .frame(height: 50)
                        .overlay(NavigationLink(destination: signup) {
                            Text("Create new account").padding()
                                .foregroundColor(.white)
                                .bold()
                        })
                }.offset(y:170)
            }
        }
    }
    
    var signup: some View {
        ZStack{
            Color.themeTertiary
                .opacity(0.4)
                .ignoresSafeArea()
            VStack(spacing: 20){
                Section {
                    Text("Create an account")
                        .bold()
                        .offset(y: -100)
                        .font(.title)
                        .foregroundColor(Color.themeFour)
                    Text("Let's get started.").offset(y: -100)
                        .foregroundColor(Color.themeFour)
                }
                Section {
                    TextField("First Name", text: $firstName)
                        .textFieldStyle(.plain)
                        .bold()
                    
                    Rectangle()
                        .frame(width: 350, height:1)
                        .foregroundColor(.black)
                    
                    TextField("LastName", text: $lastName)
                        .textFieldStyle(.plain)
                        .bold()
                    
                    Rectangle()
                        .frame(width: 350, height:1)
                        .foregroundColor(.black)
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(.plain)
                        .bold()
                    
                    Rectangle()
                        .frame(width: 350, height:1)
                        .foregroundColor(.black)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(.plain)
                        .bold()
                    
                    Rectangle()
                        .frame(width: 350, height:1)
                        .foregroundColor(.black)
                }
                if self.error != "" {
                    Text(error).foregroundColor(.red)
                }
                
                Button {
                    register()
                } label: {
                    Text("Sign Up")
                        .frame(width: 150, height: 40)
                        .background(RoundedRectangle(cornerRadius: 20, style:.continuous).fill(.linearGradient(colors:[Color.themeAccent, .black], startPoint: .top, endPoint: .bottomTrailing)))
                        .foregroundColor(.white)
                        .bold()
                }
            }
            .frame(width: 350)
        }
    }
    
    var signin: some View {
        ZStack {
            Color.themeTertiary
                .opacity(0.4)
                .ignoresSafeArea()
            VStack(spacing: 20){
                Text("Welcome Back!")
                    .bold()
                    .offset(y: -100)
                    .font(.title)
                    .foregroundColor(Color.themeFour)
                Text("Please sign in to continue").offset(y: -100)
                    .foregroundColor(Color.themeFour)
                TextField("Email", text: $email)
                    .textFieldStyle(.plain)
                    .bold()
                
                Rectangle()
                    .frame(width: 350, height:1)
                    .foregroundColor(.black)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(.plain)
                    .bold()
                
                Rectangle()
                    .frame(width: 350, height:1)
                    .foregroundColor(.black)
                
                if self.error != "" {
                    Text(error).foregroundColor(.red)
                }
                Spacer().frame(height: 30)
                Button {
                    login()
                } label: {
                    Text("Login")
                        .frame(width: 150, height: 40)
                        .background(RoundedRectangle(cornerRadius: 20, style:.continuous).fill(.linearGradient(colors:[Color.themeAccent, .black], startPoint: .top, endPoint: .bottomTrailing)))
                        .foregroundColor(.white)
                        .bold()
                }
            }
            .frame(width: 350)
        }
    }
    
    
    func register() {
        if firstName == "" || lastName == "" {
            self.error = "You must enter first and last name to make an account."
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) {result, error in
            if let error = error {
                print("Error!")
                print(error.localizedDescription)
                self.error = String(error.localizedDescription)
            } else {
                print("successfully registered user")
                let user = Auth.auth().currentUser
                if let user = user {
                    let uid = user.uid
                    userModel.addAndGetUser(userID: uid, firstName: firstName, lastName: lastName)
                    userIsLoggedIn.toggle()
                }
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Error!")
                print(error.localizedDescription)
                self.error = String(error.localizedDescription)
            } else {
                print("successfully logged in")
                let user = Auth.auth().currentUser
                if let user = user {
                    let uid = user.uid
                    _Concurrency.Task{
                        userModel.getUser(userID: uid) { thisUser in
                            houseModel.getAndSetHouse(houseID: thisUser.currentHouse ?? "") {
                                houseModel.getAndSetRoommates()
                                houseModel.getRoommateUpdates()
                                houseModel.getHouseUpdate()
                                
                            }
                            taskModel.loadTasks(houseID: thisUser.currentHouse ?? "")
                            taskModel.getTaskUpdates(houseID: thisUser.currentHouse ?? "")
                        }
                        userIsLoggedIn.toggle()
                    }
                }
            }
        }
    }
        
    
    func signout() {
        try? Auth.auth().signOut()
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            print("User \(uid) still logged in")
        } else {
            print("successfully logged out!")
            userIsLoggedIn.toggle()
        }
    }
}
        
        
    struct LaunchPageView_Previews: PreviewProvider {
            static var previews: some View {
                LaunchPageView()
            }
        }


