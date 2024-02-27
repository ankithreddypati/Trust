import SwiftUI
import SwiftData

@main
struct MyApp: App {
 //   @StateObject private var soundSettings = SoundSettings()

    
    var body: some Scene {
        WindowGroup {
            ContentView() 
                .modelContainer(for: [PlayerScore.self])
          //      .environmentObject(soundSettings)
     
        }
    }
}
