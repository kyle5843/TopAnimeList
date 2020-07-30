//
//  JikanAPIHelper.swift
//  TopAnimeList
//
//  Created by Kyle on 2020/7/23.
//  Copyright © 2020 Kyle. All rights reserved.
//

import UIKit
import Alamofire

enum APIErrorCode:Error {
    case DataForamtError
    case HTTPAccessError
}

public struct APIError: Error {
    let msg:String
    let code:APIErrorCode
}

class JikanAPIHelper: NSObject {
    
    static let host = "https://api.jikan.moe/v3"
    static let top = "top"
    
    /* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    *  Fetch top anime list
    *
    *  HTTP Method: Get, without Parameters
    *  Ex: "https://api.jikan.moe/v3/type/page/subtype"
    *
    * ------------------------------------------------------------*/
    class func fetchTopAnimeList(_ params:Parameters, completion:@escaping (Array<AnimeInfo>?, APIError?) -> Void) -> DataRequest {
        let type = params["type"] ?? ""
        let page = params["page"] ?? "0"
        let subtype = params["subtype"] ?? ""
        let topHost = host + "/" + top + "/" + type + "/" + page + "/" + subtype
        return AF.request(topHost, parameters: nil).responseJSON { (response) in
            switch response.result {
            case .success(let json):
                if let json = json as? [String: Any] {
                    if let data = json[top] as? Array<[String: Any]> {
                        let list:Array<AnimeInfo> = data.compactMap { item -> AnimeInfo? in
                            let info = AnimeInfo.convert(item)
                            if Dictionary<AnimeInfoKeys, Any>.isValidity(dict: info, typeMap: AnimeInfo.typeMap()) {
                                return AnimeInfo.init(info: info)
                            }
                            return nil
                        }
                        completion(list, nil)
                        return
                    } else if let error = json["error"] as? String {
                        completion(nil, APIError.init(msg: error,
                                                      code: .HTTPAccessError))
                        return
                    }
                }
                completion(nil, APIError.init(msg: "Bad data format",
                                              code: .DataForamtError))
                NSLog("FetchTopAnime fail, Bad data format")
                break
            case .failure(let error):
                let msg = error.errorDescription ?? "failed!!"
                completion(nil, APIError.init(msg: msg,
                                              code: .DataForamtError))
                NSLog("FetchTopAnime fail, \(msg)")
            }
        }
    }
}
