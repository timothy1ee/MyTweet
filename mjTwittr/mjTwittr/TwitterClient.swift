//
//  TwitterClient.swift
//  mjTwittr
//
//  Created by michelle johnson on 9/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

let twitterConsumerKey = "DPiKVfwUXcdsBKLwI3EUpHPiQ"
let twitterConsumerSecret = "PtBo2uemx3IbZzVzl4TSWQzwtwFykQti9p79yJGQ89flekCuAs"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func favoriteTweet(id: String?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        print("LOOK HERE: \(id!)")
        TwitterClient.sharedInstance.POST("1.1/favorites/create.json?id=\(id!)", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("failed at favoriting")
            completion(tweet: nil, error: error)
        })
    }
    
    func retweetTweet(id: String?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        print("LOOK HERE: \(id!)")
        TwitterClient.sharedInstance.POST("1.1/statuses/retweet/\(id!).json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("failed at favoriting")
                completion(tweet: nil, error: error)
        })
    }
    
    func postTweet(status: String?, in_reply_to_status_id: String?, completion: (tweet: Tweet?, error: NSError?) ->()) {
        var js = status!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var urlString = "1.1/statuses/update.json?status=\(js!)"
        if in_reply_to_status_id != nil {
             urlString = urlString + "&in_reply_to_status_id=\(in_reply_to_status_id)"
        }
        urlString = urlString + "&display_coordinates=false"
        println("print url: \(urlString)")
//        
        TwitterClient.sharedInstance.POST(urlString, parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            var tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("error posting tweet")
            completion(tweet: nil, error: error)
        })
    }
    
    func homeTimelineWithCompletion(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) ->()) {
        TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            //println("user \(response)")
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error getting home timeline")
                completion(tweets: nil, error: error)
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        //Fetch my request token and redirect to authorization
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            println("Got the request token")
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
        }) { (error: NSError!) -> Void in
            println("Failed to get request token")
            self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            println("Got the access token")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                //println("user \(response)")
                
                var user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                self.loginCompletion?(user: user, error: nil)
                println("user: \(user.name)")
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println("error getting current user")
                    self.loginCompletion?(user: nil, error: error)
            })
            
        }) { (error: NSError!) -> Void in
            println("failed to receive access token")
            self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func onRefresh(lastID: NSNumber, params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) ->()) {
        println("the url: https://api.twitter.com/1.1/statuses/home_timeline.json?since_id=\(lastID.stringValue)")
        TwitterClient.sharedInstance.GET("https://api.twitter.com/1.1/statuses/home_timeline.json?since_id=\(lastID.stringValue)", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error getting next 20 tweets")
                completion(tweets: nil, error: error)
        })
    }
}
