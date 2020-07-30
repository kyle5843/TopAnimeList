//
//  ViewControllerProtocol.swift
//  TopAnimeList
//
//  Created by Kyle on 2020/7/25.
//  Copyright © 2020 Kyle. All rights reserved.
//

import Foundation

import UIKit

protocol BlackNavigationStyle where Self : UIViewController{
    var navTitle:String { get }
    func setupNavigation()
}

extension BlackNavigationStyle {
    
    var navTitle: String { return "Title" }
    
    func setupNavigation() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(
        title:"", style:.plain, target:nil, action:nil)
        self.navigationController?.navigationBar.tintColor = UIColor.black;
        self.navigationItem.title = self.navTitle
    }
}

protocol LargeProgress where Self :UIViewController {
    var progress: UIActivityIndicatorView { get set }
}

extension LargeProgress {
    internal func shouldShowProgress(_ show:Bool){
        self.progress.isHidden = !show
        if show {
            self.progress.startAnimating()
        } else {
            self.progress.stopAnimating()
        }
    }
}
