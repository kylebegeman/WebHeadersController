//
//  WHViewController.swift
//  WebHeadersController
//
//  Created by Kyle Begeman on 4/17/17.
//  Copyright © 2017 Kyle Begeman. All rights reserved.
//

import UIKit
import WebKit

/// NSObject stubbed class for input accessory modification
final class HideInputAccessoryHelper: NSObject {
    var inputAccessoryView: AnyObject? { return nil }
}

public protocol WHControllerDelegate: class {
    func didStartLoading()
    func didFinishLoading(success: Bool)
}

public class WHViewController: UIViewController {

    public weak var delegate: WHControllerDelegate?
    
    var closing: Bool! = false
    var request: URLRequest!
    
    lazy var backBarButtonItem: UIBarButtonItem = {
        var tempBackBarButtonItem = UIBarButtonItem(image: WHViewController.bundledImage(named: "back_icon"),
                                                    style: UIBarButtonItemStyle.plain,
                                                    target: self,
                                                    action: #selector(goBackTapped(_:)))
        tempBackBarButtonItem.width = 18.0
        tempBackBarButtonItem.tintColor = UIColor.darkGray
        return tempBackBarButtonItem
    }()
    
    lazy var forwardBarButtonItem: UIBarButtonItem = {
        var tempForwardBarButtonItem = UIBarButtonItem(image: WHViewController.bundledImage(named: "next_icon"),
                                                       style: UIBarButtonItemStyle.plain,
                                                       target: self,
                                                       action: #selector(goForwardTapped(_:)))
        tempForwardBarButtonItem.width = 18.0
        tempForwardBarButtonItem.tintColor = UIColor.darkGray
        return tempForwardBarButtonItem
    }()
    
    lazy var refreshBarButtonItem: UIBarButtonItem = {
        var tempRefreshBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh,
                                                       target: self,
                                                       action: #selector(reloadTapped(_:)))
        tempRefreshBarButtonItem.tintColor = UIColor.darkGray
        return tempRefreshBarButtonItem
    }()
    
    lazy var stopBarButtonItem: UIBarButtonItem = {
        var tempStopBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop,
                                                    target: self,
                                                    action: #selector(stopTapped(_:)))
        tempStopBarButtonItem.tintColor = UIColor.darkGray
        return tempStopBarButtonItem
    }()
    
    lazy var webView: WHWebView = {
        var tempWebView = WHWebView(frame: UIScreen.main.bounds)
        tempWebView.navigationDelegate = self
        
        return tempWebView
    }()
    
    fileprivate var showToolbar: Bool = true
    
    // MARK: - Initialization
    
    public convenience init(urlString: String, headers: WebHeaders? = nil, showToolbar: Bool = true, showKeyboardAccessory: Bool = true) {
        self.init(pageURL: URL(string: urlString)!)
        self.webView.setHeaders(headers)
        self.showToolbar = showToolbar
        
        if !showKeyboardAccessory {
            self._removeInputAccessoryView()
        }
    }
    
    public convenience init(pageURL: URL) {
        self.init(aRequest: URLRequest(url: pageURL))
    }
    
    public convenience init(aRequest: URLRequest) {
        self.init()
        self.request = aRequest
    }
    
    func loadRequest(_ request: URLRequest) {
        _ = webView.load(request)
    }
    
    deinit {
        webView.stopLoading()
        webView.navigationDelegate = nil
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

// MARK: - Lifecycle

extension WHViewController {
    
    override public func loadView() {
        view = webView
        loadRequest(request)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        updateToolbarItems()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        assert(self.navigationController != nil, "WHViewController must be contained within a UINavigationController. Use WHModalViewController for modal presentation with built in navigation.")
        
        super.viewWillAppear(true)
        
        if self.showToolbar {
            self.navigationController?.setToolbarHidden(false, animated: false)
        }
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone) {
            self.navigationController?.setToolbarHidden(true, animated: true)
        }
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
        
        if !showToolbar {
            webView.scrollView.contentInset = UIEdgeInsets.zero;
        }
    }
    
}

// MARK: - Actions

extension WHViewController {
    
    func goBackTapped(_ sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    func goForwardTapped(_ sender: UIBarButtonItem) {
        webView.goForward()
    }
    
    func reloadTapped(_ sender: UIBarButtonItem) {
        webView.reload()
    }
    
    func stopTapped(_ sender: UIBarButtonItem) {
        webView.stopLoading()
        updateToolbarItems()
    }
    
    func doneButtonTapped() {
        closing = true
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Navigation Delegate & Swizzle

extension WHViewController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.delegate?.didStartLoading()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        updateToolbarItems()
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.delegate?.didFinishLoading(success: true)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        webView.evaluateJavaScript("document.title", completionHandler: {(response, _) in
            if let text = response as? String {
                self.title = text
            }
            
            self.updateToolbarItems()
        })
        
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.delegate?.didFinishLoading(success: false)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        updateToolbarItems()
    }
    
}

// MARK: - Helpers

extension WHViewController {
    
    class func bundledImage(named: String) -> UIImage? {
        let image = UIImage(named: named)
        
        if image == nil {
            return UIImage(named: named, in: Bundle(for: WHViewController.classForCoder()), compatibleWith: nil)
        }
        
        return image
    }
    
    func updateToolbarItems() {
        if !showToolbar {
            navigationController!.toolbar.isHidden = true
            return
        }
        
        backBarButtonItem.isEnabled = webView.canGoBack
        forwardBarButtonItem.isEnabled = webView.canGoForward
        
        let refreshStopBarButtonItem: UIBarButtonItem = webView.isLoading ? stopBarButtonItem : refreshBarButtonItem
        let fixedSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        let flexibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        fixedSpace.width = 35
        
        let items: NSArray = [backBarButtonItem, fixedSpace, forwardBarButtonItem, flexibleSpace, refreshStopBarButtonItem]
        
        if !closing {
            navigationController!.toolbar.tintColor = UIColor.white
            navigationController!.toolbar.backgroundColor = UIColor.white
            toolbarItems = items as? [UIBarButtonItem]
        }
    }
    
    /// Method to be swizzled; allows user to remove keyboard accessory input view when typing on a web page.
    func _removeInputAccessoryView() {
        var targetView: UIView? = nil
        
        for view in webView.scrollView.subviews {
            if String(describing: type(of: view)).hasPrefix("WKContent") {
                targetView = view
            }
        }
        
        guard let target = targetView else { return }
        
        let noInputAccessoryViewClassName = "\(target.superclass!)_NoInputAccessoryView"
        var newClass: AnyClass? = NSClassFromString(noInputAccessoryViewClassName)
        if newClass == nil {
            let targetClass: AnyClass = object_getClass(target)
            newClass = objc_allocateClassPair(targetClass, noInputAccessoryViewClassName.cString(using: String.Encoding.ascii)!, 0)
        }
        
        let originalMethod = class_getInstanceMethod(HideInputAccessoryHelper.self, #selector(getter: HideInputAccessoryHelper.inputAccessoryView))
        class_addMethod(newClass!.self, #selector(getter: HideInputAccessoryHelper.inputAccessoryView), method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        object_setClass(target, newClass)
    }
    
}
