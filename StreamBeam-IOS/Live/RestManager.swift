//
//  RestManager.swift
//  Live
//
//  Created by Jeevan Sivagnanasuntharam on 10/08/16.
//  Copyright © 2016 gressquel. All rights reserved.
//

import SwiftyJSON

typealias ServiceResponse = (JSON, NSError?) -> Void

class RestManager: NSObject {
    static let sharedInstance = RestManager()
    
    let baseURL =  Config.serverUrl;
    var defaults = NSUserDefaults.standardUserDefaults();
  


    
    func sendEmail(data: Dictionary<String, AnyObject>, onCompletion: (JSON) -> Void) {
        let route = baseURL + "api/contact";
        let params: Dictionary<String, AnyObject> = data;
        makeHTTPPostRequest(route, body:  params, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    func purchase() {
        let route = "https://mintestjeevan.azurewebsites.net/" + "api/StreamBeamRegister";
        let Name: String = UIDevice.currentDevice().name;
        let ModelName: String = UIDevice.currentDevice().modelName;
        let OSVersion: String  = UIDevice.currentDevice().systemVersion;
        var deviceid_nsuser = defaults.stringForKey("uniqueId")
        if(deviceid_nsuser==nil) {deviceid_nsuser = ""}
        let jb = isDeviceJailbroken().boolValue
        
        let data: Dictionary<String, AnyObject> = ["PartitionKey": "SBPurchase", "jb" : jb, "device" : ModelName, "osversion": OSVersion, "phonename": Name, "app": "StreamBeam", "uuid": deviceid_nsuser! ,"appVersion": String(format: "Version %02d (%02d)", NSBundle.mainBundle().releaseVersionNumber!, NSBundle.mainBundle().buildVersionNumber!)];
        
        makeHTTPPostRequest(route, body:  data, onCompletion: { json, err in
        
            
        })
    }
    
    func firstTimeUse() {
        let route = "https://mintestjeevan.azurewebsites.net/" + "api/StreamBeamRegister";
        let Name: String = UIDevice.currentDevice().name;
        let ModelName: String = UIDevice.currentDevice().modelName;
        let OSVersion: String  = UIDevice.currentDevice().systemVersion;
        var deviceid_nsuser = defaults.stringForKey("uniqueId")
        if(deviceid_nsuser==nil) {deviceid_nsuser = ""}
        let jb = isDeviceJailbroken().boolValue
        
        let data: Dictionary<String, AnyObject> = ["PartitionKey": "SBReg", "jb" : jb, "device" : ModelName, "osversion": OSVersion, "phonename": Name, "app": "StreamBeam", "uuid": deviceid_nsuser! ,"appVersion": String(format: "Version %02d (%02d)", NSBundle.mainBundle().releaseVersionNumber!, NSBundle.mainBundle().buildVersionNumber!)];
        
         makeHTTPPostRequest(route, body:  data, onCompletion: { json, err in
            //print(json)
        })
    }
    
    func errorLog(error: NSError, method: String) {
        let route = "https://mintestjeevan.azurewebsites.net/" + "api/StreamBeamRegister";
        let Name: String = UIDevice.currentDevice().name;
        let ModelName: String = UIDevice.currentDevice().modelName;
        let OSVersion: String  = UIDevice.currentDevice().systemVersion;
        var deviceid_nsuser = defaults.stringForKey("uniqueId")
        if(deviceid_nsuser==nil) {deviceid_nsuser = ""}
        let jb = isDeviceJailbroken().boolValue
        
        let data: Dictionary<String, AnyObject> = ["PartitionKey": "SBError", "method": method, "errordetails": error.description, "jb" : jb, "device" : ModelName, "osversion": OSVersion, "phonename": Name, "app": "StreamBeam", "uuid": deviceid_nsuser! ,"appVersion": String(format: "Version %02d (%02d)", NSBundle.mainBundle().releaseVersionNumber!, NSBundle.mainBundle().buildVersionNumber!)];
        
        makeHTTPPostRequest(route, body:  data, onCompletion: { json, err in
            //print(json)
        })
    }
    
    
  
    private func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if let jsonData = data {
                let json:JSON = JSON(data: jsonData)
                onCompletion(json, error)
            } else {
                onCompletion(nil, error)
            }
        })
        task.resume()
    }
    
  
    private func makeHTTPPostRequest(path: String, body: [String: AnyObject], onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        request.HTTPMethod = "POST"
        
        do {
            // Set the POST body for the request
            let jsonBody = try NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.PrettyPrinted)
            request.HTTPBody = jsonBody
            request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            let session = NSURLSession.sharedSession()
           
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                if let jsonData = data {
                    let json:JSON = JSON(data: jsonData)
                    onCompletion(json, nil)
                } else {
                    onCompletion(nil, error)
                }
            })
            task.resume();
        } catch {
            
            onCompletion(nil, nil)
        }
    }
}