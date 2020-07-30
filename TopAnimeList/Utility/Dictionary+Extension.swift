//
//  Dictionary+Extension.swift
//  TopAnimeList
//
//  Created by Kyle on 2020/7/25.
//  Copyright © 2020 Kyle. All rights reserved.
//

import Foundation

extension Dictionary {
    static func isValidity<T>(dict:Dictionary<T, Any>, typeMap:Dictionary<T, Any>) -> Bool {
        for (key, _) in typeMap {
            guard dict[key] != nil else {
                NSLog("type invalid")
                return false
            }
        }
        return true
    }
}
