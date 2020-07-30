//
//  Alert.swift
//  TopAnimeList
//
//  Created by Kyle on 2020/7/26.
//  Copyright © 2020 Kyle. All rights reserved.
//

import UIKit

class AlertDialog {
    
    class func alert(title:String, message:String, vc:UIViewController?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        if let viewController = vc {
            viewController.present(alert, animated: true, completion: nil)
        } else {
            let viewController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
            viewController?.present(alert, animated: true, completion: nil)
        }
    }
    
}
