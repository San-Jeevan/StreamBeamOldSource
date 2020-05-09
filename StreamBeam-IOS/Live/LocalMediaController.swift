//
//  LocalMediaController.swift
//  StreamBeam
//
//  Created by Jeevan Sivagnanasuntharam on 16/11/16.
//  Copyright © 2016 gressquel. All rights reserved.
//

import UIKit
import AssetsLibrary;
import Photos
import GoogleMobileAds
import Foundation


class LocalMediaController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, GADInterstitialDelegate  {
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var collectionView: UICollectionView!
    var assetArray = [PHAsset]()
    var cellIdentifier = "LocalViewCell"
    var albumDelegate: AlbumDelegate!
    var interstitial: GADInterstitial!
    
    
    override func viewDidLoad() {
        let button = UIButton(type: UIButtonType.Custom) as UIButton
        button.setImage(UIImage(named: "exit"), forState: UIControlState.Normal)
        button.addTarget(self, action:#selector(LocalMediaController.cancelClicked), forControlEvents: UIControlEvents.TouchUpInside)
        button.frame=CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navItem.leftBarButtonItem = barButton
        
        //self.navItem.setLeftBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(self.cancelClicked)), animated: true)
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let allPhotosResult = PHAsset.fetchAssetsWithOptions(allPhotosOptions)
        allPhotosResult.enumerateObjectsUsingBlock { (asset, count, success) in
            self.assetArray.append(asset as! PHAsset)
        }

        Webserver.sharedInstance.initWebServer(webServerStarted)
        
        let isPremium = AdsService.sharedInstance.GetAdsFree();
        if isPremium == false {
            createAndLoadInterstitial();
            NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: #selector(LocalMediaController.displayAd), userInfo: nil, repeats: false)
            NSTimer.scheduledTimerWithTimeInterval(300, target: self, selector: #selector(LocalMediaController.displayAd), userInfo: nil, repeats: true)
        }
        
        super.viewDidLoad()
    }
    
    func webServerStarted(success: Bool, message: String){
        print(success);
        print(message);
    }
    
    func webServerStopped(success: Bool){
        //dismiss only when webserver has been shutdown
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int{
        return 1
    }
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assetArray.count
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! LocalViewCell
        let phasset = assetArray[indexPath.row]
        cell.fillData(phasset)
        return cell
    }
    
    
    func ReceivedUrlAsset(url: NSURL?){
        print(url);
    }
    
    
    
    func ConvertToMp4(image: PHAsset) {
        let msg = "You have selected a .MOV file. This format is not supported by FireTV, please wait while video is converted to .MP4";
        let msg2 = "Converted to .mp4 successfully!";
        view.makeToast(message: msg, duration: 5, position: HRToastPositionCenter)
        let filePath = NSHomeDirectory() + "/Library/Caches/sb.mp4"
        let fileManager = NSFileManager.defaultManager()
        if(fileManager.fileExistsAtPath(filePath)) {
            do {
                try fileManager.removeItemAtPath(filePath)
            }
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
                  RestManager.sharedInstance.errorLog(error, method: "removeItemAtPathConvertToMp4")
            }
        }

        let localidentifier = image.localIdentifier;
        let formattedIdentifier = localidentifier.substringToIndex(localidentifier.characters.indexOf(("/"))!);
        let raggy = image.valueForKey("filename") as? String
        self.navItem.title = raggy;
        let vidoption = PHVideoRequestOptions()
        vidoption.version = PHVideoRequestOptionsVersion.Current;
        PHImageManager.defaultManager().requestAVAssetForVideo(image, options: vidoption, resultHandler: { (avasset, audioMix, dictionary) in
            if let nextURLAsset = avasset as? AVURLAsset {
                let exportSession = AVAssetExportSession(asset: avasset!, presetName: AVAssetExportPreset1280x720)!
                exportSession.outputFileType = AVFileTypeMPEG4
                exportSession.outputURL = NSURL.init(fileURLWithPath: filePath)
                
                exportSession.exportAsynchronouslyWithCompletionHandler {
                    guard exportSession.error == nil else {
                        print(exportSession.error)
                        RestManager.sharedInstance.errorLog(exportSession.error!, method: "ExportAsyncConvertToMp4")
                        return
                    }
 
                    dispatch_async(dispatch_get_main_queue()) {
                        self.view.makeToast(message: msg2, duration: 2, position: HRToastPositionCenter)
                    }
                    let mediatype = "video/mp4";
                    let url = Webserver.sharedInstance.getUrlForAsset(formattedIdentifier);
                    self.albumDelegate.CastAsset(url, mimeType: mediatype)
                    return;

      }
    }
        })
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let filePath = NSHomeDirectory() + "/Library/Caches/sb.mp4"
        let image = self.assetArray[indexPath.row]
        let localidentifier = image.localIdentifier;
        let formattedIdentifier = localidentifier.substringToIndex(localidentifier.characters.indexOf(("/"))!);
        let raggy = image.valueForKey("filename") as? String
        self.navItem.title = raggy;
        if(image.mediaType == PHAssetMediaType.Video) {
            if(Webserver.sharedInstance.deviceType == "firetv" && (raggy?.lowercaseString.containsString(".mov"))!) {
                ConvertToMp4(image);
                return;
            }
            let vidoption = PHVideoRequestOptions()
            vidoption.version = PHVideoRequestOptionsVersion.Current;
            PHImageManager.defaultManager().requestAVAssetForVideo(image, options: vidoption, resultHandler: { (avasset, audioMix, dictionary) in
                if let nextURLAsset = avasset as? AVURLAsset {
                    let data = NSData(contentsOfURL: nextURLAsset.URL)
                    do {
                        try data!.writeToFile(filePath, atomically: true)
                    } catch let error as NSError {
                         RestManager.sharedInstance.errorLog(error, method: "WriteToFileCollectionView")
                        print(error.description)
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        let mediatype = "video/mp4";
                        let url = Webserver.sharedInstance.getUrlForAsset(formattedIdentifier);
                        self.albumDelegate.CastAsset(url, mimeType: mediatype)
                    }
                   }
            })
            return;
        }
                
        var mediatype = "image/jpeg";
        if(image.mediaType == PHAssetMediaType.Video) {
        mediatype = "video/mp4";
        }
        if(image.mediaType == PHAssetMediaType.Image) {
            if(Webserver.sharedInstance.deviceType == "roku") {
                let msg = "ROKU does not support images larger than 1.5 MB. Downscaling image....";
                view.makeToast(message: msg, duration: 5, position: HRToastPositionCenter)
            }
        mediatype = "image/png";
        }
        
        let url = Webserver.sharedInstance.getUrlForAsset(formattedIdentifier);
        albumDelegate.CastAsset(url, mimeType: mediatype)
    }
    
    
    //ADMOB
    func interstitial(ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
         print("FAILED")
         print(error);
    }
    
    func interstitialDidReceiveAd(ad: GADInterstitial) {
         print("interstitialDidReceiveAd")
        interstitial = ad;
    }
    
    func displayAd(){
        print("displayAd")
        interstitial.presentFromRootViewController(self)
    }
    
    private func createAndLoadInterstitial() {
         print("createAndLoadInterstitial")
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-6799799995218384/3926829705")
        let request = GADRequest()
        // Request test ads on devices you specify. Your test device ID is printed to the console when
        // an ad request is made.
        request.testDevices = [ kGADSimulatorID, "0598b5a50a0e2e726a5ab72871120825" ]
        interstitial.loadRequest(request)
    }
    
    
    //STATIC THINGS
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navBar.shadowImage = UIImage()
        navBar.translucent = true
        
        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        backgroundImage.image = UIImage(named: "bgstars")
        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill;
        self.view.insertSubview(backgroundImage, atIndex: 0);
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        self.view.insertSubview(blurEffectView, atIndex: 1);
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func cancelClicked(){
        albumDelegate.DisconnectWebsession();
        Webserver.sharedInstance.shutDownWebServer(webServerStopped);
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth = (view.bounds.width / 3.0) - 3
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
            layout.invalidateLayout()
        }
    }

    
    
    
}
