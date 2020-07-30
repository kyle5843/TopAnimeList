//
//  TypeCollectionCell.swift
//  TopAnimeList
//
//  Created by Kyle on 2020/7/25.
//  Copyright © 2020 Kyle. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TypeCollectionCell: UICollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    lazy var label:UIButton = {
        
        let button = UIButton.init(frame: self.bounds)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5), for: UIControl.State.normal)
        button.titleLabel?.textAlignment = .center
        button.isUserInteractionEnabled = false
        button.titleLabel?.layer.cornerRadius = 5
        button.titleLabel?.layer.masksToBounds = true
        button.titleLabel?.layer.borderWidth = 2
        button.titleLabel?.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        return button
    }()
    
    lazy var selectedBar:CALayer = {
        let bar = CALayer.init()
        bar.frame = CGRect(x: 0, y: self.bounds.height - 2, width: self.bounds.width, height: 2)
        bar.backgroundColor = #colorLiteral(red: 0, green: 0.7473191619, blue: 0, alpha: 1)
        bar.isHidden = true
        return bar
    }()
    
    var model:AnimeTypeModel? {
        didSet {
            guard let model = model else { return }
            self.bindModel()
            self.label.setTitle("\(model.type)　", for: UIControl.State.normal)
            self.isSelected = model.isSelected.value
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        DispatchQueue.main.async {
            self.addSubview(self.label)
            self.label.layer.addSublayer(self.selectedBar)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func bindModel(){
        self.disposeBag = DisposeBag()
        
        self.model?.isSelected.asDriver()
            .drive(onNext: { [weak self] (isSelected) in
                guard let self = self else { return }
                let color = isSelected ? #colorLiteral(red: 0, green: 0.7473191619, blue: 0, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
                self.isSelected = isSelected
                self.selectedBar.isHidden = !isSelected
                self.label.setTitleColor(color, for: UIControl.State.normal)
                self.label.titleLabel?.layer.borderColor = color.cgColor
            }).disposed(by: disposeBag)
    }
}
