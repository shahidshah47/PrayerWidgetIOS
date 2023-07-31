//
//  Prayer.swift
//  Prayer
//
//  Created by LimpidSol on 31/01/2023.
//

import WidgetKit
import SwiftUI
import Intents
import Firebase

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {

        let date = Date()
        var entries = [SimpleEntry]()
        let midnight = Calendar.current.startOfDay(for: date)
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 1, to: date)!
        
        fetchDB{prayer in
            let entry = SimpleEntry(date: date, configuration: configuration, prayerData: prayer)
            
            for offset in 0 ..< 60 * 1 {
                let entryDate = Calendar.current.date(byAdding: .minute, value: offset, to: midnight)!
                entries.append(SimpleEntry(date: entryDate, configuration: configuration, prayerData: prayer))
            }
            
            let timeline = Timeline(entries: entries, policy: .after(nextUpdate))
            
            completion(timeline)
        }
    }
    
    func fetchDB(completion: @escaping (PrayerModel) -> ()) {
//        guard let _ = Auth.auth().currentUser else {
//            completion(PrayerModel(prayerValue: [], error: "Please Login!"))
//            return
//        }
        
        let ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("prayerTimes").child("1001").child("20230101").observe(.value) { snapshot in
//            guard let doc = snapshot.value else {
//                completion(PrayerModel(prayerValue: []))
//                return
//            }
            
            let doc: NSDictionary = snapshot.value as! NSDictionary
            let fajr: String = doc["Fajr"] as? String ?? "Not found Fajr"
            let sunrise: String = doc["Sunrise"] as? String ?? "Not found Sunrise"
            let dhuhr: String = doc["Dhuhr"] as? String ?? "Not found Dhuhr"
            let asr: String = doc["Asr"] as? String ?? "Not found Asr"
            let maghrib: String = doc["Maghrib"] as? String ?? "Not found Maghrib"
            let isha: String = doc["Isha"] as? String ?? "Not found Isha"
            
            
            completion(PrayerModel(fajr: fajr, sunrise: sunrise, dhuhr: dhuhr, asr: asr, maghrib: maghrib, isha: isha))
        }
        
//        let db = Firestore.firestore().collection("prayerTimes").document("FDMPRv7vMKiHujBVLv1P")
//
//        db.getDocument { snap, err in
//            guard let doc = snap?.data() else {
//                completion(PrayerModel(prayerValue: [], error: err?.localizedDescription ?? ""))
//                return
//            }
//
//            let fajr: String = doc["Fajr"] as? String ?? "Not found Fajr"
//            let sunrise: String = doc["Sunrise"] as? String ?? "Not found Sunrise"
//            let dhuhr: String = doc["Dhuhr"] as? String ?? "Not found Dhuhr"
//            let asr: String = doc["Asr"] as? String ?? "Not found Asr"
//            let maghrib: String = doc["Maghrib"] as? String ?? "Not found Maghrib"
//            let isha: String = doc["Isha"] as? String ?? "Not found Isha"
//
//
//            completion(PrayerModel(fajr: fajr, sunrise: sunrise, dhuhr: dhuhr, asr: asr, maghrib: maghrib, isha: isha))
//        }
        
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    var prayerData: PrayerModel?
}

