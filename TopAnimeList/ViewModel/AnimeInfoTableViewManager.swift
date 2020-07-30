//
//  AnimeInfoTableViewManager.swift
//  TopAnimeList
//
//  Created by Kyle on 2020/7/25.
//  Copyright © 2020 Kyle. All rights reserved.
//

import UIKit

class AnimeInfoTableViewManager: NSObject {
    
    private var tableView:UITableView
    weak var viewModel:MainPageViewModel?
    weak var hostViewController:UIViewController?
    
    init(_ tableView:UITableView,_ model:MainPageViewModel) {
        self.tableView = tableView
        self.viewModel = model
        super.init()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "AnimeInfoCell", bundle: nil), forCellReuseIdentifier: "AnimeInfoCell")
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func clearData() {
        self.viewModel?.topAnimeInfos.removeAll()
        self.viewModel?.page = 1
        self.tableView.reloadData()
    }

}

//MARK: UITableView Delegate
extension AnimeInfoTableViewManager : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellModel = self.viewModel!.topAnimeInfos[indexPath.row]
        cellModel.didSelected()
    }
}

//MARK: UITableView DataSource
extension AnimeInfoTableViewManager : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel!.topAnimeInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellModel = self.viewModel!.topAnimeInfos[indexPath.row]
        cellModel.indexPath = indexPath
        cellModel.hostViewController = self.hostViewController
        
        // Use BaseCell as basic type.
        let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.identifier, for: indexPath) as! BaseCell
        cell.setData(cellModel)
        
        // load more if need
        self.viewModel?.loadMoreIfNeed(indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let cellModel = self.viewModel!.topAnimeInfos[indexPath.row]
        
        return cellModel.cellHeight()
    }
}
