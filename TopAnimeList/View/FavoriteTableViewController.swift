//
//  FavoriteTableViewController.swift
//  TopAnimeList
//
//  Created by Kyle on 2020/7/26.
//  Copyright © 2020 Kyle. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FavoriteTableViewController: UITableViewController, BlackNavigationStyle {
    
    let disposeBag = DisposeBag()
    var navTitle: String = "Favorite Page"
    weak var viewModel:MainPageViewModel?
    
    lazy var emptyView:UIImageView = {
        var view = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        view.image = UIImage(named: "heartOff")?.withTintColor(.red)
        view.center = self.view.center
        self.view.addSubview(view)
        return view
    }()
    
    convenience init(viewModel:MainPageViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigation()
        self.setupView()
        self.bind()
    }
    
    private func setupView() {
        self.tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "AnimeInfoCell", bundle: nil), forCellReuseIdentifier: "AnimeInfoCell")
        
        self.emptyView.isHidden = self.viewModel!.favoriteAnimeInfos.count > 0
    }
    
    private func bind() {
        self.viewModel?.favoriteStateSubject
            .observeOn(MainScheduler.instance)
            .subscribe({ [weak self] index in
                guard let self = self else { return }
                guard let index = index.element else { return }
                if index < 0 { return }
                
                let indexPath = IndexPath(item: index, section: 0)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                
            }).disposed(by: disposeBag)
    }
    
    //MARK: UITableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellModel = Array(self.viewModel!.favoriteAnimeInfos)[indexPath.row]
        cellModel.didSelected()
    }
    
    //MARK: UITableView DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel!.favoriteAnimeInfos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellModel = Array(self.viewModel!.favoriteAnimeInfos)[indexPath.row]
        cellModel.indexPath = indexPath
        cellModel.hostViewController = self
        
        // Use BaseCell as basic type.
        let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.identifier, for: indexPath) as! BaseCell
        cell.setData(cellModel)
        
        // load more if need
        self.viewModel?.loadMoreIfNeed(indexPath.row)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let cellModel = Array(self.viewModel!.favoriteAnimeInfos)[indexPath.row]
        
        return cellModel.cellHeight()
    }
}
