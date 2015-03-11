//
//  FirstViewController.swift
//  WebRegistration
//
//  Created by Guocheng Xie on 2/13/15.
//  Copyright (c) 2015 Guocheng Xie. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var screenEdgeRecognizer: UIPanGestureRecognizer!
    
    @IBOutlet weak var previewScheduleHint: UILabel!
    var animator:UIDynamicAnimator!
    var container:UICollisionBehavior!
    var snap:UISnapBehavior!
    var dynamicItem:UIDynamicItemBehavior!
    var gravity:UIGravityBehavior!
    var panGestureRecognizer:UIPanGestureRecognizer!

    // lazy create shceudle view controller
    lazy var scheduleVC: UINavigationController! = {
        //var vc = self.storyboard?.instantiateViewControllerWithIdentifier("ScheduleNavigationController") as! UINavigationController
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("ScheduleNavigationController") as! UINavigationController
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.bounds //view is self.view in a UIViewController
            vc.view.addSubview(blurEffectView)
            vc.view.sendSubviewToBack(blurEffectView)
        }

        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previewScheduleHint.hidden = false;
        setup()
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let isEnableSchedulePreview: Bool = dict?.objectForKey("EnableSchedulePreview") as! Bool
        if !isEnableSchedulePreview {
            previewScheduleHint.hidden = true;
        }
        
        

    }
    
    
    // setup schedule view
    func setup(){
        /* Create the Pinch Gesture Recognizer */
        screenEdgeRecognizer =  UIPanGestureRecognizer(target: self,
            action: "handleScreenEdgePan:")
        
        view.addGestureRecognizer(screenEdgeRecognizer)        
        scheduleVC.view.frame = CGRectMake(-scheduleVC.view.frame.size.width, 0, scheduleVC.view.frame.width, scheduleVC.view.frame.height)
        view.addSubview(scheduleVC.view)
        setupScheduleGesture()
    
    }
    
    func setupScheduleGesture () {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        panGestureRecognizer.cancelsTouchesInView = false
        
        scheduleVC.view.addGestureRecognizer(panGestureRecognizer)
        animator = UIDynamicAnimator(referenceView: self.view!)
        dynamicItem = UIDynamicItemBehavior(items: [scheduleVC.view])
        dynamicItem.allowsRotation = false
        dynamicItem.elasticity = 0
        
        gravity = UIGravityBehavior(items: [scheduleVC.view])
        gravity.gravityDirection = CGVectorMake(0, 0)
        
        container = UICollisionBehavior(items: [scheduleVC.view])
        
        configureContainer()
        
        animator.addBehavior(gravity)
        animator.addBehavior(dynamicItem)
        animator.addBehavior(container)
        
    }
    
    func configureContainer (){
        let boundaryWidth = UIScreen.mainScreen().bounds.size.width
        container.addBoundaryWithIdentifier("left", fromPoint: CGPointMake(-view.frame.size.width-2, 0), toPoint: CGPointMake(-view.frame.size.width-2,
            view.frame.size.height))
        let boundaryHeight = UIScreen.mainScreen().bounds.size.height
        container.addBoundaryWithIdentifier("right", fromPoint: CGPointMake(view.frame.size.width, 0), toPoint: CGPointMake(view.frame.size.width, boundaryHeight))
        
    }
    
    func handleScreenEdgePan(sender: UIScreenEdgePanGestureRecognizer){
        
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let isEnableSchedulePreview: Bool = dict?.objectForKey("EnableSchedulePreview") as! Bool

        if isEnableSchedulePreview && sender.state == .Ended{
            if sender.velocityInView(self.view).x > 10 {
                snapToRight()
                previewScheduleHint.hidden = true;
            }
        }
        
    }
    
    func handlePan (pan:UIPanGestureRecognizer){
        let velocity = pan.velocityInView(view).x
        
        var movement = scheduleVC.view.frame
        movement.origin.x = movement.origin.x + (velocity * 0.05)
        movement.origin.y = 0
        
        if pan.state == .Ended {
            panGestureEnded()
        }else if pan.state == .Began {
            snapToRight()
        }else{
            animator.removeBehavior(snap)
            snap = UISnapBehavior(item: scheduleVC.view, snapToPoint: CGPointMake(CGRectGetMidX(movement), CGRectGetMidY(movement)))
            animator.addBehavior(snap)
        }
        
    }
    
    func panGestureEnded () {
        animator.removeBehavior(snap)
        
        let velocity = dynamicItem.linearVelocityForItem(scheduleVC.view)
        
        if fabsf(Float(velocity.x)) > 250 {
            if velocity.x < 0 {
                snapToLeft()
            }else{
                snapToRight()
            }
        }else{
                if scheduleVC.view.frame.origin.x > -view.bounds.size.width / 2 {
                    snapToRight()
                }else{
                    snapToLeft()
                }
        }
        
    }
    
    func snapToRight() {
        NSNotificationCenter.defaultCenter().postNotificationName("UpdateDataInScheduleView", object: nil)
        gravity.gravityDirection = CGVectorMake(2.5,0)
    }
    
    func snapToLeft(){
        gravity.gravityDirection = CGVectorMake(-2.5,0)
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login(sender: AnyObject) {
        //TODO: authetication
        
        self.performSegueWithIdentifier("loginSegue", sender: self)
    }

}

