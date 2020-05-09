//
//  AudienceSearchViewController.swift
//  Live
//
//  Created by Jeevan Sivagnanasuntharam on 08/08/16.
//  Copyright © 2016 gressquel. All rights reserved.
//
import UIKit
import SocketIOClientSwift
import IHKeyboardAvoiding

class AudienceSearchViewController: UIViewController {
   

    @IBOutlet weak var joinBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func button(sender: AnyObject) {
        let vc = R.storyboard.main.audience()!
        //        vc.room = room
         self.showViewController(vc as UIViewController, sender: vc)
        }
}
