import SwiftUI

@main
struct FlockwhistleApp: App {
    @StateObject private var store = TrialStore()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            TrialRootView()
                .environmentObject(store)
                .preferredColorScheme(.dark)
        }
        .onChange(of: scenePhase) { phase in
            if phase == .background || phase == .inactive { store.saveNow() }
        }
    }
}
