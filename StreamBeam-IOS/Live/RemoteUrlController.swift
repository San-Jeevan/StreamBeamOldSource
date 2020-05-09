//
//  LocalMediaController.swift
//  StreamBeam
//
//  Created by Jeevan Sivagnanasuntharam on 16/11/16.
//  Copyright © 2016 gressquel. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import CNPPopupController
import GoogleMobileAds



class RemoteUrlController: UIViewController, UIWebViewDelegate, CNPPopupControllerDelegate,UITableViewDelegate,UITableViewDataSource, GADInterstitialDelegate, UITextFieldDelegate  {
 
    @IBOutlet weak var popupVIew: UIView!
    @IBOutlet weak var linkCount: UIButton!
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var browserBar: UIView!
    @IBOutlet weak var webView: UIWebView!
    var albumDelegate: AlbumDelegate!
    var currentURL: String!
    var urls = [String]()
    var interstitial: GADInterstitial!

    
     var popupController:CNPPopupController = CNPPopupController()
    
    override func viewDidLayoutSubviews() {
    }
    

    @IBAction func linkBtnClicked(sender: AnyObject) {
         self.showPopupWithStyle(CNPPopupStyle.ActionSheet)
    }
    override func viewDidLoad() {
        let urlStr = "http://streambeam.gressquel.com"
        let urlReq = NSMutableURLRequest(URL: NSURL(string: urlStr)!)
        webView.loadRequest(urlReq)
        
        let isPremium = AdsService.sharedInstance.GetAdsFree();
        if isPremium == false {
            createAndLoadInterstitial();
            NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: #selector(LocalMediaController.displayAd), userInfo: nil, repeats: false)
        }
        
        urlField.delegate = self;
        super.viewDidLoad()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        urlField.resignFirstResponder()
            var urlStr = urlField.text;
            if currentURL == urlStr {return true;}
            if (urlStr!.lowercaseString.rangeOfString("http") == nil) {
                urlStr = "http://" + urlField.text!
            }
            
            let urlReq = NSMutableURLRequest(URL: NSURL(string: urlStr!)!)
            webView.loadRequest(urlReq)
            urls.removeAll()
            linkCount.setTitle(String(0) + (" link found"), forState: .Normal)
            currentURL = urlStr;
            return true
     }

    
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if(request.URL?.absoluteString == "about:blank") {
            return false;
        }
        if navigationType == UIWebViewNavigationType.LinkClicked {
                    urlField.text = request.URL?.absoluteString;
            urls.removeAll()
            linkCount.setTitle(String(0) + (" link found"), forState: .Normal)
        }

