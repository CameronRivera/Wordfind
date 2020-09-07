//
//  MainView.swift
//  WordFind
//
//  Created by Cameron Rivera on 9/6/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

typealias DataSource = UICollectionViewDiffableDataSource<Section,Int>

enum Section {
    case main
}

class MainView: UIView {
    
    private let contentMatrix: [[String]] = [["S","E","T","A","R","E","N","E","G","B"], ["W","P","N","D","Z","C","A","I","R","N"],
    ["T","V","M","R","J","U","G","X","P","I"],
    ["Q","E","A","H","Y","A","T","H","C","L"],
    ["D","S","Z","R","N","F","V","Y","Q","T"],
    ["H","R","E","L","I","U","S","A","V","O"],
    ["F","T","A","W","E","A","N","X","P","K"],
    ["W","G","L","F","M","O","B","I","L","E"],
    ["B","P","C","U","T","W","U","L","H","T"],
    ["O","B","J","E","C","T","I","V","E","C"]]
    private let wordBankSet: Set<String> = ["objectivec", "kotlin", "swift", "variable", "java", "mobile", "maze", "zeal", "sew", "cut", "draft", "cult", "cairn", "note", "generate"]
    
    public lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: configureLayout())
        collectionView.register(LetterCell.self, forCellWithReuseIdentifier: LetterCell.reuseIdentifier)
        collectionView.backgroundColor = UIColor.systemTeal
        return collectionView
    }()
    
    public lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = UIColor.systemOrange
        return scrollView
    }()
    
    public lazy var wordBank: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = false
        textView.text = wordBankSet.reduce("", { (result, word) -> String in
            return result + word + " "
        })
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1.0
        return textView
    }()
    
    public lazy var wordBankLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.text = "Word Bank"
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let screenSize = UIScreen.main.bounds.size
        scrollView.contentSize = CGSize(width: screenSize.width, height: screenSize.height * 2.0)
    }
    
    private func commonInit() {
        backgroundColor = UIColor.systemBackground
        setUpScrollViewConstraints()
        setUpCollectionViewConstraints()
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
        
        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor), collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor), collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor), collectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6)])
    }
    
    private func setUpWordBankConstraints() {
        scrollView.addSubview(wordBank)
        wordBank.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([wordBank.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20), wordBank.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8), wordBank.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8), wordBank.heightAnchor.constraint(equalToConstant: 100)])
    }
    
    private func setUpWordBankLabelConstraints() {
        scrollView.addSubview(wordBankLabel)
        wordBankLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([wordBankLabel.topAnchor.constraint(equalTo: wordBank.bottomAnchor, constant: 20), wordBankLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8), wordBankLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8)])
    }
    
    private func configureLayout() -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout { (section, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            // Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.1), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            
            // Group
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.1))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }
        
        // layout
        return layout
    }
    
    public func getMatrixLetter(row: Int, column: Int) -> String {
        guard row < 10 && column < 10 else { return "1" }
        return contentMatrix[column][row]
    }
    
    public func rowsAndColumns(_ x: Int) -> (row: Int, col: Int) {
        var column = 0
        var row = x
        
        while row >= 10 {
            row -= 10
            column += 1
        }
        
        return (row,column)
    }
    
    public func isWordInBank(_ word: String) -> Bool {
        return wordBankSet.contains(word.lowercased())
    }
    
    public func removeWordFromBank(_ word: String) {
        wordBank.text = wordBank.text.replacingOccurrences(of: "\(word.lowercased()) ", with: "")
    }

}
