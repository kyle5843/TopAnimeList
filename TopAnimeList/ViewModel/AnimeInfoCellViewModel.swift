//
//  AnimeInfoCellViewModel.swift
//  TopAnimeList
//
//  Created by Kyle on 2020/7/25.
//  Copyright © 2020 Kyle. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol BaseTableCellModel {
    var identifier:String { get set }
    var indexPath:IndexPath? { get set }
    
    func didSelected()
    func cellHeight() -> CGFloat
}

extension BaseTableCellModel {
    func cellHeight() -> CGFloat {
        return 70
    }
}

class AnimeInfoCellViewModel: NSObject, BaseTableCellModel {
    
    let favoritedSubject = PublishSubject<(Bool, AnimeInfoCellViewModel)>()
    var identifier: String = "AnimeInfoCell"
    var indexPath: IndexPath?
    var animeInfo:AnimeInfo
    var favorite:Bool = false {
        didSet {
            self.favoritedSubject.onNext((favorite, self))
        }
    }
    weak var hostViewController:UIViewController?
    
    init(animeInfo:AnimeInfo) {
        self.animeInfo = animeInfo
        super.init()
    }
    
    func didSelected() {
        let webVC = WebViewController.init(url: URL.init(string: self.animeInfo.url)! , title: self.animeInfo.title)
        self.hostViewController?.navigationController?.pushViewController(webVC, animated: true)
    }
    
    static func == (lhs: AnimeInfoCellViewModel, rhs: AnimeInfoCellViewModel) -> Bool {
        return lhs.animeInfo.malId == rhs.animeInfo.malId
    }
}