struct PrayerEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        HStack {
            HStack {
                VStack {
                    if let prayer = entry.prayerData {
                        if prayer.error == "" {
                            let isFajr: Bool = self.isPrayerTime(prayerTime: prayer.fajr)
                            let isSunrise: Bool = self.isPrayerTime(prayerTime: prayer.sunrise)
                            let isDhuhr: Bool = self.isPrayerTime(prayerTime: prayer.dhuhr)
                            let isAsr: Bool = self.isPrayerTime(prayerTime: prayer.asr)
                            let isMaghrib: Bool = self.isPrayerTime(prayerTime: prayer.maghrib)
                            let isIsha: Bool = self.isPrayerTime(prayerTime: prayer.isha)
                            if isFajr {
                                Text("To Fajr")
                                    .foregroundColor(.white)
                                    .font(.system(size: 25))
                                Text(self.describeComparison(prayerTime: prayer.fajr))
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 45))
                            }
                            else if isSunrise {
                                Text("To Sunrise")
                                    .foregroundColor(.white)
                                    .font(.system(size: 25))
                                Text(self.describeComparison(prayerTime: prayer.sunrise))
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 45))
                            }
                            else if isDhuhr {
                                Text("To Dhuhr")
                                    .foregroundColor(.white)
                                    .font(.system(size: 25))
                                Text(self.describeComparison(prayerTime: prayer.dhuhr))
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 45))
                            }
                            else if isAsr {
                                Text("To Asr")
                                    .foregroundColor(.white)
                                    .font(.system(size: 25))
                                Text(self.describeComparison(prayerTime: prayer.asr))
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 45))
                            }
                            else if isMaghrib {
                                Text("To Maghrib")
                                    .foregroundColor(.white)
                                    .font(.system(size: 25))
                                Text(self.describeComparison(prayerTime: prayer.maghrib))
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 45))
                            }
                            else if isIsha {
                                Text("To Isha")
                                    .foregroundColor(.white)
                                    .font(.system(size: 25))
                                Text(self.describeComparison(prayerTime: prayer.isha))
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 45))
                            }
                            else {
                                Text("To Fajr")
                                    .foregroundColor(.white)
                                    .font(.system(size: 25))
                                Text(self.describeComparison(prayerTime: prayer.fajr))
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 45))
                            }
                            
                            Text("min.")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            
                        }
                        else {
                            Text(prayer.error).padding()
                        }
                    }
                    else {
                        Text("Fetching Data...")
                    }
                }
                .background(Color.init(hex: "#1f5852"))
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                .cornerRadius(30)
                .ignoresSafeArea()
            }
            .padding(.leading, 10)
            .padding(.trailing, 10)
            .background(Color.init(hex: "#1f5852"))
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            .cornerRadius(30)
            .ignoresSafeArea()
            HStack {
                VStack(alignment: .leading) {
                    if let prayer = entry.prayerData {
                        if prayer.error == "" {
                            let highlightedPrayerTime = self.isHighlightedPrayerTime(prayer: prayer)
                            
                            
                            if highlightedPrayerTime == prayer.fajr {
                                HStack {
                                    Text("Fajr:")
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 5)
                                    Text(prayer.fajr)
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .padding(.trailing, 5)
                                }
                                .background(Color.init(hex: "#1f5852"))
                            }
                            else {
                                HStack {
                                    Text("Fajr:")
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 5)
                                    Text(prayer.fajr)
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .padding(.trailing, 5)
                                }
                            }
                            if highlightedPrayerTime == prayer.sunrise {
                                HStack {
                                    Text("Sunrise:")
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 5)
                                    Text(prayer.sunrise)
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .padding(.trailing, 5)
                                }
                                .background(Color.init(hex: "#1f5852"))
                            }
                            else {
                                HStack {
                                    Text("Sunrise:")
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 5)
                                    Text(prayer.sunrise)
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .padding(.trailing, 5)
                                }
                            }
                            if highlightedPrayerTime == prayer.dhuhr {
                                HStack {
                                    Text("Dhuhr:")
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 5)
                                    Text(prayer.dhuhr)
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .padding(.trailing, 5)
                                }
                                .background(Color.init(hex: "#1f5852"))
                            }
                            else {
                                HStack {
                                    Text("Dhuhr:")
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 5)
                                    Text(prayer.dhuhr)
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .padding(.trailing, 5)
                                }
                            }
                            if highlightedPrayerTime == prayer.asr {
                                HStack {
                                    Text("Asr:")
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 5)
                                    Text(prayer.asr)
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .padding(.trailing, 5)
                                }
                                .background(Color.init(hex: "#1f5852"))
                            }
                            else {
                                HStack {
                                    Text("Asr:")
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 5)
                                    Text(prayer.asr)
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .padding(.trailing, 5)
                                }
                            }
                            if highlightedPrayerTime == prayer.maghrib {
                                HStack {
                                    Text("Maghrib:")
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 5)
                                    Text(prayer.maghrib)
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .padding(.trailing, 5)
                                }
                                .background(Color.init(hex: "#1f5852"))
                            }
                            else {
                                HStack {
                                    Text("Maghrib:")
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 5)
                                    Text(prayer.maghrib)
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .padding(.trailing, 5)
                                }
                            }
                            if highlightedPrayerTime == prayer.isha {
                                HStack {
                                    Text("Isha:")
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 5)
                                    Text(prayer.isha)
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .padding(.trailing, 5)
                                }
                                .background(Color.init(hex: "#1f5852"))
                            }
                            else {
                                HStack {
                                    Text("Isha:")
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 5)
                                    Text(prayer.isha)
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .padding(.trailing, 5)
                                }
                            }
                        }
                        else {
                            Text(prayer.error).padding()
                        }
                    }
                    else {
                        Text("Fetching Data...")
                    }
                }
            }
            .ignoresSafeArea()
        }
        .padding()
        .ignoresSafeArea()
        .background(Color.init(hex: "#4b7571"))
    }
    
    func isHighlightedPrayerTime(prayer: PrayerModel) -> String {
        let isFajr: Bool = self.isPrayerTime(prayerTime: prayer.fajr)
        let isSunrise: Bool = self.isPrayerTime(prayerTime: prayer.sunrise)
        let isDhuhr: Bool = self.isPrayerTime(prayerTime: prayer.dhuhr)
        let isAsr: Bool = self.isPrayerTime(prayerTime: prayer.asr)
        let isMaghrib: Bool = self.isPrayerTime(prayerTime: prayer.maghrib)
        let isIsha: Bool = self.isPrayerTime(prayerTime: prayer.isha)
        if isFajr {
            return prayer.fajr
        }
        else if isSunrise {
            return prayer.sunrise
        }
        else if isDhuhr {
            return prayer.dhuhr
        }
        else if isAsr {
            return prayer.asr
        }
        else if isMaghrib {
            return prayer.maghrib
        }
        else if isIsha {
            return prayer.isha
        }
        
        return ""
    }
    
    func isPrayerTime(prayerTime: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "HH:mm"
        var date: Date = dateFormatter.date(from:prayerTime) ?? Date()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var todayDateStr = ""
        let now = Calendar.current.dateComponents(in: .current, from: Date())

        // Create the start of the day in `DateComponents` by leaving off the time.
        let today = DateComponents(year: now.year, month: now.month, day: now.day)
        let dateToday = Calendar.current.date(from: today)!
       
        todayDateStr = dateFormatter.string(from: dateToday)
        let tomorrowAray: NSArray = todayDateStr.split(separator: " ") as NSArray
        if tomorrowAray.count > 0 {
            let year: String = tomorrowAray[0] as! String
            todayDateStr = year + " " + prayerTime + ":00"
            date = dateFormatter.date(from: todayDateStr) ?? Date()
        }
        
        if Date() < date {
            return true
        }
        
        return false
    }
    
    func describeComparison(prayerTime: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "HH:mm"
        var date: Date = dateFormatter.date(from:prayerTime) ?? Date()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let now = Calendar.current.dateComponents(in: .current, from: Date())

        // Create the start of the day in `DateComponents` by leaving off the time.
        let today = DateComponents(year: now.year, month: now.month, day: now.day)
        date = Calendar.current.date(from: today)!

        // Add 1 to the day to get tomorrow.
        // Don't worry about month and year wraps, the API handles that.
        var tomorrow = DateComponents(year: now.year, month: now.month, day: now.day! + 0)
        date = Calendar.current.date(from: tomorrow)!
        var tomorrowStr = dateFormatter.string(from: date)
        var tomorrowAray: NSArray = tomorrowStr.split(separator: " ") as NSArray
        if tomorrowAray.count > 0 {
            let year: String = tomorrowAray[0] as! String
            tomorrowStr = year + " " + prayerTime + ":00"
            date = dateFormatter.date(from: tomorrowStr) ?? Date()
        }
        
        var diffComponents = Calendar.current.dateComponents([.hour, .minute], from: Date(), to: date)
        var hours = diffComponents.hour
        var minutes = diffComponents.minute
        
        if hours ?? 0 < 0 {
            // Add 1 to the day to get tomorrow.
            // Don't worry about month and year wraps, the API handles that.
            tomorrow = DateComponents(year: now.year, month: now.month, day: now.day! + 1)
            date = Calendar.current.date(from: tomorrow)!
            tomorrowStr = dateFormatter.string(from: date)
            tomorrowAray = tomorrowStr.split(separator: " ") as NSArray
            if tomorrowAray.count > 0 {
                let year = tomorrowAray[0] as! String
                tomorrowStr = year + " " + prayerTime + ":00"
                date = dateFormatter.date(from: tomorrowStr) ?? Date()
            }
            
            diffComponents = Calendar.current.dateComponents([.hour, .minute], from: Date(), to: date)
            hours = diffComponents.hour
            minutes = diffComponents.minute
        }
        
        var hourStr: String = "\(hours ?? 0)"
        if hours! < 10 {
            hourStr = "0\(hours ?? 0)"
        }
        
        var minutStr: String = "\(minutes ?? 0)"
        if minutes! < 10 {
            minutStr = "0\(minutes ?? 0)"
        }
        
        let pTime: String = hourStr + ":" + minutStr
        
        return pTime
    }
}

struct PrayerModel: Identifiable {
    var id = UUID().uuidString
    var prayerValue: NSMutableArray = []
    var fajr: String = ""
    var sunrise: String = ""
    var dhuhr: String = ""
    var asr: String = ""
    var maghrib: String = ""
    var isha: String = ""
    var error: String = ""
}

@main
struct Prayer: Widget {
    init() {
        FirebaseApp.configure()
        
//        do {
//          try Auth.auth().useUserAccessGroup("\(teamID).LimpidSol.PrayerWidget")
//        } catch let error as NSError {
//            print("Error changing user access group: %@", error.localizedDescription)
//        }
    }
    
    let kind: String = "Prayer"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            PrayerEntryView(entry: entry)
        }
        .supportedFamilies([.systemMedium])
        .configurationDisplayName("Prayer")
        .description("Prayer Graph.")
    }
}

struct Prayer_Previews: PreviewProvider {
    static var previews: some View {
        PrayerEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
