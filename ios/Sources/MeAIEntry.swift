import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    let callKitManager = CallKitManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Wire PushKit payload directly into CallKit
        VoIPPushManager.shared.onIncomingCall = { [weak self] id, handle, name in
            self?.callKitManager.reportIncomingCall(id: id, handle: handle, name: name)
        }
        
        // Arm the PushKit engine
        VoIPPushManager.shared.start()
        
        return true
    }
}

@main
struct MeAIEntry: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MeAIAppShell()
        }
    }
}
