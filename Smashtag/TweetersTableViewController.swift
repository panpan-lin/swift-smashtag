//
//  TweetersTableViewController.swift
//  Smashtag
//
//  Created by Panpan Lin on 07/11/2016.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit
import CoreData

class TweetersTableViewController: CoreDataTableViewController {

    var mention: String? {
        didSet {
            updateUI()
        }
    }
    
    var managedObjectContext: NSManagedObjectContext? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        if let context = managedObjectContext , (mention?.characters.count)! > 0 {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TwitterUser")
            request.predicate = NSPredicate(format: "any tweets.text contains[c] %@", mention!)
            request.sortDescriptors = [NSSortDescriptor(
                key: "screenName",
                ascending: true,
                selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                )]
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
        } else {
            fetchedResultsController = nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TwitterUserCell", for: indexPath)

        // Configure the cell...
        if let twitterUser = fetchedResultsController?.object(at: indexPath) as? TwitterUser {
            var screenName: String?
            twitterUser.managedObjectContext?.performAndWait {
                screenName = twitterUser.screenName
            }
            cell.textLabel?.text = screenName
        }

        return cell
    }

}
