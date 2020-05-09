

import UIKit
import SwiftyJSON
import Photos
import Social

protocol AlbumDelegate {
    func DisconnectWebsession()
    func CastAsset(url: String, mimeType: String)
}

class HomeViewController: UIViewController, DevicePickerDelegate, ConnectableDeviceDelegate, WebAppSessionDelegate, UINavigationControllerDelegate, AlbumDelegate  {


    @IBOutlet weak var givePermissionBTN: UIButton!
    @IBOutlet weak var BlurAlbum: UIVisualEffectView!
    @IBOutlet weak var BlurLiveCamera: UIVisualEffectView!
    @IBOutlet weak var BlurRemoteUrl: UIVisualEffectView!
    @IBOutlet weak var BtnRemoteUrl: UIButton!
    @IBOutlet weak var BtnLiveCamera: UIButton!
    @IBOutlet weak var BtnStreamAlbum: UIButton!
    @IBOutlet weak var selectDevice: UILabel!
    var clipboardTimer : NSTimer!
    var discoverymgr: DiscoveryManager!
    var _device: ConnectableDevice!
    var webappsession: WebAppSession!
    var launchSession: LaunchSession!
    let imagePickerController = UIImagePickerController()
    var videoURL: NSURL?
    

    func devicePicker(picker: DevicePicker!, didSelectDevice device: ConnectableDevice!) {
        showIndexChoiceBtns();
        _device = device;
        _device.delegate = self;
        selectDevice.text = _device.friendlyName;
        selectDevice.textColor = UIColor.whiteColor();
        _device.connect();
    }
    
    func devicePicker(picker: DevicePicker!, didCancelWithError error: NSError!) {
        //TODO: Show alert with error.

    }
    
    func connectableDeviceReady(device: ConnectableDevice!) {
        var serviceType = "";
        if(device.serviceWithName("Roku") != nil) {
        serviceType = "roku"
        }
        if(device.serviceWithName("Chromecast") != nil) {
            serviceType = "chromecast"
        }
        if(device.serviceWithName("FireTV") != nil) {
            serviceType = "firetv"
        }
        if(device.serviceWithName("AirPlay") != nil) {
            serviceType = "airplay"
        }
        Webserver.sharedInstance.deviceType = serviceType;
        print("connectableDeviceReady");
    }
    
    
    func connectableDeviceDisconnected(device: ConnectableDevice!, withError error: NSError!) {
        
    }
    
    func connectableDevicePairingSuccess(device: ConnectableDevice!, service: DeviceService!) {
        
    }
    
    func connectableDeviceConnectionSuccess(device: ConnectableDevice!, forService service: DeviceService!) {
        
    }
    
