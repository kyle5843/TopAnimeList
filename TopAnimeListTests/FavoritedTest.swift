//
//  FavoritedTest.swift
//  TopAnimeListTests
//
//  Created by Kyle on 2020/7/27.
//  Copyright © 2020 Kyle. All rights reserved.
//

import XCTest
@testable import TopAnimeList

class FavoritedTest: XCTestCase {

    lazy var mockViewModel:MainPageViewModel = {
        let mockViewModel = MainPageViewModel()
        mockViewModel.topAnimeInfos = [
            AnimeInfoCellViewModel.init(animeInfo: AnimeInfo.init(info:
                [.MalId : 40456,
                 .Title : "Kimetsu no Yaiba Movie: Mugen",
                 .StartDate : "Oct 2020"])),
            AnimeInfoCellViewModel.init(animeInfo: AnimeInfo.init(info:
                [.MalId : 40457,
                 .Title : "Kimetsu no Yaiba Movie: Mugen",
                 .StartDate : "Oct 2020"])),
            AnimeInfoCellViewModel.init(animeInfo: AnimeInfo.init(info:
                [.MalId : 40458,
                 .Title : "Kimetsu no Yaiba Movie: Mugen",
                 .StartDate : "Oct 2020"])),
        ]
        for cellModel in mockViewModel.topAnimeInfos {
            mockViewModel.bindFavoriteAction(cellModel)
        }
        return mockViewModel
    }()


    func testFavorited() throws {
        let info = self.mockViewModel.topAnimeInfos.first
        info?.favorite = true
        
        if !self.mockViewModel.favoriteAnimeInfos.contains(info!) {
            XCTFail("test failed: can not add favortie info")
        }
        
        info?.favorite = false
        if self.mockViewModel.favoriteAnimeInfos.contains(info!) {
            XCTFail("test failed: can not remove favortie info")
        }
    }

}
