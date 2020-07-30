//
//  MainPageViewController.swift
//  TopAnimeList
//
//  Created by Kyle on 2020/7/25.
//  Copyright © 2020 Kyle. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainPageViewController: UIViewController ,BlackNavigationStyle, LargeProgress {
    
    let navTitle: String = "MainPage"
    let viewModel = MainPageViewModel()
    let disposeBag = DisposeBag()
    var infoTableManager:AnimeInfoTableViewManager?
    
    lazy var progress: UIActivityIndicatorView = {
        var progress = UIActivityIndicatorView.init(style: .large)
        progress.color = #colorLiteral(red: 0.337254902, green: 0.337254902, blue: 0.337254902, alpha: 1)
        progress.center = CGPoint(x:self.view.center.x, y: self.view.center.y + self.subTypeCollectionView.bounds.height)
        progress.startAnimating()
        self.view.addSubview(progress)
        return progress
    }()
    
    @IBOutlet weak var favoriteListButton: UIImageView!
    @IBOutlet weak var mainTypeCollectionView: AnimeTypesCollectionView!
    @IBOutlet weak var subTypeCollectionView: AnimeTypesCollectionView!
    @IBOutlet weak var topAnimeInfoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupCollectionViews()
        self.bind()
        self.shouldShowProgress(true)
        self.viewModel.fetchData()
    }
    
    func setupView() {
        self.setupNavigation()
        self.favoriteListButton.image = UIImage(named: "heartOn")?.withTintColor(.red)
        
        self.infoTableManager = AnimeInfoTableViewManager.init( self.topAnimeInfoTableView, self.viewModel)
        self.infoTableManager?.hostViewController = self
    }
    
    func setupCollectionViews() {
        self.mainTypeCollectionView.setup(with: .MainType)
        self.subTypeCollectionView.setup(with: .SubType)
    }
    
    func bind(){
        self.mainTypeCollectionView.manager.jikanTypeRelay
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(onNext: { [weak self] (type) in
                guard let self = self else { return }
                self.viewModel.animeType = type
                self.subTypeCollectionView.reload(with: type)
            }).disposed(by: disposeBag)
        
        self.subTypeCollectionView.manager.jikanTypeRelay
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(onNext: { [weak self] (type) in
                guard let self = self else { return }
                self.shouldShowProgress(true)
                self.viewModel.animeSubType = type
                self.infoTableManager?.clearData()
                self.viewModel.fetchData()
            }).disposed(by: disposeBag)
        
        self.viewModel.fetchAnimesSubject
            .observeOn(MainScheduler.instance)
            .subscribe({ [weak self] _ in
                guard let self = self else { return }
                self.shouldShowProgress(false)
                self.infoTableManager?.reloadData()
            }).disposed(by: disposeBag)
        
        let tap = UITapGestureRecognizer()
        self.favoriteListButton.addGestureRecognizer(tap)
        self.favoriteListButton.isUserInteractionEnabled = true
        tap.rx.event
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(onNext: {[weak self] recognizer in
                guard let self = self else { return }
                let vc = FavoriteTableViewController.init(viewModel: self.viewModel)
                self.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: self.disposeBag)
    }
    
}
