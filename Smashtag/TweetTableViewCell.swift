//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Panpan Lin on 03/11/2016.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        // load new information from our tweet (if any)
        if let tweet = self.tweet {
            tweetTextLabel?.text = tweet.text
            if tweetTextLabel?.text != nil {
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📷"
                }
            }
        }
        
        tweetScreenNameLabel?.text = "\(tweet?.user)"    // tweet.user.description
        
        if let profileImageURL = tweet?.user.profileImageURL {
            if let imageData = NSData(contentsOf: profileImageURL) { // block main thread!
                tweetProfileImageView?.image = UIImage(data: imageData as Data)
            }
        }
        
        let formatter = DateFormatter()
        
        if NSDate().timeIntervalSince((tweet?.created)!) > 24*60*60 {
            formatter.dateStyle = DateFormatter.Style.short
        } else {
            formatter.timeStyle = DateFormatter.Style.short
        }
        tweetCreatedLabel?.text = formatter.string(from: (tweet?.created)!)
    }
}
