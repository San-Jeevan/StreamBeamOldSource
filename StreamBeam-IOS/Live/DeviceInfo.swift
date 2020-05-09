//
//  DeviceInfo.swift
//  Live
//
//  Created by Jeevan Sivagnanasuntharam on 10/08/16.
//  Copyright © 2016 gressquel. All rights reserved.
//

import UIKit

extension NSBundle {
    
    var releaseVersionNumber: String? {
        return self.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersionNumber: String? {
        return self.infoDictionary?["CFBundleVersion"] as? String
    }
    
}



class DeviceInfo {
    var Name: String = UIDevice.currentDevice().modelName;
    var OSVersion: String  = UIDevice.currentDevice().systemVersion;
    var OS: Int = 0;
}