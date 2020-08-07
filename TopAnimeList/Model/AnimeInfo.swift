//
//  AnimeInfo.swift
//  TopAnimeList
//
//  Created by Kyle on 2020/7/23.
//  Copyright © 2020 Kyle. All rights reserved.
//

import UIKit

enum AnimeInfoKeys: String, CodingKey {
    case MalId     = "mal_id"
    case Title     = "title"
    case EndDate   = "end_date"
    case StartDate = "start_date"
    case TypeKey   = "type"
    case URL       = "url"
    case ImageUrl  = "image_url"
    case Members   = "members"
    case Rank      = "rank"
    case Score     = "score"
}

struct DecodeFailable<Base : Decodable> : Decodable {
    let base: Base?

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.base = try? container.decode(Base.self)
    }
}

struct AnimeInfo : Equatable, Decodable {
    
    var malId: Int
    var title: String
    var startDate: String
    var endDate: String
    var type: String
    var url: String
    var imageUrl: String
    var members:Int
    var rank: Int
    var score: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnimeInfoKeys.self)
        self.malId = try container.decode(Int.self, forKey: .MalId)
        self.title = try container.decode(String.self, forKey: .Title)
        self.startDate = try container.decodeIfPresent(String.self, forKey: .StartDate) ?? "N/A"
        self.endDate = try container.decodeIfPresent(String.self, forKey: .EndDate) ?? "N/A"
        self.type = try container.decodeIfPresent(String.self, forKey: .TypeKey) ?? "N/A"
        self.url = try container.decodeIfPresent(String.self, forKey: .URL) ?? "N/A"
        self.imageUrl = try container.decodeIfPresent(String.self, forKey: .ImageUrl) ?? "N/A"
        self.members = try container.decodeIfPresent(Int.self, forKey: .Members) ?? 0
        self.rank = try container.decodeIfPresent(Int.self, forKey: .Rank) ?? 0
        self.score = try container.decodeIfPresent(Int.self, forKey: .Score) ?? 0
    }
    
    init(info:[AnimeInfoKeys : Any]) {
        self.malId = info[.MalId] as! Int
        self.title = info[.Title] as! String
        self.startDate = info[.StartDate] as? String ?? "N/A"
        self.endDate = info[.EndDate] as? String ?? "N/A"
        self.type = info[.TypeKey] as? String ?? "N/A"
        self.url = info[.URL] as? String ?? "N/A"
        self.imageUrl = info[.ImageUrl] as? String ?? "N/A"
        self.members = info[.Members] as? Int ?? 0
        self.rank = info[.Rank] as? Int ?? 0
        self.score = info[.Score] as? Int ?? 0
    }
    
    static func == (lhs: AnimeInfo, rhs: AnimeInfo) -> Bool {
        return lhs.malId == rhs.malId
    }
    
    static func convert(_ dict:Dictionary<String, Any>) -> Dictionary<AnimeInfoKeys, Any> {
        var infos = Dictionary<AnimeInfoKeys, Any>()
        for (key, value) in dict {
            if let newKey = AnimeInfoKeys.init(rawValue: key) {
                infos[newKey] = value
            }
        }
        return infos
    }
}
