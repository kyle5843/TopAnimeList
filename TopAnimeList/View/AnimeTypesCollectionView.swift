//
//  AnimeTypesCollectionView.swift
//  TopAnimeList
//
//  Created by Kyle on 2020/7/25.
//  Copyright © 2020 Kyle. All rights reserved.
//

import UIKit

class AnimeTypesCollectionView: UICollectionView {
    
    let manager = AnimeTypesCollectionViewManager()
    
    func setup(with type:AnimeCollectionViewTypes){
        self.delegate = self.manager
        self.dataSource = self.manager
        self.manager.collectionViewType = type
        self.manager.loadTypes(JikanType.Anime.rawValue
            , defaultType:JikanSubType.Upcoming.rawValue)
        self.register(TypeCollectionCell.self, forCellWithReuseIdentifier: "TypeCollectionCell")
        self.reloadData()
    }
    
    func reload(with mainType:String){
        self.manager.loadTypes(mainType, defaultType: nil)
        self.reloadData()
    }

}