    override func viewDidLoad() {
        discoverymgr = DiscoveryManager.sharedManager();
        discoverymgr.devicePicker().delegate = self;
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.handleTap(_:)))
        view.addGestureRecognizer(tap)

        let tapDeviceSelect = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.selectDeviceLblClicked(_:)))
        selectDevice.addGestureRecognizer(tapDeviceSelect);
        super.viewDidLoad()
        }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
    
    
    func selectDeviceLblClicked(gesture: UITapGestureRecognizer) {
        discoverymgr.devicePicker().showPicker(view);
            guard gesture.state == .Ended else {
            return
        }
    }
    
    func handleTap(gesture: UITapGestureRecognizer) {
       view.endEditing(true)
        guard gesture.state == .Ended else {
            return
        }
    }

    @IBAction func openPermissionPage(sender: AnyObject) {
        let alertController = UIAlertController (title: "Give permission", message: "Go to Settings?", preferredStyle: .Alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .Default) { (_) -> Void in
            let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

    //ALBUM DELEGATES
    func DisconnectWebsession() {
         _device.mediaPlayer().closeMedia(launchSession, success: { (success) in
            //print("closed successfylly")
            }) { (error) in
              //print(error)
        }
    }

    
    //castimg because on roku playmediawithmedia info fails
    func CastImage(url: String, mimeType: String) {
        let mediaURL = NSURL(string: url);
        let mediaInfo = MediaInfo.init(URL: mediaURL, mimeType: mimeType);
        
        _device.mediaPlayer().displayImageWithMediaInfo(mediaInfo, success: { (mediacontrol) in
            self.launchSession = mediacontrol.session;
            //NSLog("play video success");
        }) { (error) in
             //NSLog("error");
             RestManager.sharedInstance.errorLog(error, method: "CastImage")
        }
       }

    
    func CastAsset(url: String, mimeType: String) {
        if(mimeType=="image/png" || mimeType=="image/jpeg" || mimeType=="image/jpg") {
            CastImage(url, mimeType: mimeType);
            return;
        }
        let mediaURL = NSURL(string: url);
        let mediaInfo = MediaInfo.init(URL: mediaURL, mimeType: mimeType);
        _device.mediaPlayer().playMediaWithMediaInfo(mediaInfo, shouldLoop: false, success: { (mediacontrol) in
            self.launchSession = mediacontrol.session;
            //NSLog("play video success");
            
        }) {(error) in
            //NSLog("error");
            RestManager.sharedInstance.errorLog(error, method: "CastAsset")
        }
    }
    
    //BTN CLICK HANDLERS
    @IBAction func AlbumBtnClicked(sender: AnyObject) {
        let photos: PrivateResource = .Photos
        proposeToAccess(photos, agreed: {
                if let vc3 = self.storyboard?.instantiateViewControllerWithIdentifier("LocalMediaController") as? LocalMediaController {
                    vc3.albumDelegate = self;
                    self.presentViewController(vc3, animated: false, completion: nil)
                }
            }, rejected: {
                self.givePermissionBTN.enabled = true;
                self.view.makeToast(message: "App has not been granted permission to access camera album, this functionality will not work", duration: 5.0, position: HRToastPositionCenter);
        })

    }
    
    @IBAction func LiveBtnClicked(sender: AnyObject) {
            self.performSegueWithIdentifier("gotosettings", sender: self)
    }
   
    @IBAction func RemoteUrlBtnClicked(sender: AnyObject) {
        if let vc3 = self.storyboard?.instantiateViewControllerWithIdentifier("RemoteUrlController") as? RemoteUrlController {
            vc3.albumDelegate = self;
            presentViewController(vc3, animated: false, completion: nil)
        }
    }
    
    
    
    @IBAction func instaBtn(sender: AnyObject) {
        let firstActivityItem = "Nice app, check it out"
        let secondActivityItem : NSURL = NSURL(string: "https://itunes.apple.com/app/streambeam/id1179607280?")!
        let image : UIImage = UIImage(named: "launchicon")!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem, image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = (sender as! UIButton)
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.Up
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        

        activityViewController.excludedActivityTypes = [
            UIActivityTypePostToWeibo,
            UIActivityTypePrint,
            UIActivityTypeAssignToContact,
            UIActivityTypeSaveToCameraRoll,
            UIActivityTypeAddToReadingList,
            UIActivityTypePostToFlickr,
            UIActivityTypePostToVimeo,
            UIActivityTypePostToTencentWeibo
        ]
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    

    
    @IBAction func twitterBtn(sender: AnyObject) {
        let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        vc.setInitialText("Neat little iOS app!")
        vc.addURL(NSURL(string: "https://itunes.apple.com/app/streambeam/id1179607280?"))
        presentViewController(vc, animated: true, completion: nil)

    }
    
    @IBAction func fbBtn(sender: AnyObject) {
        let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        vc.setInitialText("Neat little iOS app!")
        vc.addURL(NSURL(string: "https://itunes.apple.com/app/streambeam/id1179607280?"))
        presentViewController(vc, animated: true, completion: nil)
    }
    

    
    //STATIC METHODS
    func showIndexChoiceBtns(){
        BlurAlbum.hidden = false;
        BlurRemoteUrl.hidden = false;
        BlurLiveCamera.hidden = false;
        BtnStreamAlbum.hidden = false;
        BtnRemoteUrl.hidden = false;
        BtnLiveCamera.hidden = false;
    }
    
    func hideIndexChoiceBtns(){
        BlurAlbum.hidden = true;
        BlurRemoteUrl.hidden = true;
        BlurLiveCamera.hidden = true;
        BtnStreamAlbum.hidden = true;
        BtnRemoteUrl.hidden = true;
        BtnLiveCamera.hidden = true;
    }
    
    
    //DESIGN STUFF
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.Portrait;
    }
    
    override func shouldAutorotate() -> Bool {
        return false;
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}
