//
//  AnimeInfoCell.swift
//  TopAnimeList
//
//  Created by Kyle on 2020/7/25.
//  Copyright © 2020 Kyle. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

protocol BaseCell : UITableViewCell{
    var indexPath: IndexPath? { get set }
    func setData(_ viewModel:BaseTableCellModel)
}

class AnimeInfoCell: UITableViewCell, BaseCell {
    
    @IBOutlet weak var rankValueLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var followButton: UIImageView!
    
    private var disposeBag = DisposeBag()
    private var favorite:Bool = false {
        didSet {
            let name = favorite ? "heartOn" : "heartOff"
            self.followButton.image = UIImage(named: name)?.withTintColor(.red)
            self.viewModel?.favorite = favorite
        }
    }
    
    var indexPath:IndexPath?
    var viewModel:AnimeInfoCellViewModel? {
        didSet {
            guard let info = viewModel?.animeInfo else { return }
            
            self.rankValueLabel.text = "\(info.rank)"
            self.titleLabel.text = info.title
            self.dateLabel.text = "\(info.startDate) - \(info.endDate)"
            self.typeLabel.text = info.type
            self.scoreLabel.text = "⭐️\(info.score)"
            self.thumbnail.backgroundColor = #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.262745098, alpha: 0.3)
            self.thumbnail.sd_setImage(with: URL.init(string: info.imageUrl)) { [weak self] (image, erro, cache, url) in
                self?.thumbnail.backgroundColor = UIColor.clear
            }
            
            self.favorite = viewModel?.favorite ?? false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.followButton.isUserInteractionEnabled = true
        self.titleLabel.adjustsFontSizeToFitWidth = true
        
    }
    
    func setData(_ viewModel: BaseTableCellModel) {
        self.viewModel = viewModel as? AnimeInfoCellViewModel
        self.indexPath = self.viewModel?.indexPath
        self.bind()
    }
    
    func bind(){
        self.disposeBag = DisposeBag()
        
        let tap = UITapGestureRecognizer()
        self.followButton.addGestureRecognizer(tap)
        tap.rx.event
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(onNext: {[weak self] recognizer in
            self?.favorite.toggle()
        }).disposed(by: self.disposeBag)
        
        self.viewModel?.favoritedSubject
            .distinctUntilChanged({ (old, new) -> Bool in
                let (nFav, nModel) = old
                let (oFav, oModel) = new
                return oFav == nFav && oModel == nModel
            })
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] (newFavorite, _) in
                guard let self = self else { return }
                
                self.favorite = newFavorite
                
                }, onCompleted: {
                    
            }).disposed(by: disposeBag)
    }
    
}
