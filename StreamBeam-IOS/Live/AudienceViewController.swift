
import UIKit


protocol IJKplayerDeleggate {
    func stopPlayer()
    func startPlayer()
    func killPlayer()
}

class AudienceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, IJKplayerDeleggate {

    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var inputOverlay: UIVisualEffectView!
    @IBOutlet weak var secCodeField: TextField!
  
    @IBOutlet weak var WIFIchosefromlabel: UILabel!
    

    var wifiDevices = [Session]()
  
    var overlayController: LiveOverlayViewController!
     var seckey = 123456;
    var cameraTimer : NSTimer!
    var cameraisOn : Bool = false;
    var socketIODelegate: SocketIODelegate!
    var session: Session!

    @IBOutlet weak var wifitable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation");
        wifiDevices.removeAll();
        RestManager.sharedInstance.getNearby({ (JSON) in
            var message = JSON["message"].string;
            let success = JSON["success"].bool;
            dispatch_async(dispatch_get_main_queue()) {
            if(success == true) {
                if(JSON["data"] != nil) {
                        self.WIFIchosefromlabel.hidden=false;
                        let session = Session(data: JSON["data"]);
                        self.wifiDevices.append(session);
                        self.wifitable.reloadData()
                    }
              
            }
            else {
                if(message == "NEARBY_NOT_FOUND") {
                    self.WIFIchosefromlabel.hidden=true;
                }
            }
        }
        })
        
           }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        secCodeField.resignFirstResponder()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "overlay" {
            overlayController = segue.destinationViewController as! LiveOverlayViewController
           
            overlayController.ijkPlayerDelegate = self;
            socketIODelegate = overlayController;
        }
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        socketIODelegate.DisconnectSocketIO();

        NSNotificationCenter.defaultCenter().removeObserver(self)
        super.viewWillDisappear(animated)
    }
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        if(self.cameraisOn) {
        let refreshAlert = UIAlertController(title: NSLocalizedString("general.Quit", comment: ""), message: NSLocalizedString("audience.Quitmessage", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: NSLocalizedString("audience.Goback", comment: ""), style: .Default, handler: { (action: UIAlertAction!) in
          //donothing
        }))
        
        refreshAlert.addAction(UIAlertAction(title: NSLocalizedString("audience.QuitSession", comment: ""), style: .Cancel, handler: { (action: UIAlertAction!) in
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
            return;
        }
      presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        getRoom(wifiDevices[indexPath.row].Seckey);
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wifiDevices.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.wifitable.dequeueReusableCellWithIdentifier("wificell", forIndexPath: indexPath) as! WifiCell;
        cell.WifiName.text = wifiDevices[indexPath.row].DeviceInfo + " (" + String(wifiDevices[indexPath.row].Seckey)  + ")" ;
        return cell;
    }
    
    //custom delegate
    func stopPlayer() {
        cameraisOn = false;

    }
    
    
    func killPlayer() {
        cameraisOn = false;
        player?.shutdown()
        player?.view.removeFromSuperview();
        player = nil;
    }

    func startPlayer() {
        cameraisOn = true;
        if(player == nil) {
            startRtmp();
        }
    }
    
    func handleTimer(timer:NSTimer) {
    }
    
    func startRtmp()  {
        let urlString = self.session.Rmpturl + String(self.session.Seckey);
        let options = IJKFFOptions();
        options.setFormatOptionValue("nobuffer", forKey: "fflags");
        options.setPlayerOptionValue("0", forKey: "packet-buffering")
        options.setPlayerOptionIntValue(0, forKey: "packet-buffering")
        player = IJKFFMoviePlayerController(contentURLString: urlString, withOptions: options)  //contetURLStrint helps you making a complete stream at rooms with special characters.
        player.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        player.scalingMode = IJKMPMovieScalingMode.AspectFill;
        player.view.frame = previewView.bounds
        previewView.addSubview(player.view)
        player.prepareToPlay();
        player.play()


        NSNotificationCenter.defaultCenter().addObserverForName(IJKMPMoviePlayerLoadStateDidChangeNotification, object: player, queue: NSOperationQueue.mainQueue(), usingBlock: { [weak self] notification in
            guard let this = self else {
                return
            }
            let state = this.player.loadState
            switch state {case IJKMPMovieLoadState.Playable:
                this.statusLabel.text = "Playable"
            case IJKMPMovieLoadState.PlaythroughOK:
                this.statusLabel.text = "Playing"
            case IJKMPMovieLoadState.Stalled:
                this.statusLabel.text = "Buffering"
            default:
                this.statusLabel.text = "Playing"
            }
            })
    }
    

    func getRoom(code:Int){
        RestManager.sharedInstance.getRoom(code, onCompletion: { (JSON) in
            var message = JSON["message"].string;
            let success = JSON["success"].bool;
            
            if(success == true) {
                if(JSON["data"] != nil) {
                    self.session = Session(data: JSON["data"]);
                    dispatch_async(dispatch_get_main_queue()) {
                        self.startRtmp();
                        self.socketIODelegate.initSocketIO(self.session)
                        UIView.animateWithDuration(0.2, animations: {
                            self.inputOverlay.alpha = 0
                            }, completion: { finished in
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.inputOverlay.hidden = true;
                                }
                        })
                    }
                }
            }
            else {
                if(message == "MALFORMED_REQUEST") {
                    message = NSLocalizedString("server.MALFORMED_REQUEST", comment: "")
                }
                if(message == "SESSION_NOT_FOUND") {
                    message = NSLocalizedString("server.SESSION_NOT_FOUND", comment: "")
                }
                let alert = UIAlertController(title: NSLocalizedString("general.Error", comment: ""), message: message, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
        })
    }
    
    
    @IBAction func blabla(sender: AnyObject) {
        let code = secCodeField.text;
        if(code?.characters.count  == 6){
            seckey = Int(code!)!;
            secCodeField.resignFirstResponder();
            getRoom(Int(code!)!);
   
       }
        if(code?.characters.count > 6){
            secCodeField.deleteBackward();
        }
    }
  
    override func shouldAutorotate() -> Bool {
        if(self.inputOverlay.hidden) {
        return true;
        }
        return false;
    }
    
  
    
    
}
