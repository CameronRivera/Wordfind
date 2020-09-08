//
//  MainView.swift
//  WordFind
//
//  Created by Cameron Rivera on 9/6/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

typealias DataSource = UICollectionViewDiffableDataSource<Section,Int>

class MainView: UIView {
    
    
    
    public lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: configureLayout())
        collectionView.register(LetterCell.self, forCellWithReuseIdentifier: LetterCell.reuseIdentifier)
        collectionView.backgroundColor = UIColor.systemTeal
        return collectionView
    }()
    
    public lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = #colorLiteral(red: 0.8274509804, green: 0.8274509804, blue: 0.8274509804, alpha: 1)
        scrollView.bounces = false
        return scrollView
    }()
    
    public lazy var wordBank: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = false
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1.0
        textView.font = UIFont.init(name: "Times New Roman", size: 17)
        return textView
    }()
    
    public lazy var wordBankLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.text = "Word Bank"
        return label
    }()
    
    public lazy var currentWordLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.text = ""
        return label
    }()
    
    public lazy var resetInputButton: UIButton = {
       let button = UIButton()
        button.setTitle("Clear Input", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        return button
    }()
    
    public lazy var submitButton: UIButton = {
       let button = UIButton()
        button.setTitle("Submit Word", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        return button
    }()
    
    public lazy var playAgainButton: UIBarButtonItem = {
       let barButton = UIBarButtonItem()
        barButton.title = "Play Again"
        return barButton
    }()
    
    public lazy var directionsButton: UIBarButtonItem = {
       let barButton = UIBarButtonItem()
        barButton.title = "Instructions"
        return barButton
    }()
    
    public lazy var optionsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let screenSize = UIScreen.main.bounds.size
        scrollView.contentSize = CGSize(width: screenSize.width, height: screenSize.height * 1.01)
    }
    
    private func commonInit() {
        backgroundColor = #colorLiteral(red: 0.8274509804, green: 0.8274509804, blue: 0.8274509804, alpha: 1)
        GameLogic.manager.resetWordBank(wordBank)
        setUpScrollViewConstraints()
        setUpCollectionViewConstraints()
        setUpCurrentWordLabelConstraints()
        setUpWordBankConstraints()
        setUpWordBankLabelConstraints()
    }
    
    private func setUpScrollViewConstraints() {
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor), scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor), scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor), scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)])
    }
    
    private func setUpCollectionViewConstraints() {
        scrollView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: scrollView.topAnchor), collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor), collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor), collectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6)])
    }
    
    private func setUpCurrentWordLabelConstraints() {
        scrollView.addSubview(currentWordLabel)
        currentWordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([currentWordLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20), currentWordLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8), currentWordLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8)])
    }
    
    private func setUpWordBankConstraints() {
        scrollView.addSubview(wordBank)
        wordBank.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([wordBank.topAnchor.constraint(equalTo: currentWordLabel.bottomAnchor, constant: 20), wordBank.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8), wordBank.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8), wordBank.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1)])
    }
    
    private func setUpWordBankLabelConstraints() {
        optionsStack.addArrangedSubview(resetInputButton)
        optionsStack.addArrangedSubview(wordBankLabel)
        optionsStack.addArrangedSubview(submitButton)
        scrollView.addSubview(optionsStack)
        optionsStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([optionsStack.topAnchor.constraint(equalTo: wordBank.bottomAnchor, constant: 20), optionsStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8), optionsStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8)])
    }
    
    private func configureLayout() -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout { (section, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.1), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.1))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }
        
        return layout
    }
}