        return true;
    }

    func isVideoLink(url: String)-> Bool  {
        if(url.containsString(".mp4")) {return true}
        if(url.containsString(".m3u8")) {return true}
        if(url.containsString(".m3u")) {return true}
        if(url.containsString("googlevideo")) {return true}
        return false;
    }
    
    func appendUrl(url: String) {
        if urls.contains(url) {
            return;
        }
        urls.append(url)
        var text = " link found"
        if(urls.count > 1) {text = " links found"}
        linkCount.setTitle(String(urls.count) + (text), forState: .Normal)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        let doc = webView.stringByEvaluatingJavaScriptFromString("document.documentElement.outerHTML")
        do{
            let dataDetector = try NSDataDetector(types:NSTextCheckingType.Link.rawValue)
            let res = dataDetector.matchesInString(doc!, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0,doc!.characters.count))
            for checkingRes in res {
                if(isVideoLink((checkingRes.URL?.absoluteString)!)){
                    appendUrl((checkingRes.URL?.absoluteString)!)
                    let pulsator = Pulsator()
                    pulsator.position = CGPoint(x: browserBar.center.x, y: browserBar.frame.height/2)
                    pulsator.numPulse = 5
                    pulsator.radius = 50
                    
                    pulsator.animationDuration = 2
                    pulsator.repeatCount = 2;
                    pulsator.backgroundColor = UIColor.redColor().CGColor
                    browserBar.layer.insertSublayer(pulsator, below: linkCount.layer)
                    pulsator.start()
                }
            }
        }
        catch {
            print (error)
        }
    }
    
    @IBAction func cancelClicked(sender: AnyObject) {
        self.webView.loadHTMLString("", baseURL: nil)
        self.webView.stopLoading()
        self.webView.delegate = nil;
        self.webView.removeFromSuperview()

        albumDelegate.DisconnectWebsession();
        dismissViewControllerAnimated(false, completion: nil)
    }

    
    @IBAction func backBtnClicked(sender: AnyObject) {
        webView.goBack()
    }
    
    @IBAction func editingend(sender: AnyObject) {
        //hide autocomplete
    }
    
    
    @IBAction func editingbegan(sender: AnyObject) {
         //maybe show the autocomplete table now
        dispatch_async(dispatch_get_main_queue()) {
           self.urlField.selectAll(nil)
        }
    }

    @IBAction func editingchanged(sender: AnyObject) {
           //hver gang man taster inn
    }
    
    
    @IBAction func refreshBtn(sender: AnyObject) {
        webView.reload()
    }
    
    @IBAction func primaryAction(sender: AnyObject) {
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

        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        backgroundImage.image = UIImage(named: "bgstars")
        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill;
        self.view.insertSubview(backgroundImage, atIndex: 0);
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        self.view.insertSubview(blurEffectView, atIndex: 1);
        // add notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RemoteUrlController.videoHasStarted(_:)), name: "AVPlayerItemBecameCurrentNotification", object: nil)
        webView.backgroundColor = UIColor.clearColor()
        //webView.scalesPageToFit = true;
    }
    
    func videoHasStarted(notification: NSNotification) {
        let asset = notification.object?.asset as! AVURLAsset
        appendUrl(asset.URL.absoluteString)
        let pulsator = Pulsator()
        pulsator.position = CGPoint(x: browserBar.center.x, y: browserBar.frame.height/2)
        pulsator.numPulse = 5
        pulsator.radius = 50
        
        pulsator.animationDuration = 2
        pulsator.repeatCount = 2;
        pulsator.backgroundColor = UIColor.redColor().CGColor
        browserBar.layer.insertSublayer(pulsator, below: linkCount.layer)
        pulsator.start()

    }
    
    func popupController(controller: CNPPopupController, dismissWithButtonTitle title: NSString) {
    }
    
    func popupControllerDidPresent(controller: CNPPopupController) {
    }
    
 
    func showPopupWithStyle(popupStyle: CNPPopupStyle) {
        let customView = UIView.init(frame: popupVIew.frame)

        let backgroundImage = UIImageView(frame: popupVIew.bounds)
        backgroundImage.image = UIImage(named: "bgstars")
        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill;
        customView.insertSubview(backgroundImage, atIndex: 0);
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = popupVIew.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        customView.insertSubview(blurEffectView, atIndex: 1);

        var tableView: UITableView  =   UITableView()
        tableView = UITableView(frame: UIScreen.mainScreen().bounds, style: UITableViewStyle.Plain)
        tableView.delegate      =   self
        tableView.dataSource    =   self
        let cell = UITableViewCell();
        cell.textLabel?.textColor = UIColor.whiteColor()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorColor = UIColor.clearColor();
        tableView.backgroundColor = UIColor.clearColor();
      
        customView.addSubview(tableView)
        self.popupController = CNPPopupController(contents:[customView])
        self.popupController.theme = CNPPopupTheme.defaultTheme()
        self.popupController.theme.popupStyle = popupStyle
        self.popupController.delegate = self
        self.popupController.presentPopupControllerAnimated(true)
    }
 
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return urls.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        cell.textLabel!.text = urls [indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.backgroundColor = UIColor.clearColor();
        cell.textLabel?.textColor = UIColor.whiteColor();
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        var mimeType = "video/hls";
        if(urls[indexPath.row].containsString("mp4")) {
            mimeType = "video/mp4";
        }
        albumDelegate.CastAsset(urls[indexPath.row], mimeType: mimeType)
        self.popupController.dismissPopupControllerAnimated(false);
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
 
    
}
