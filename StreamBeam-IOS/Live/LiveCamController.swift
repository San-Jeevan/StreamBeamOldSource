//
//  LocalMediaController.swift
//  StreamBeam
//
//  Created by Jeevan Sivagnanasuntharam on 16/11/16.
//  Copyright © 2016 gressquel. All rights reserved.
//

import UIKit
import lf
import AVFoundation
import AVKit

class LiveCamController: UIViewController  {
    
    @IBOutlet weak var castBtn: UIButton!
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var castBlurView: UIVisualEffectView!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var navBar: UINavigationBar!
    var httpStream: HTTPStream!
    var httpService: HTTPService!
    
    var albumDelegate: AlbumDelegate!
    
    
    override func viewDidLoad() {
        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        backgroundImage.image = UIImage(named: "bgstars")
        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill;
        self.view.insertSubview(backgroundImage, atIndex: 0);
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        self.view.insertSubview(blurEffectView, atIndex: 1);
        navBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navBar.shadowImage = UIImage()
        navBar.translucent = true
        
        let button = UIButton(type: UIButtonType.Custom) as UIButton
        button.setImage(UIImage(named: "exit"), forState: UIControlState.Normal)
        button.addTarget(self, action:#selector(LiveCamController.cancelClicked), forControlEvents: UIControlEvents.TouchUpInside)
        button.frame=CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navItem.leftBarButtonItem = barButton
        //self.navItem.setLeftBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(self.cancelClicked)), animated: true)
        initiateLiveStream();
        super.viewDidLoad()
    }
    
    
    
    @IBAction func castBtn(sender: AnyObject) {
        let ip = getIFAddresses().last!.ip
        albumDelegate.CastAsset("http://"+ip+":8082/hello/playlist.m3u8", mimeType: "video/x-mpegURL")
        //albumDelegate.CastAsset("http://rt.ashttp14.visionip.tv/live/rt-doc-live-HD/playlist.m3u8", mimeType: "application/x-mpegURL")
        print("http://"+ip+":8082/hello/playlist.m3u8");
        redView.hidden = false;
        castBtn.setTitle("Casting...", forState: UIControlState.Normal)
    }
    func initiateLiveStream() {
        httpStream = HTTPStream()
        httpStream.attachCamera(DeviceUtil.deviceWithPosition(AVCaptureDevicePosition.Back))
        httpStream.attachAudio(AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio))
        httpStream.publish("hello")
        let lfView:LFView = LFView(frame: view.bounds)
        lfView.attachStream(httpStream)
        httpService = HTTPService(domain: "", type: "_http._tcp", name: "lf", port: 8082)
        httpService.startRunning()
        httpService.addHTTPStream(httpStream)


       // view.insertSubview(lfView, atIndex: 1)
        
    }
    
    func webServerStarted(success: Bool, message: String){
        print(success);
        print(message);
    }
    
    func cancelClicked(){
        albumDelegate.DisconnectWebsession();
        httpService.removeHTTPStream(httpStream)
        httpService.stopRunning();
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    
    struct NetInfo {
        let ip: String
        let netmask: String
    }
    
    // Get the local ip addresses used by this node
    func getIFAddresses() -> [NetInfo] {
        var addresses = [NetInfo]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
        if getifaddrs(&ifaddr) == 0 {
            
            // For each interface ...
            for (var ptr = ifaddr; ptr != nil; ptr = ptr.memory.ifa_next) {
                let flags = Int32(ptr.memory.ifa_flags)
                var addr = ptr.memory.ifa_addr.memory
                
                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        
                        // Convert interface address to a human readable string:
                        var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String.fromCString(hostname) {
                                
                                var net = ptr.memory.ifa_netmask.memory
                                var netmaskName = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
                                getnameinfo(&net, socklen_t(net.sa_len), &netmaskName, socklen_t(netmaskName.count),
                                            nil, socklen_t(0), NI_NUMERICHOST) == 0
                                if let netmask = String.fromCString(netmaskName) {
                                    addresses.append(NetInfo(ip: address, netmask: netmask))
                                }
                            }
                        }
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return addresses
    }

    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    

    
    
    
}
