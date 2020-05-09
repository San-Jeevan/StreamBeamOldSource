//
//  SettingsViewController.swift
//  Babymonitor
//
//  Created by Jeevan Sivagnanasuntharam on 21/08/16.
//  Copyright © 2016 gressquel. All rights reserved.
//

import Foundation
import UIKit
import SwiftyStoreKit
import SwiftyJSON
import JGProgressHUD

class SettingsNavController: UINavigationController {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

class SettingsViewController: UITableViewController {
    @IBOutlet weak var navbarItem: UINavigationItem!
    
    func backClicked () {
        self.dismissViewControllerAnimated(true) {
        }
    }
    
    
    override func viewDidLoad() {
        let leftback:UIBarButtonItem = UIBarButtonItem(title: NSLocalizedString("general.Done", comment: ""), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.backClicked))
        navbarItem.leftBarButtonItem = leftback;
        AdsService.sharedInstance.refreshKeychain();
    }
}

class SettingsNoiseViewController: UIViewController {
    var defaults = NSUserDefaults.standardUserDefaults();
  
    
    @IBOutlet weak var LicenseStatus: UILabel!
    @IBOutlet weak var creditDescription: UILabel!
    @IBOutlet weak var buyBtn: DesignableButton!
    var hud : JGProgressHUD!
    
    
    
    func maythrow (receipt:ReceiptInfo){
        var URL: NSURL? {
            return NSBundle.mainBundle().appStoreReceiptURL
        }
        
        var data: NSData? {
            if let receiptDataURL = URL, data = NSData(contentsOfURL: receiptDataURL) {
                return data
            }
            return nil
        }
        
        var base64EncodedString: String? {
            return data?.base64EncodedStringWithOptions([])
        }

        let keychain = KeychainSwift()
        keychain.synchronizable = true;
        keychain.set(base64EncodedString!, forKey: "receipt")
        AdsService.sharedInstance.refreshKeychain();
    }
    

    func triggerReceiptRefresh(){
        SwiftyStoreKit.verifyReceipt() { result in
            switch result {
            case .Success(let receipt):
                // Verify the purchase of Consumable or NonConsumable
                let purchaseResult = SwiftyStoreKit.verifyPurchase(
                    productId: "com.gressquel.StreamBeam.RemoveAds",
                    inReceipt: receipt
                );

                switch purchaseResult {
                case .Purchased(let expiresDate):
                    self.maythrow(receipt);
                case .NotPurchased:
                    print("The user has never purchased this product")
                }
            case .Error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
    }
    

    override func viewDidLoad() {
        hud = JGProgressHUD(style: JGProgressHUDStyle.Dark)
        hud.indicatorView = JGProgressHUDIndeterminateIndicatorView.init(HUDStyle: JGProgressHUDStyle.Dark);
        hud.textLabel.text = "Wait..";
        LicenseStatus.text = "";
        if(AdsService.sharedInstance.GetAdsFree()) {
        LicenseStatus.text = "You already have premium";
        }
        
        
        SwiftyStoreKit.retrieveProductsInfo(["com.gressquel.StreamBeam.RemoveAds"]) { result in
            if let product = result.retrievedProducts.first {
                let priceString = NSNumberFormatter.localizedStringFromNumber(product.price ?? 0, numberStyle: .CurrencyStyle)
                self.creditDescription.text = product.localizedDescription;
                self.buyBtn.setTitle("REMOVE ADS " + priceString, forState: UIControlState.Normal)
                self.buyBtn.hidden = false;
                self.creditDescription.hidden = false;
                
            }
            else if result.invalidProductIDs.first != nil {
                return print("invalid proctid")
            }
            else {
                print("Error: \(result.error)")
            }
        }
    }
    
    
    @IBAction func buyBtnClicked(sender: DesignableButton) {
        buyBtn.enabled = false;
        hud.showInView(self.view)
        SwiftyStoreKit.purchaseProduct("com.gressquel.StreamBeam.RemoveAds") { result in
            switch result {
            case .Success(let productId):
                //send to nodeserver
                self.buyBtn.enabled = true;
                self.hud.dismiss();
                RestManager.sharedInstance.purchase();
                self.triggerReceiptRefresh();
                
                print("Purchase Success: \(productId)")
            case .Error(let error):
                self.hud.dismiss();
                self.buyBtn.enabled = true;
                print("Purchase Failed: \(error)")
            }
        }
    }
    
}

class SettingsContactViewController: UIViewController {
    
    
    @IBOutlet weak var textArea: UITextView!
    
    @IBOutlet weak var navbarItem: UINavigationItem!
    @IBOutlet weak var emailfield: UITextField!
    var defaults = NSUserDefaults.standardUserDefaults();
    
    @IBAction func sendEmailClicked(sender: AnyObject) {
        if(!Common.sharedInstance.isValidEmail(emailfield.text!)) {
            self.view.makeToast(message: "Invalid email address", duration: 3.0, position: HRToastPositionTop)
            return;
        }
        let Name: String = UIDevice.currentDevice().name;
        let ModelName: String = UIDevice.currentDevice().modelName;
        let OSVersion: String  = UIDevice.currentDevice().systemVersion;
        let OS: Int = 0;
        let senderEmail : String = emailfield.text!;
        let emailBody : String = textArea.text!;
        let keychain = KeychainSwift()
        var deviceid = keychain.get("deviceid")
        
        //settings from phone for debugging issues

        if(deviceid==nil) {deviceid = ""}
        
        let data: Dictionary<String, AnyObject> = [ "device" : ModelName, "osversion": OSVersion, "os": OS, "name": Name, "senderEmail": senderEmail, "emailBody": emailBody, "App": "StreamBeam", "uuid": deviceid! ,"appVersion": String(format: "Version %02d (%02d)", NSBundle.mainBundle().releaseVersionNumber!, NSBundle.mainBundle().buildVersionNumber!)];
        self.navbarItem.rightBarButtonItem?.enabled = false;
        RestManager.sharedInstance.sendEmail(data) { (databack) in
            dispatch_async(dispatch_get_main_queue()) {
                self.view.makeToast(message: "Sent! We will contact you as soon as possible", duration: 5.0, position: HRToastPositionCenter);
            }
        }
        
    }
    override func viewDidLoad() {
        textArea.layer.borderColor = UIColor(hex: 0xC1C2C2).CGColor
        textArea.layer.borderWidth = 0.5;
        textArea.layer.cornerRadius = 5.0;
        textArea.text = NSLocalizedString("settings.WriteyourMessage", comment: "")
        
        let rightDone:UIBarButtonItem = UIBarButtonItem(title: "Send", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.sendEmailClicked))
        navbarItem.rightBarButtonItem = rightDone;
    }
    
}

class SettingsAboutViewController: UIViewController {
    @IBOutlet weak var VersionLabel: UILabel!
    
    @IBOutlet weak var aboutTextView: UITextView!
    override func viewDidLoad() {
        aboutTextView.text = NSLocalizedString("settings.AboutUs", comment: "")
        VersionLabel.text = String(format: "Version %02d (%02d)", NSBundle.mainBundle().releaseVersionNumber!, NSBundle.mainBundle().buildVersionNumber!)
    }
    
}



    


