//
//  TweetCell.swift
//  mjTwittr
//
//  Created by michelle johnson on 9/13/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

   
    @IBOutlet weak var retweetedByLabel: UILabel!
    @IBOutlet weak var retweetedByImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    
    @IBAction func retweetTweet(sender: AnyObject) {
        TwitterClient.sharedInstance.retweetTweet(self.tweet!.id?.stringValue, completion: { (tweet, error) -> () in
            var image = UIImage(named: "Retweet_On") as UIImage?
            sender.setImage(image, forState: UIControlState.Normal)
        })
    }
    
    @IBAction func favoriteTweet(sender: AnyObject) {
        TwitterClient.sharedInstance.favoriteTweet(self.tweet!.id?.stringValue, completion: { (tweet, error) -> () in
            var image = UIImage(named: "Favorite_On") as UIImage?
            sender.setImage(image, forState: UIControlState.Normal)
        })
    }
    
    
    var tweet: Tweet! {
        didSet {
            if tweet.retweet != nil {
                var retweet = tweet.retweet!
                var url = NSURL(string: retweet.user!.profileImgUrl!)
                avatarImageView.setImageWithURL(url)
                nameLabel.text = retweet.user?.name
                handleLabel.text = "@" + retweet.user!.screenname!
                timestampLabel.text = retweet.timeElapse
                tweetLabel.text = retweet.text
                retweetCountLabel.text = retweet.retweets?.stringValue
                favoriteCountLabel.text = retweet.favorites?.stringValue
                retweetedByImageView.hidden = false
                retweetedByLabel.hidden = false
                retweetedByLabel.text = tweet!.user!.screenname! + " retweeted"
                if retweet.favorited == true {
                    var image = UIImage(named:"Favorite_On")!
                    favoriteImageView = UIImageView(image: image)
                }
                if retweet.retweeted == true {
                    var image = UIImage(named:"Retweet_On")!
                    retweetImageView = UIImageView(image: image)
                }
            } else {
                var url = NSURL(string: tweet.user!.profileImgUrl!)
                avatarImageView.setImageWithURL(url)
                nameLabel.text = tweet.user?.name
                handleLabel.text = "@" + tweet.user!.screenname!
                timestampLabel.text = tweet.timeElapse
                tweetLabel.text = tweet.text
                retweetCountLabel.text = tweet.retweets?.stringValue
                favoriteCountLabel.text = tweet.favorites?.stringValue
                retweetedByImageView.hidden = true
                retweetedByLabel.hidden = true
                if tweet.favorited == true {
                    var image = UIImage(named:"Favorite_On")!
                    favoriteImageView = UIImageView(image: image)
                }
                if tweet.retweeted == true {
                    var image = UIImage(named:"Retweet_On")!
                    retweetImageView = UIImageView(image: image)
                }
            }
            
            
            
        }
    }
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        avatarImageView.layer.cornerRadius = 3
        avatarImageView.clipsToBounds = true
        
        handleLabel.preferredMaxLayoutWidth = handleLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        handleLabel.preferredMaxLayoutWidth = handleLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
