//
//  AnimeInfoRepository.swift
//  TopAnimeList
//
//  Created by Kyle on 2020/7/23.
//  Copyright © 2020 Kyle. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol DataRepository {
    associatedtype element
    var fetchSubject:PublishSubject<Array<element>> { get }
    
    func fetchData(_ params:Parameters)
    func postData(dataList:Array<element>?) -> Void
    func cancelFetch() -> Void
}

/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*
*  This repository if for data persistence.
*
*  ToDo: FetchData will get data from local DB & API server
*
* ------------------------------------------------------------*/
class AnimeInfoRepository: NSObject, DataRepository {
    typealias element = AnimeInfo
    
    static let shared = AnimeInfoRepository()
    let fetchSubject = PublishSubject<Array<AnimeInfo>>()
    
    private override init() {
        super.init()
    }
    
    func fetchData(_ params: Parameters) {
        DispatchQueue.global().async {
            JikanRequestManager.shared.fetchTopAnimeList(params) { (infos, error) in
                if let infos = infos {
                    self.fetchSubject.onNext(infos)
                    if infos.count == 0 {
                        AlertDialog.alert(title: "Sorry!", message: "No info are returned in this section.", vc: nil)
                    }
                } else {
                    self.fetchSubject.onNext(Array<AnimeInfo>())
                    let msg = error?.msg ?? "Something error"
                    AlertDialog.alert(title: "Error!", message: msg, vc: nil)
                }
            }
        }
    }
    
    func cancelFetch() {
        JikanRequestManager.shared.cancelRequest()
    }
    
    // unused
    func postData(dataList: Array<AnimeInfo>?) {
        
    }
}
