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

class AnimeInfo: NSObject, NSCopying {
    
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
    
    var favorite:Bool = false
    
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
        
        super.init()
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let info = AnimeInfo.init(info: [.MalId : self.malId,
                                         .Title : self.title,
                                         .StartDate : self.startDate,
                                         .EndDate : self.endDate,
                                         .TypeKey : self.type,
                                         .URL : self.url,
                                         .ImageUrl : self.imageUrl,
                                         .Members : self.members,
                                         .Rank  : self.rank,
                                         .Score : self.score ])
        info.favorite = self.favorite
        return info
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let info = object as? AnimeInfo  else {
            return false
        }
        return self.malId == info.malId
    }
    
    //MARK: Static functions
    
    /* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    *  AnimeInfo type check
    *
    *  Skip the info without MalId & Title
    *  Other fail/null value will replace by "N/A"
    *
    * ------------------------------------------------------------*/
    static func typeMap() -> Dictionary<AnimeInfoKeys, Any>{
        return [.MalId : Int.self,
                .Title : String.self]
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
