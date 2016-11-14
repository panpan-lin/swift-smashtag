//
//  TweetTableTableViewController.swift
//  Smashtag
//
//  Created by Panpan Lin on 03/11/2016.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class TweetTableTableViewController: UITableViewController, UITextFieldDelegate {
    
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    var tweets = [Array<Twitter.Tweet>]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var searchText: String? {
        didSet {
            tweets.removeAll()
            searchForTweets()
            title = searchText
        }
    }
    
    private var twitterRequest: Twitter.Request? {
        if let query = searchText , !query.isEmpty {
            return Twitter.Request(search: query + "-filter:retweets", count: 100)
        }
        return nil
    }
    
    private var lastTwitterRequest: Twitter.Request?
    
    private func searchForTweets() {
        if let request = twitterRequest {
            lastTwitterRequest = request
            request.fetchTweets{ [weak weakSelf = self] newTweets in
                DispatchQueue.main.async {
                    if request == weakSelf?.lastTwitterRequest {
                        if !(newTweets.isEmpty) {
                             weakSelf?.tweets.insert(newTweets, at: 0)
                             weakSelf?.updateDataBase(newTweets: newTweets)
                        }
                    }
                }
            }
        }
    }
    
    private func updateDataBase(newTweets: [Twitter.Tweet]) {
        managedObjectContext?.perform {
            for twitterInfo in newTweets {
                // create a new, unique Tweet with that Twitter info
                _ = Tweet.tweetWithTwitterInfo(twitterInfo: twitterInfo, inManagedObjectContext: self.managedObjectContext!)
            }
            do {
                try self.managedObjectContext?.save()
            } catch let error {
                print("Core Data Error: \(error)")
            }
        }
        printDatabaseStatistics()
        print("Done printing Database Statistics")
    }
    
    private func printDatabaseStatistics() {
        managedObjectContext?.perform {
            // less efficient way to count objects
            if let results = try? self.managedObjectContext!.fetch(NSFetchRequest(entityName: "TwitterUser")) {
                print("\(results.count) TwitterUsers")
            }
            
            // more efficient way to count objects
            if let tweetCount = try? self.managedObjectContext!.count(for: NSFetchRequest(entityName: "Tweet")) {
                print("\(tweetCount) Tweets")
            }
            /*
            do {
                let tweetCount = try self.managedObjectContext!.count(for: NSFetchRequest(entityName: "Tweet"))
                print("\(tweetCount) Tweets")
            } catch let error {
                print("Can't get tweetCount due to \(error)")
            }*/
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TweetersMentioningSearchTerm" {
            if let tweetersTVC = segue.destination as? TweetersTableViewController {
                tweetersTVC.mention = searchText!
                tweetersTVC.managedObjectContext = managedObjectContext
            }
        }
    }

    // MARK: - UITableViewDataSource
    
/*
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(tweets.count - section)"
    }
 */
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweets.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.TweetCellIdentifier, for: indexPath)
        
        let tweet = tweets[indexPath.section][indexPath.row]
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }
        
        return cell
    }
    
    private struct Storyboard {
        static let TweetCellIdentifier = "Tweet"
    }

    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = textField.text
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
