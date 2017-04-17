//
//  BaseViewController.swift
//  WebHeadersController
//
//  Created by Kyle Begeman on 4/17/17.
//  Copyright © 2017 Kyle Begeman. All rights reserved.
//

import UIKit
import WebHeadersController

class BaseViewController: UITableViewController {
    
    // Configure as desired for testing
    let url: String = "https://www.google.com"
    let dismissTitle: String = "Done"
    let headers: [String: String] = [:]
    let showToolbar: Bool = true
    let showKeyboardAccessory: Bool = true

    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 2 }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            // Push view controller
            let vc = WHViewController(urlString: url, headers: headers, showToolbar: showToolbar, showKeyboardAccessory: showKeyboardAccessory)
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 1:
            // Present view controller with modal class
            let vc = WHModalViewController(urlString: url, headers: headers, showToolbar: showToolbar, showKeyboardAccessory: showKeyboardAccessory, dismissTitle: dismissTitle)
            self.present(vc, animated: true, completion: nil)
            
        default:
            break
        }
    }
}
