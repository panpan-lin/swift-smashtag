//
//  TweetersTableViewController.swift
//  Smashtag
//
//  Created by Panpan Lin on 07/11/2016.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class TweetersTableViewController: UITableViewController {

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }

}
