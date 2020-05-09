//
//  RestManager.swift
//  Live
//
//  Created by Jeevan Sivagnanasuntharam on 10/08/16.
//  Copyright © 2016 gressquel. All rights reserved.
//

import SwiftyJSON



class AdsService: NSObject {
    static let sharedInstance = AdsService()
    var AdsFree = false;

    func refreshKeychain () {
        let keychain = KeychainSwift()
        keychain.synchronizable = true;
        let receipt = keychain.get("receipt")
        if(receipt != nil) {
            AdsFree = true;
        }
    }
    
    func delLicense() {
        let keychain = KeychainSwift()
        keychain.synchronizable = true;
        keychain.delete("receipt")
    }

    func GetAdsFree() -> Bool {
        return AdsFree;
    }
    
    func SetAdsFree(adsFree : Bool) {
        AdsFree = adsFree;
    }

}