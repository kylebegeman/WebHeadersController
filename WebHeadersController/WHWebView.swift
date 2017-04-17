//
//  WHWebView.swift
//  WebHeadersController
//
//  Created by Kyle Begeman on 4/17/17.
//  Copyright © 2017 Kyle Begeman. All rights reserved.
//

import UIKit
import WebKit

public typealias WebHeaders = [String: String]

public class WHWebView: WKWebView {

    // Local ref for headers
    fileprivate var headers: WebHeaders?
    
    override public func load(_ request: URLRequest) -> WKNavigation? {
        var mutableRequest = request
        
        if let headers = self.headers {
            for (key, value) in headers {
                mutableRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return super.load(mutableRequest)
    }
    
    public func setHeaders(_ headers: WebHeaders?) {
        self.headers = headers
    }
    
}
