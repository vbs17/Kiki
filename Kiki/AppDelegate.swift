

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        FIRApp.configure()
        AdobeUXAuthManager.sharedManager().setAuthenticationParametersWithClientID("8d97c32277374a83a54f7dd19d86d4ce", withClientSecret: "8051e621-a25d-43dd-bc51-58a756df66cf")

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
     
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
     
    }

    func applicationWillTerminate(application: UIApplication) {
    
    }


}

