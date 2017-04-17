//
//  WHViewController.swift
//  WebHeadersController
//
//  Created by Kyle Begeman on 4/17/17.
//  Copyright © 2017 Kyle Begeman. All rights reserved.
//

import UIKit

public class WHModalViewController: UINavigationController {

    weak var webViewDelegate: UIWebViewDelegate?
    
    fileprivate var webController: WHViewController!
    
    public init(urlString: String, headers: WebHeaders? = nil, showToolbar: Bool = true, showKeyboardAccessory: Bool = true, dismissTitle: String = "Close") {
        self.webController = WHViewController(urlString: urlString, headers: headers, showToolbar: showToolbar, showKeyboardAccessory: showKeyboardAccessory)
        
        let dismissButton = UIBarButtonItem(title: dismissTitle,
                                            style: UIBarButtonItemStyle.plain,
                                            target: webController,
                                            action: #selector(WHViewController.doneButtonTapped))
        
        webController.navigationItem.leftBarButtonItem = dismissButton
        
        if !showKeyboardAccessory {
            webController._removeInputAccessoryView()
        }
        
        super.init(rootViewController: webController)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
    }

}
