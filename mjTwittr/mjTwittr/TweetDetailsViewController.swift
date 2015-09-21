//
//  TweetDetailsViewController.swift
//  mjTwittr
//
//  Created by michelle johnson on 9/13/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {

    @IBOutlet weak var retweetedByImageView: UIImageView!
    @IBOutlet weak var retweetedByLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    
    @IBAction func favoriteTweet(sender: AnyObject) {
        
        TwitterClient.sharedInstance.favoriteTweet(tweet!.id?.stringValue, completion: { (tweets, error) -> () in
            let image = UIImage(named: "Favorite_On") as UIImage?
            sender.setImage(image, forState: UIControlState.Normal)
        })
    }
    
    @IBAction func replyToTweet(sender: AnyObject) {
        self.performSegueWithIdentifier("composeTweet", sender: self)
    }
    
    @IBAction func retweetTweet(sender: AnyObject) {
        
        TwitterClient.sharedInstance.retweetTweet(tweet!.id?.stringValue, completion: { (tweets, error) -> () in
            let image = UIImage(named: "Retweet_On") as UIImage?
            sender.setImage(image, forState: UIControlState.Normal)
        })
        
        
    }
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let retweet = tweet?.retweet as Tweet!
        if retweet != nil {
            let retweetedUser = retweet.user
            retweetedByImageView.hidden = false
            retweetedByLabel.text = tweet!.user!.screenname! + " retweeted"
            nameLabel.text = retweetedUser!.name!
            handleLabel.text = retweetedUser!.screenname!
            let url = NSURL(string: retweetedUser!.profileImgUrl!)
            avatarImageView.setImageWithURL(url)
            tweetLabel.text = retweet.text!
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            formatter.timeZone = NSTimeZone(name: "EST")
            let tsString = retweet.createdAtString!
            let timestamp = formatter.dateFromString(tsString)
            
            formatter.dateFormat = "MM/dd/yy, hh:mm a"
            formatter.timeZone = NSTimeZone(name: "EST")
            let ts = formatter.stringFromDate(timestamp!)
            
            timestampLabel.text = ts
            let rcount = retweet.retweets!
            let fcount = retweet.favorites!
            retweetCount.text = rcount.stringValue
            favoriteCount.text = fcount.stringValue

        } else {
            retweetedByLabel.hidden = true
            retweetedByImageView.hidden = true
            
            nameLabel.text = tweet!.user?.name!
            handleLabel.text = tweet!.user?.screenname!
            let url = NSURL(string: tweet!.user!.profileImgUrl!)
            avatarImageView.setImageWithURL(url)
            tweetLabel.text = tweet!.text!
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            formatter.timeZone = NSTimeZone(name: "EST")
            let tsString = tweet!.createdAtString!
            let timestamp = formatter.dateFromString(tsString)
            
            formatter.dateFormat = "MM/dd/yy, hh:mm a"
            formatter.timeZone = NSTimeZone(name: "EST")
            let ts = formatter.stringFromDate(timestamp!)
            
            timestampLabel.text = ts
            let rcount = tweet!.retweets!
            let fcount = tweet!.favorites!
            retweetCount.text = rcount.stringValue
            favoriteCount.text = fcount.stringValue
            
        }
        print("here \(tweet?.retweet)")
        
        
        avatarImageView.layer.cornerRadius = 3
        avatarImageView.clipsToBounds = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
