//
//  FilterFloatingButton.swift
//  collectionViewDemo
//
//  Created by Terry Kuo on 2022/6/20.
//

import UIKit

class FilterFloatingButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
//        translatesAutoresizingMaskIntoConstraints = false
        setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)), for: .normal)
//        setTitle("  Share", for: .normal)
//        setTitleColor(.black, for: .normal)
        tintColor = .black
        layer.cornerRadius = 25
//        titleLabel?.font =  UIFont.systemFont(ofSize: 18, weight: .heavy)
        backgroundColor = .white.withAlphaComponent(0.8)
        
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 15
        layer.shadowOpacity = 0.3
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
