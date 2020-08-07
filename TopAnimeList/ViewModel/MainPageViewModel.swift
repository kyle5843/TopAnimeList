//
//  MainPageViewModel.swift
//  TopAnimeList
//
//  Created by Kyle on 2020/7/25.
//  Copyright © 2020 Kyle. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MainPageViewModel: NSObject {
    
    let disposeBag = DisposeBag()
    let fetchAnimesSubject = BehaviorSubject.init(value: ())
    var topAnimeInfos = Array<AnimeInfoCellViewModel>()
    var favoriteAnimeInfos = Set<AnimeInfoCellViewModel>()
    let favoriteStateSubject = PublishSubject<Int>()
    var page = 1
    var animeType:String = JikanType.Anime.rawValue
    var animeSubType:String = JikanSubType.Upcoming.rawValue
    
    override init() {
        super.init()
        self.bind()
    }
    
    private func bind(){
        AnimeInfoRepository.shared.fetchSubject
            .observeOn(MainScheduler.instance)
            .subscribe({ [weak self] list in
                guard let self = self else { return }
                guard let infos = list.element else { return }
                self.topAnimeInfos.append(contentsOf: infos.map({ [weak self] info -> AnimeInfoCellViewModel in
                    let cellModel = AnimeInfoCellViewModel.init(animeInfo: info)
                    guard let self = self else { return cellModel }
                    
                    self.bindFavoriteAction(cellModel)
                    self.updateFavorites(cellModel)
                    
                    return cellModel
                }))
                self.fetchAnimesSubject.onNext(())
            }).disposed(by: disposeBag)
    }
    
    internal func bindFavoriteAction(_ cellModel:AnimeInfoCellViewModel){
        cellModel.favoritedSubject.observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (favorite, cellModel) in
                guard let self = self else { return }
                
                if favorite {
                    self.favoriteAnimeInfos.insert(cellModel)
                } else {
                    let index = Array(self.favoriteAnimeInfos).firstIndex(of: cellModel) ?? -1
                    self.favoriteAnimeInfos.remove(object: cellModel)
                    self.favoriteStateSubject.onNext(index)
                }
                
            }).disposed(by: disposeBag)
    }
    
    private func updateFavorites(_ cellModel:AnimeInfoCellViewModel) {

        for model in self.favoriteAnimeInfos {
            if model.animeInfo.malId == cellModel.animeInfo.malId {
                cellModel.favorite = true
                self.favoriteAnimeInfos.remove(object: model)
                self.favoriteAnimeInfos.insert(cellModel)
            }
        }
    }
    
    func fetchData() {
        let params:Parameters = ["type":animeType,
                                 "page":"\(page)",
                                 "subtype":animeSubType]
        self.page += 1
        AnimeInfoRepository.shared.fetchData(params)
    }
    
    func loadMoreIfNeed(_ index:Int){
        let count = self.topAnimeInfos.count
        if count - index <= 10 && count >= 50 {
            self.fetchData()
        }
    }

}
