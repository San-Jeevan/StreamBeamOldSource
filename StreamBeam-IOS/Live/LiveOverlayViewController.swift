
import UIKit
import SocketIOClientSwift
import IHKeyboardAvoiding
import SwiftMoment

protocol SocketIODelegate {
    func initSocketIO(session: Session)
    func DisconnectSocketIO()
}

class LiveOverlayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SocketIODelegate {
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!

    @IBOutlet weak var audioPopup: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var torchBtn: UIButton!
    @IBOutlet weak var micBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var eventsTable: UITableView!
    
    var cameraOn = false;
    var micOn = false
    var torchOn = false
    var moreOn = false
    var events = [Event]()
    var ijkPlayerDelegate: IJKplayerDeleggate!
    var reachability: Reachability?
    var session: Session!
    
    var socket: SocketIOClient!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(LiveOverlayViewController.screenAwake), name:
            UIApplicationWillEnterForegroundNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(LiveOverlayViewController.didEnterBackground), name:
            UIApplicationDidEnterBackgroundNotification, object: nil)


    
        torchBtn.setImage(UIImage(named: "torch")?.inverseImage(false), forState: .Highlighted)
        torchBtn.setImage(UIImage(named: "torch")?.inverseImage(false), forState: .Selected)
        cameraBtn.setImage(UIImage(named: "camera")?.inverseImage(false), forState: .Highlighted)
        cameraBtn.setImage(UIImage(named: "camera")?.inverseImage(false), forState: .Selected)
        micBtn.setImage(UIImage(named: "microphone")?.inverseImage(false), forState: .Highlighted)
        micBtn.setImage(UIImage(named: "microphone")?.inverseImage(false), forState: .Selected)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LiveOverlayViewController.handleTap(_:)))
        view.addGestureRecognizer(tap)
           }
    
    
    func initSessionData(session: Session) {
    //read mic,cam,torch
    //add pulse
        dispatch_async(dispatch_get_main_queue()) {
            self.events.removeAll();
            for pulselog in session.Pulselog as [PulseLog] {
                let text = String(format: NSLocalizedString("liveoverlay.Noisedetected", comment: ""), pulselog.dB);
                let pulse = Event(eventText: text, eventDt: pulselog.DateAdded )
                self.events.append(pulse)
            }
                self.eventsTable.reloadData()
            
            //babystate
            if(session.IsBabyAsleep) {
                self.statusImageView.image = UIImage(named: "babysleep");
                self.statusLabel.text = NSLocalizedString("liveoverlay.Babysleep", comment: "")
            }
            else {
                self.statusImageView.image = UIImage(named: "babyawake");
                self.statusLabel.text = NSLocalizedString("liveoverlay.Babyawake", comment: "")
            }
        }

    }
    
    
    func initSocketIO(session: Session) {
        initSessionData(session);
        self.session = session;
        //Start socket.io
        self.socket = SocketIOClient(socketURL: NSURL(string: session.Wsurl)!, config: [.Log(false), .ForcePolling(true)])
        socket!.on("connect") {[weak self] data, ack in
            //iniate listeners
            do {
                self!.reachability = try Reachability.reachabilityForInternetConnection()
            } catch {
                print("Unable to create Reachability")
                return
            }
            
            NSNotificationCenter.defaultCenter().addObserver(self!, selector: #selector(LiveOverlayViewController.reachabilityChanged),name: ReachabilityChangedNotification,object: self!.reachability)
            do{
                try self!.reachability?.startNotifier()
            }catch{
                print("could not start reachability notifier")
            }
            let defaults = NSUserDefaults.standardUserDefaults();
            let apnid = defaults.stringForKey("apnid");

            self!.socket!.emit("joinRoom", (self?.session.Seckey)!, false, apnid!)
        }

    //socket.IO Events
    socket.on("pulse") {[weak self] data, ack in
    dispatch_async(dispatch_get_main_queue()) {
    let text = String(format: NSLocalizedString("liveoverlay.Noisedetected", comment: ""),data[0] as! Float);
    let pulse = Event(eventText: text)
    self!.events.append(pulse)
    self!.eventsTable.reloadData()
 
        if(session.IsBabyAsleep) {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate));
        }
    }
    }
        
        
    socket.on("broadcasterConnected") {[weak self] data, ack in
    self!.statusImageView.image = UIImage(named: "babyawake")
    self!.statusLabel.text = NSLocalizedString("liveoverlay.Babyawake", comment: "")
    }
    
    socket.on("broadcasterDisconnected") {[weak self] data, ack in
    if(self!.cameraOn) {self!.cameraClicked("manual")}
    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate));
    self!.statusImageView.image = UIImage(named: "warningicon")
    self!.statusLabel.text = NSLocalizedString("liveoverlay.Babydisconnect", comment: "")
    }
        
        socket.on("alertBabyAwake") {[weak self] data, ack in
            self!.statusImageView.image = UIImage(named: "babyawake");
            self!.statusLabel.text = NSLocalizedString("liveoverlay.Babyawake", comment: "")
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        
        socket.on("alertBabySleep") {[weak self] data, ack in
            self!.statusImageView.image = UIImage(named: "babysleep");
            self!.statusLabel.text = NSLocalizedString("liveoverlay.Babysleep", comment: "")
        }
        
    
        
        self.socket.connect();
    }
   
    func DisconnectSocketIO() {
        if(socket != nil && socket!.status == SocketIOClientStatus.Connected) {
            socket!.emit("stopCam", self.session.Seckey);
            socket!.emit("stopMic", self.session.Seckey);
            socket!.disconnect();
        }
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        reachability?.stopNotifier()
        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: ReachabilityChangedNotification,
                                                            object: reachability);
        
        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: UIApplicationWillEnterForegroundNotification,
                                                            object: nil);
        
        
        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: UIApplicationDidEnterBackgroundNotification,
                                                            object: nil);

        super.viewWillDisappear(animated)
    }
    
    func handleTap(gesture: UITapGestureRecognizer) {
        guard gesture.state == .Ended else {
            return
        }
    }
    
    
    func screenAwake() {
        NSLog("FOREGROUND");
        //only reload data if session already exists
        if(session != nil) {
            RestManager.sharedInstance.getRoom(session.Seckey, onCompletion: { (JSON) in
                let success = JSON["success"].bool;
                if(success == true) {
                    if(JSON["data"] != nil) {
                        self.session = Session(data: JSON["data"]);
                        self.initSessionData(self.session);
                    }
                }
            })
        }
    }
    
    func didEnterBackground() {
        ijkPlayerDelegate.killPlayer();
    }
    
    @IBAction func cameraClicked(sender: AnyObject) {
        if(!cameraOn) {
            self.view.makeToast(message: NSLocalizedString("liveoverlay.ToastStartingVideo",comment: ""), duration: 3.0, position: "center", title: "")
            
            ijkPlayerDelegate.startPlayer();
            mainView.hidden = true;
            socket.emit("startCam", self.session.Seckey);
            cameraBtn.selected = true;
            cameraOn = true;
            torchBtn.enabled = true;
            
            //disable mic
            micBtn.selected = false;
            micOn = false;
            audioPopup.hidden = true;
        }
        else {
            mainView.hidden = false;
            socket.emit("stopCam", self.session.Seckey);
            ijkPlayerDelegate.stopPlayer();
            cameraBtn.selected = false;
            cameraOn = false;
            
            //toggle disable torch
            torchBtn.selected = false;
            torchOn = false;
            torchBtn.enabled = false;
        }
    }
    
   
    @IBAction func micClicked(sender: AnyObject) {
        if(!micOn) {
            mainView.hidden = false;
            socket.emit("startMic", self.session.Seckey);
            micBtn.selected = true;
            micOn = true;
            audioPopup.hidden = false;
            
            //toggle off cam
            cameraBtn.selected = false;
            cameraOn = false;
            
            //toggle and disable torch
            torchBtn.selected = false;
            torchOn = false;
            torchBtn.enabled = false;
        }
        else {
            socket.emit("stopMic", self.session.Seckey);
            micBtn.selected = false;
            micOn = false;
            audioPopup.hidden = true;
        }
    }
   
    
    @IBAction func torchClicked(sender: AnyObject) {
        if(!torchOn) {
            socket.emit("startTorch", self.session.Seckey);
            torchBtn.selected = true;
            torchOn = true;
        }
        else {
            socket.emit("stopTorch", self.session.Seckey);
            torchBtn.selected = false;
            torchOn = false;
        }
    }
    

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //last 5 elements, so we dont have rendering cpu issues.
        if(events.count > 5) {
        return 5;
        }
        else {
         return events.count;
        }
  
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:EventsCell = self.eventsTable.dequeueReusableCellWithIdentifier("cell")! as! EventsCell
        let momentdt = moment(events[events.count-1-indexPath.row].EventDt);
        cell.eventTime.text = momentdt.format("HH:mm")
        cell.eventText.text = events[events.count-1-indexPath.row].EventText;
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
     
    //NETWORK EVENTS
    func reachabilityChanged(note: NSNotification) {
        let reachability = note.object as! Reachability
        if reachability.isReachable() {
            socket.connect();
            
            //trigger refresh of session data
            screenAwake();
            if reachability.isReachableViaWiFi() {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        } else {
            print("Network not reachable")
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate));
            socket.disconnect();
            statusImageView.image = UIImage(named: "warningicon");
            statusLabel.text = NSLocalizedString("liveoverlay.Disconnect", comment: "")
        }
    }
}






