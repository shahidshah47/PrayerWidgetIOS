//
//  PrayerWidgetApp.swift
//  PrayerWidget
//
//  Created by LimpidSol on 31/01/2023.
//

import SwiftUI
import Firebase

@main
struct PrayerWidgetApp: App {
    
    init() {
        FirebaseApp.configure()
        
        let ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("prayerTimes").child("1001").child("20230101").observe(.value) { snapshot in
//            guard let doc = snapshot.value else {
//                completion(PrayerModel(prayerValue: []))
//                return
//            }
            
            let doc: NSDictionary = snapshot.value as! NSDictionary
            print(doc)
            let fajr: String = doc["Fajr"] as? String ?? "Not found Fajr"
            let sunrise: String = doc["Sunrise"] as? String ?? "Not found Sunrise"
            let dhuhr: String = doc["Dhuhr"] as? String ?? "Not found Dhuhr"
            let asr: String = doc["Asr"] as? String ?? "Not found Asr"
            let maghrib: String = doc["Maghrib"] as? String ?? "Not found Maghrib"
            let isha: String = doc["Isha"] as? String ?? "Not found Isha"
        }
        
//        do {
//          try Auth.auth().useUserAccessGroup("\(teamID).ch.takvim.app")
//        } catch let error as NSError {
//            print("Error changing user access group: %@", error.localizedDescription)
//        }
    }
    
    var body: some Scene {
        WindowGroup {
            WelcomeView()
        }
    }
}
