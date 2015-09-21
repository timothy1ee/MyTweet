//
//  StackViewController.swift
//  mjTwittr
//
//  Created by michelle johnson on 9/20/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var menuView: UIView!
  
    @IBOutlet weak var contentView: UIView!
    
    var originalLeftMargin: CGFloat!
    
    var menuViewController: UIViewController! {
        didSet(oldMenuViewController) {
            view.layoutIfNeeded()
            
            if oldMenuViewController != nil {
                oldMenuViewController.willMoveToParentViewController(nil)
                oldMenuViewController.view.removeFromSuperview()
                oldMenuViewController.didMoveToParentViewController(nil)
            }
            
            menuView.addSubview(menuViewController.view)
        }
    }
    
    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()
            
            if oldContentViewController != nil {
                oldContentViewController.willMoveToParentViewController(nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMoveToParentViewController(nil)
            }
            
            contentViewController.willMoveToParentViewController(self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMoveToParentViewController(self)
            
            UIView.animateWithDuration(0.3) { () -> Void in
                self.leftMarginConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPanGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            originalLeftMargin = leftMarginConstraint.constant
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            leftMarginConstraint.constant = originalLeftMargin + translation.x
        } else if sender.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(0.5, animations: {
                if velocity.x > 0 {
                    self.leftMarginConstraint.constant = self.view.frame.size.width - 100
                    
                } else {
                    self.leftMarginConstraint.constant = 0
                }
            })
            
            
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
