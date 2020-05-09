//
//  Webserver.swift
//  StreamBeam
//
//  Created by Jeevan Sivagnanasuntharam on 20/11/16.
//  Copyright © 2016 gressquel. All rights reserved.
//

import GCDWebServer
import Photos


class Webserver: NSObject {
    static let sharedInstance = Webserver()
    
    let baseURL =  Config.serverUrl;
    var deviceType = "";
    var defaults = NSUserDefaults.standardUserDefaults();
    var keychain = KeychainSwift()
    var webServer: GCDWebServer!
    
    func initWebServer(onCompletion: (Bool, String) -> Void) {
        var appVersion = "";
        if let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = version
        }
        webServer = GCDWebServer()
        webServer.addDefaultHandlerForMethod("GET", requestClass: GCDWebServerDataRequest.self, asyncProcessBlock:self.handleRequest);
        webServer.startWithPort(8080, bonjourName: "StreamBeam Cast \(appVersion)")
        onCompletion(true, (webServer.serverURL).absoluteString)
        //print("Visit \(webServer.serverURL) in your web browser")
    }
    
    func shutDownWebServer(onCompletion: (Bool) -> Void) {
        webServer.stop();
        onCompletion(true)
    }
    
    func getUrlForAsset(localIdentifier: String) -> String{
        return (webServer.serverURL).absoluteString + localIdentifier;
    }
    
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    
    
    func handleRequest(request: GCDWebServerRequest?, completionBlock:GCDWebServerCompletionBlock?) {
        //print(request?.headers)
        var localIdentifier = request?.path;
        localIdentifier = localIdentifier!.stringByReplacingCharactersInRange(localIdentifier!.startIndex..<localIdentifier!.startIndex.successor(), withString: "");
        let image = PHAsset.getAssetFromlocalIdentifier(localIdentifier!)
        if(image != nil) {
            if(image!.mediaType == PHAssetMediaType.Video) {
                let filePath = NSHomeDirectory() + "/Library/Caches/sb.mp4"
                let response = GCDWebServerFileResponse(file: filePath, byteRange: (request?.byteRange)!)
                if(response == nil) {
                    completionBlock!(GCDWebServerDataResponse(HTML:"<html><body><h1>Requested image not found</h1></body></html>"))
                    return;
                }
                response.setValue("bytes", forAdditionalHeader: "Accept-Ranges")
                completionBlock!(response)

            }
            if(image!.mediaType == PHAssetMediaType.Image) {
                let option = PHImageRequestOptions()
                option.synchronous = true
                PHImageManager.defaultManager().requestImageForAsset(image!, targetSize: CGSizeMake(2048, 2048), contentMode: .AspectFit, options: option, resultHandler: { (image :UIImage?, info :[NSObject : AnyObject]?) in
                    let targetsize = 1572864;
                    if let image = image {
                        let data = UIImageJPEGRepresentation(image, 1.0)!
                        if(Webserver.sharedInstance.deviceType == "roku" && targetsize < data.length ) {
                            let ratio = data.length / targetsize;
                            let newWidth = image.size.width / ratio;
                            let scaledImage = self.resizeImage(image, newWidth: newWidth);
                            let scaledData = UIImageJPEGRepresentation(scaledImage, 1.0)!
                            completionBlock!(GCDWebServerDataResponse(data:scaledData, contentType: "image/jpeg"))
                            return;
                        }
                        
                        completionBlock!(GCDWebServerDataResponse(data:data, contentType: "image/jpeg"))
                    }
                })
            }
        }
        else {
            completionBlock!(GCDWebServerDataResponse(HTML:"<html><body><h1>Requested image not found</h1></body></html>"))
        }
    }
    
}