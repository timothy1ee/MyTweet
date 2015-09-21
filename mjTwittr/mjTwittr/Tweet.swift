//
//  Tweet.swift
//  mjTwittr
//
//  Created by michelle johnson on 9/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var timeElapse: String?
    var retweets: NSNumber?
    var favorites: NSNumber?
    var id: NSNumber?
    var retweet: Tweet?
    var favorited: Bool?
    var retweeted: Bool?
    
    init(dictionary: NSDictionary) {
        //TODO: account for retweeted tweets
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        favorites = dictionary["favorite_count"] as? NSNumber
        retweets = dictionary["retweet_count"] as? NSNumber
        id = dictionary["id"] as? NSNumber
        favorited = dictionary["favorited"] as? Bool
        retweeted = dictionary["retweeted"] as? Bool
        createdAtString = dictionary["created_at"] as? String
        
        if dictionary["retweeted_status"] != nil {
            retweet = Tweet(dictionary: dictionary["retweeted_status"] as! NSDictionary)
            print("RETWEETED STATUS: \(retweet)")
        }
        
        print("dictionary: \(dictionary as NSDictionary)")
        
        let formatter = NSDateFormatter()
        
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        formatter.timeZone = NSTimeZone(name: "EST")
        createdAt = formatter.dateFromString(createdAtString!)
        timeElapse = createdAt?.timeAgoSimple()
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
    
}
