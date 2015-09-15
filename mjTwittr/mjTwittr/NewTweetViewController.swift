//
//  NewTweetViewController.swift
//  mjTwittr
//
//  Created by michelle johnson on 9/13/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

@objc protocol NewTweetViewControllerDelegate {
    optional func newTweetViewController(newTweetViewController: NewTweetViewController, didCreateTweet tweet: Tweet!)
}

class NewTweetViewController: UIViewController {
    
    var wordCount: NSNumber = 140
    var tweet: Tweet?
    weak var delegate: NewTweetViewControllerDelegate?
    
    @IBOutlet weak var newTweetText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var rightSubmitTweetBarButtonItem:UIBarButtonItem = UIBarButtonItem(title: "Tweet", style: UIBarButtonItemStyle.Plain, target: self, action: "submitTweet:")
        var rightWordCountBarButtonItem:UIBarButtonItem = UIBarButtonItem(title: "\(wordCount.stringValue)", style: UIBarButtonItemStyle.Plain, target: self, action: "changeWordCount:")
        
        
        self.navigationItem.setRightBarButtonItems([rightSubmitTweetBarButtonItem,rightWordCountBarButtonItem], animated: true)
        
        var btn = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: nil)
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = btn
        self.navigationController?.navigationBar.backIndicatorImage = nil
        
        rightWordCountBarButtonItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Arial", size: 14)!], forState: UIControlState.Normal)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func submitTweet(sender: UIButton) {
        println("submitted tweet")
        TwitterClient.sharedInstance.postTweet(newTweetText.text, in_reply_to_status_id: nil, completion: { (tweet, error) -> () in
            self.tweet = tweet
            println("the new tweet \(self.tweet!)")
            self.delegate?.newTweetViewController!(self, didCreateTweet: self.tweet!)
        })
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func changeWordCount(sender: UIButton) {
        println("decrement word count")
    }
    

    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        
//        
//    }

}
