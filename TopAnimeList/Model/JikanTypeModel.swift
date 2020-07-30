//
//  JikanTypeModel.swift
//  TopAnimeList
//
//  Created by Kyle on 2020/7/25.
//  Copyright © 2020 Kyle. All rights reserved.
//

import UIKit

enum JikanType: String {
    case Anime     = "anime"
    case Manga     = "manga"
}

enum JikanSubType: String {
    // Anime
    case Airing     = "airing"
    case Upcoming   = "upcoming"
    case Tv         = "tv"
    case Movie      = "movie"
    case Ova        = "ova"
    case Special    = "special"
    // Manga
    case Manga      = "manga"
    case Novels     = "novels"
    case Oneshots   = "oneshots"
    case Doujin     = "doujin"
    case Manhwa     = "manhwa"
    // Both
    case bypopularity = "bypopularity"
    case favorite = "favorite"
}

class JikanTypeModel: NSObject {
    private let animeSubTypes:Array<JikanSubType> =
                                            [.Airing,
                                            .Upcoming,
                                            .Tv,
                                            .Manga,
                                            .Ova,
                                            .Special]
    private let mangaSubTypes:Array<JikanSubType> =
                                            [.Manga,
                                            .Novels,
                                            .Oneshots,
                                            .Doujin,
                                            .Manhwa]
    private let bothSubTypes:Array<JikanSubType> =
                                            [.bypopularity,
                                           .favorite]
    
    lazy var subTypesDictionary:Dictionary<JikanType, Array<JikanSubType>>  = {
        var dict = Dictionary<JikanType, Array<JikanSubType>>()
        dict[.Anime] = self.animeSubTypes + bothSubTypes
        dict[.Manga] = self.mangaSubTypes + bothSubTypes
        return dict
    }()
    
    static let shared = JikanTypeModel()
    
    func mainTypeList() -> Array<JikanType> {
        return [.Anime, .Manga]
    }
    
    func subTypeList(_ mainType:String) -> Array<JikanSubType>{
        if let type = JikanType.init(rawValue: mainType),
           let list = self.subTypesDictionary[type] {
            return list
        }
        return Array<JikanSubType>()
    }
}
