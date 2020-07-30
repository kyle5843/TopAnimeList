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
        let mockValidData:[AnimeInfoKeys:Any]
            = [.MalId : 40456,
               .Title : "Kimetsu no Yaiba Movie: Mugen",
               .StartDate : "Oct 2020"]
        let mockFailData:[AnimeInfoKeys:Any]
            = [.Score : 0,
               .Title : "Kimetsu no Yaiba Movie: Mugen",
               .StartDate : "Oct 2020"]
       
        let validTest = Dictionary<AnimeInfoKeys, Any>.isValidity(dict: mockValidData, typeMap: AnimeInfo.typeMap())
        let failTest = Dictionary<AnimeInfoKeys, Any>.isValidity(dict: mockFailData, typeMap: AnimeInfo.typeMap())

        if !validTest || failTest {
            XCTFail("test failed: AnimeInfo data type check error")
        }
    }
}
