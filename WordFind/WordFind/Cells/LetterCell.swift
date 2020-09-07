//
//  LetterCell.swift
//  WordFind
//
//  Created by Cameron Rivera on 9/6/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

class LetterCell: UICollectionViewCell {
    
    static let reuseIdentifier = "letterCell"
    
    public lazy var letterLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = UIColor.black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setUpLetterLabelConstraints()
    }
    
    private func setUpLetterLabelConstraints() {
        addSubview(letterLabel)
        letterLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([letterLabel.centerYAnchor.constraint(equalTo: centerYAnchor), letterLabel.centerXAnchor.constraint(equalTo: centerXAnchor), letterLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8), letterLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8)])
    }
    
}
