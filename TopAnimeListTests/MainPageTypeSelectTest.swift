//
//  MainPageTypeSelectTest.swift
//  TopAnimeListTests
//
//  Created by Kyle on 2020/7/27.
//  Copyright © 2020 Kyle. All rights reserved.
//

import XCTest
@testable import TopAnimeList

class MainPageTypeSelectTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTypeSelectedExample() throws {
        let mainType = AnimeTypesCollectionView.init(frame: CGRect(x: 0,y: 0, width: 100, height: 100), collectionViewLayout: UICollectionViewLayout.init())
        let subType = AnimeTypesCollectionView.init(frame: CGRect(x: 0,y: 0, width: 100, height: 100), collectionViewLayout: UICollectionViewLayout.init())
        
        mainType.setup(with: .MainType)
        subType.setup(with: .SubType)
        
        // test default
        var main = mainType.manager.currentModel?.type
        var sub = subType.manager.currentModel?.type
        
        if main != JikanType.Anime.rawValue
            || sub != JikanSubType.Upcoming.rawValue {
            XCTFail("test failed: default type selected")
        }
        
        // test main selected
        mainType.manager.collectionView(mainType, didSelectItemAt: IndexPath(row: 1, section: 0))
        main = mainType.manager.currentModel?.type
        if main != JikanType.Manga.rawValue {
            XCTFail("test failed: main select type selected")
        }
        
        // mock trigger load type
        subType.manager.loadTypes(main!, defaultType: nil)
        sub = subType.manager.currentModel?.type
        if sub != JikanSubType.Manga.rawValue {
            XCTFail("test failed: main select type selected")
        }
    }

}
