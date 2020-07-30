//
//  APITest.swift
//  TopAnimeListTests
//
//  Created by Kyle on 2020/7/27.
//  Copyright © 2020 Kyle. All rights reserved.
//

import XCTest
@testable import TopAnimeList

class APITest: XCTestCase {
    
    let host = "https://api.jikan.moe/v3/top"
    let mockParameters = ["type":"anime", "page":"1", "subtype":"upcoming"]
    
    lazy var promise = expectation(description: "Completion handler invoked")
    var result:Array<AnimeInfo>?
    var statusCode: Int?
    var responseError: Error?

    func testAPIHelperResult() throws {

        _ = JikanAPIHelper.fetchTopAnimeList(mockParameters) { (response, error) in
            self.result = response
            self.responseError = error
            self.promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5)
        
        if self.result == nil {
            XCTFail("test failed: result nil")
        }
        
        self.responseError = nil
        self.result = nil
    }
}


