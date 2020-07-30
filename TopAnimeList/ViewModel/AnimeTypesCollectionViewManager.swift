//
//  AnimeTypesCollectionViewManager.swift
//  TopAnimeList
//
//  Created by Kyle on 2020/7/25.
//  Copyright © 2020 Kyle. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum AnimeCollectionViewTypes: String {
    case MainType
    case SubType
}

struct AnimeTypeModel {
    var type:String
    var isSelected:BehaviorRelay<Bool> = BehaviorRelay<Bool>(value:false)
    var indexPath:IndexPath?
    
    init(_ type:String) {
        self.type = type
    }
}

class AnimeTypesCollectionViewManager: NSObject {
    
    var jikanTypeRelay:PublishRelay<String> = PublishRelay<String>()
    var modelArray = Array<AnimeTypeModel>()
    var currentModel:AnimeTypeModel? {
        didSet {
            if let type = currentModel?.type {
                self.jikanTypeRelay.accept(type)
            }
        }
    }
    
    var collectionViewType:AnimeCollectionViewTypes = .MainType
    
    func loadTypes(_ jikanType:String, defaultType:String?) {
        if collectionViewType == .MainType {
            self.modelArray = JikanTypeModel.shared.mainTypeList().map({ [weak self] (type) -> AnimeTypeModel in
                let model = AnimeTypeModel.init(type.rawValue)
                if model.type == jikanType {
                    model.isSelected.accept(true)
                    self?.currentModel = model
                }
                return model
            })
        } else {
            let subType = defaultType ?? ""
            self.modelArray = JikanTypeModel.shared.subTypeList(jikanType).map({ [weak self] (jikanSubType) -> AnimeTypeModel in
                let model = AnimeTypeModel.init(jikanSubType.rawValue)
                if model.type == subType {
                    model.isSelected.accept(true)
                    self?.currentModel = model
                }
                return model
            })
            if let first = self.modelArray.first, subType == "" {
                first.isSelected.accept(true)
                self.currentModel = first
            }
        }
    }
}

//MARK: UICollectionView Delegate
extension AnimeTypesCollectionViewManager : UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath != self.currentModel?.indexPath {
            self.currentModel?.isSelected.accept(false)
            self.currentModel = self.modelArray[indexPath.row]
            self.currentModel!.isSelected.accept(true)
        }
    }
    
}

//MARK: UICollectionView DataSource
extension AnimeTypesCollectionViewManager : UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.modelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cellModel = self.modelArray[indexPath.row]
        cellModel.indexPath = indexPath
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TypeCollectionCell", for: indexPath) as! TypeCollectionCell
        cell.model = cellModel
        
        return cell
    }
}

//MARK: UICollectionView FlowLayout
extension AnimeTypesCollectionViewManager : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: 120, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0;
    }
}
