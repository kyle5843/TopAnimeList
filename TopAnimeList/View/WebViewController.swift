//
//  WebViewController.swift
//  TopAnimeList
//
//  Created by Kyle on 2020/7/26.
//  Copyright © 2020 Kyle. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, BlackNavigationStyle, LargeProgress {
    var mWebView: WKWebView?
    var url:URL?
    var navTitle:String?
    
    lazy var progress: UIActivityIndicatorView = {
        var progress = UIActivityIndicatorView.init(style: .large)
        progress.color = #colorLiteral(red: 0.337254902, green: 0.337254902, blue: 0.337254902, alpha: 1)
        progress.center = self.view.center
        progress.startAnimating()
        self.view.addSubview(progress)
        return progress
    }()
    
    convenience init(url:URL, title:String) {
        self.init()
        self.url = url
        self.navTitle = title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigation()
        self.loadURL()
        
    }
    
    private func loadURL() {
        if let url = self.url {
            let request = URLRequest(url: url)
            // init and load request in webview.
            mWebView = WKWebView(frame: self.view.frame)
            if let mWebView = mWebView {
                mWebView.navigationDelegate = self
                mWebView.load(request)
                self.view.addSubview(mWebView)
                self.view.sendSubviewToBack(mWebView)
            }
        }
    }
 
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.shouldShowProgress(true)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.shouldShowProgress(false)
    }
}
