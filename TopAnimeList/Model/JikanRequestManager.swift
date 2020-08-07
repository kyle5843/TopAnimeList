//
//  JikanRequestManager.swift
//  TopAnimeList
//
//  Created by Kyle on 2020/7/23.
//  Copyright © 2020 Kyle. All rights reserved.
//

import UIKit
import Alamofire

public typealias Parameters = [String: String]

class JikanRequestManager: NSObject {

    static let shared = JikanRequestManager()
    private var requests = Dictionary<Parameters, DataRequest>()
    
    private override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector:#selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
    }
    
    func fetchTopAnimeList(_ params:Parameters, completion:@escaping (Array<AnimeInfo>?, APIError?) -> Void) {
        self.requests[params] = JikanAPIHelper.fetchTopAnimeList(params) { (infos, error) in
            self.requests.removeValue(forKey: params)
            completion(infos, error)
        }
    }
    
    @objc func applicationDidEnterBackground(){
        self.cancelRequest()
    }
    
    func cancelRequest(){
        for (_, request) in self.requests {
            request.cancel()
        }
        self.requests.removeAll()
    }
}
