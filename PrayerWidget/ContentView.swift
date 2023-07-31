//
//  ContentView.swift
//  PrayerWidget
//
//  Created by LimpidSol on 31/01/2023.
//

import SwiftUI
import Firebase

struct ContentView: View {
    init() {
        self.autoLogin()     // non always good, but can
    }
    
    var body: some View {
        Home()
    }
    
    func autoLogin() {
        Auth.auth().signIn(withEmail: "prayer@widget.com", password: "12345678") { _, err in
            if let error = err {
                print(error.localizedDescription)
                return
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    
    @AppStorage("log_status") var status = false
    
    var body: some View {
        NavigationView {
            VStack() {
                if status {
                    Text("Logged In")
                    Button("LogOut") {
                        try? Auth.auth().signOut()
                        status = false
                    }
                }
                else {
                    Text("Logged Out")
                    
                    Button("Log In") {
                        Auth.auth().signIn(withEmail: "prayer@widget.com", password: "12345678") { _, err in
                            if let error = err {
                                print(error.localizedDescription)
                                return
                            }
                            
                            self.status = true
                        }
                    }
                }
            }
            .navigationTitle("Firebase Widgets")
            .animation(.easeInOut, value: status)
            
        }
    }
}
