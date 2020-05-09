
import UIKit
import TextAttributes
import SwiftyStoreKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let defaults = NSUserDefaults.standardUserDefaults();
    var discoverymgr: DiscoveryManager!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        setupAppearance()
        registerOrGetUnique();
        discoverymgr = DiscoveryManager.sharedManager();

        let filter = CapabilityFilter.init()
        filter.addCapability(kMediaPlayerDisplayImage)
        
        discoverymgr.capabilityFilters = [filter];
        discoverymgr.startDiscovery()
        
        FIRApp.configure()
        GADMobileAds.configureWithApplicationID("ca-app-pub-6799799995218384~2450096508")
        return true
    }
    
    
    
    func registerOrGetUnique() {
        AdsService.sharedInstance.refreshKeychain();
        
        let deviceid_nsuser = defaults.stringForKey("uniqueId")
        if(deviceid_nsuser == nil) {
            let uuid = NSUUID().UUIDString
            defaults.setObject(uuid, forKey: "uniqueId")
            RestManager.sharedInstance.firstTimeUse()
        }
    }
    
    
    private func setupAppearance() {
        let navigationBar = UINavigationBar.appearance();
        navigationBar.tintColor = UIColor.whiteColor()
        navigationBar.barTintColor = UIColor.primaryColor()
        //navigationBar.translucent = false
        UIApplication.sharedApplication().statusBarStyle = .LightContent;
        let titleAttrs = TextAttributes()
            .font(UIFont.defaultFont(size: 19))
            .foregroundColor(UIColor.whiteColor())
        navigationBar.titleTextAttributes = titleAttrs.dictionary
        
        let barButtonItem = UIBarButtonItem.appearance()
        let barButtonAttrs = TextAttributes()
            .font(UIFont.defaultFont(size: 15))
            .foregroundColor(UIColor.whiteColor())
        barButtonItem.setTitleTextAttributes(barButtonAttrs.dictionary, forState: .Normal)
        barButtonItem.setTitleTextAttributes(barButtonAttrs.dictionary, forState: .Highlighted)
        UIApplication.sharedApplication().idleTimerDisabled = true
        
    }


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

