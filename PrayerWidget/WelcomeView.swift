//
//  WelcomeView.swift
//  PrayerWidget
//
//  Created by LimpidSol on 31/01/2023.
//

import SwiftUI

struct WelcomeView: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            ContentView()
        }
        else {
            VStack {
                Image("splash")
            }.onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    isActive = true
                }
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
