//
//  Set+Extension.swift
//  TopAnimeList
//
//  Created by Kyle on 2020/7/26.
//  Copyright © 2020 Kyle. All rights reserved.
//

import Foundation

extension Set where Element: Equatable {

    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        guard let index = firstIndex(of: object) else {return}
        remove(at: index)
    }

}
