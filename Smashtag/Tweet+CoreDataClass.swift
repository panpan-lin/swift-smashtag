//
//  Tweet+CoreDataClass.swift
//  Smashtag
//
//  Created by Panpan Lin on 07/11/2016.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation
import CoreData
import Twitter

public class Tweet: NSManagedObject {
    class func tweetWithTwitterInfo(twitterInfo: Twitter.Tweet, inManagedObjectContext context: NSManagedObjectContext) -> Tweet? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tweet")
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.id)

        /* The below two lines substitutes the following
         do {
            let queryResults = try context.fetch(request)
            if let tweet = queryResults.first as? Tweet {
                return tweet
            }
         } catch let error {
            // ignore
         }
         */
        
        if let tweet = (try? context.fetch(request))?.first as? Tweet {
            return tweet    // if the tweet is found
        } else if let tweet = NSEntityDescription.insertNewObject(forEntityName: "Tweet", into: context) as? Tweet {
            // if tweet not found
            tweet.unique = twitterInfo.id
            tweet.text = twitterInfo.text
            tweet.posted = twitterInfo.created as NSDate?
            tweet.tweeter = TwitterUser.twitterUserWithTwitterInfo(twitterInfo: twitterInfo.user, inManagedObjectContext: context)
            return tweet
        }
        
        return nil
    }
}
