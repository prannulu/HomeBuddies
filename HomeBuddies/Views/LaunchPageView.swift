//
//  ContentView.swift
//  HomeBuddies
//
//  Created by Pavi Rannulu on 1/23/23.
//

import SwiftUI
import FirebaseAuth

struct LaunchPageView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var userIsLoggedIn = false
    @StateObject var thisUser = UserViewModel()
    
    
    var body: some View {
        if userIsLoggedIn{
            UserPagesView(userModel: thisUser)
        } else {
            content
        }
    }
    
    var content: some View {
        NavigationView {
            ZStack {
                Color.green
                    .opacity(0.7)
                    .ignoresSafeArea()
                VStack{
                    Text("~ HomeBuddies ~").font(.title).foregroundColor(.white).bold()
                    Divider()
                    NavigationLink(destination: signin) {
                        Text("Login to existing account").padding()
                    }
                    NavigationLink(destination: signup) {
                        Text("Create new account")
                    }
                }
            }
        }
    }
    
    var signup: some View {
        ZStack{
            Color.green
                .opacity(0.3)
                .ignoresSafeArea()
            VStack(spacing: 20){
                Section {
                    Text("Create an account")
                        .bold()
                        .offset(y: -100)
                        .font(.title)
                    Text("Let's get started.").offset(y: -100)
                }
                TextField("First Name", text: $firstName)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .bold()
                
                Rectangle()
                    .frame(width: 350, height:1)
                    .foregroundColor(.black)
                
                TextField("LastName", text: $lastName)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .bold()
                
                Rectangle()
                    .frame(width: 350, height:1)
                    .foregroundColor(.black)
                
                TextField("Email", text: $email)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .bold()
                
                Rectangle()
                    .frame(width: 350, height:1)
                    .foregroundColor(.black)
                
                SecureField("Password", text: $password)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .bold()
                
                Rectangle()
                    .frame(width: 350, height:1)
                    .foregroundColor(.black)
                
                Button {
                    register()
                } label: {
                    Text("Sign Up")
                        .frame(width: 200, height: 40)
                        .background(RoundedRectangle(cornerRadius: 10, style:.continuous).fill(.linearGradient(colors:[.green, .black], startPoint: .top, endPoint: .bottomTrailing)))
                        .foregroundColor(.white)
                        .bold()
                }
            }
            .frame(width: 350)
            //          .onAppear {
            //                Auth.auth().addStateDidChangeListener { auth, user in
            //                    if user != nil {
            //                        userIsLoggedIn.toggle()
            //                    }
            //
            //                }
            //            }
        }
    }
    
    var signin: some View {
        ZStack {
            Color.green
                .opacity(0.3)
                .ignoresSafeArea()
            VStack(spacing: 20){
                Text("Welcome Back!")
                    .bold()
                    .offset(y: -100)
                    .font(.title)
                Text("Please sign in to continue").offset(y: -100)
                TextField("Email", text: $email)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .bold()
                
                Rectangle()
                    .frame(width: 350, height:1)
                    .foregroundColor(.black)
                
                SecureField("Password", text: $password)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .bold()
                
                Rectangle()
                    .frame(width: 350, height:1)
                    .foregroundColor(.black)
                
                Button {
                    login()
                } label: {
                    Text("Login")
                        .frame(width: 200, height: 40)
                        .background(RoundedRectangle(cornerRadius: 10, style:.continuous).fill(.linearGradient(colors:[.green, .black], startPoint: .top, endPoint: .bottomTrailing)))
                        .foregroundColor(.white)
                        .bold()
                }
            }
            .frame(width: 350)
            //            .onAppear {
            //                Auth.auth().addStateDidChangeListener { auth, user in
            //                    if user != nil {
            //                        userIsLoggedIn.toggle()
            //                    }
            //                }
            //            }
        }
    }
    
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) {result, error in
            if let error = error {
                print("Error!")
                print(error.localizedDescription)
            } else {
                print("successfully registered user")
                let user = Auth.auth().currentUser
                if let user = user {
                    let uid = user.uid
                    thisUser.addAndGetUser(userID: uid, firstName: firstName, lastName: lastName)
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
                } else {
                    print("successfully logged in")
                    let user = Auth.auth().currentUser
                    if let user = user {
                        let uid = user.uid
                        thisUser.getUser(userID: uid)
                        userIsLoggedIn.toggle()
                    }
                }
            }
        }
        
        
        
    struct LaunchPageView_Previews: PreviewProvider {
            static var previews: some View {
                LaunchPageView()
            }
        }
    }

