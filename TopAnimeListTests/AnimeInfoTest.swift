//
//  AnimeInfoTest.swift
//  TopAnimeListTests
//
//  Created by Kyle on 2020/7/27.
//  Copyright © 2020 Kyle. All rights reserved.
//

import UIKit
import XCTest
@testable import TopAnimeList

class AnimeInfoTest: XCTestCase {

    func testInfoCreate() throws {
        let mockValidData:Array<[String:Any]>
            = [[AnimeInfoKeys.MalId.rawValue : 40456,
               AnimeInfoKeys.Title.rawValue : "Kimetsu no Yaiba Movie: Mugen",
               AnimeInfoKeys.StartDate.rawValue : "Oct 2020"]]
        let mockFailData:Array<[String:Any]>
            = [[AnimeInfoKeys.Score.rawValue : 0,
               AnimeInfoKeys.Title.rawValue : "Kimetsu no Yaiba Movie: Mugen",
               AnimeInfoKeys.StartDate.rawValue : "Oct 2020"]]
       
        let validTest = self.infoTest(mockValidData)
        let failTest = self.infoTest(mockFailData)

        if !validTest || failTest {
            XCTFail("test failed: AnimeInfo data type check error")
        }
    }
    
    func infoTest(_ rawData:Array<[String:Any]>) -> Bool {
        do {
            let data = try JSONSerialization.data(withJSONObject: rawData, options: [])
            let type = [DecodeFailable<AnimeInfo>].self
            let list = try JSONDecoder().decode(type, from: data).compactMap{ $0.base }
            return list.count > 0
        } catch {
            return false
        }
    }
}
