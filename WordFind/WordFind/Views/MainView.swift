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

enum Direction {
    case north
    case south
    case east
    case west
    case northEast
    case northWest
    case southEast
    case southWest
    case none
}

class MainView: UIView {
    
    private let contentMatrix: [[String]] = [["S","E","T","A","R","E","N","E","G","B"], ["W","P","N","O","Z","C","A","I","R","N"],
    ["T","V","M","R","J","U","G","X","P","I"],
    ["Q","E","A","H","Y","A","T","H","C","L"],
    ["D","S","Z","R","N","F","V","Y","Q","T"],
    ["H","R","E","L","I","U","S","A","V","O"],
    ["F","T","A","W","E","A","N","X","P","K"],
    ["W","G","S","F","M","O","B","I","L","E"],
    ["B","P","C","O","T","W","U","L","H","T"],
    ["O","B","J","E","C","T","I","V","E","C"]]
    private let wordBankSet: Set<String> = ["objectivec", "kotlin", "swift", "variable", "java", "mobile", "maze", "rash", "sew", "rome", "draft", "cost", "cairn", "note", "generate"]
    
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
        button.setTitle("Submit Guess", for: .normal)
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
        scrollView.contentSize = CGSize(width: screenSize.width, height: screenSize.height * 1.1)
    }
    
    private func commonInit() {
        backgroundColor = UIColor.systemBackground
        resetWordBank()
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
    
    public func getMatrixLetter(row: Int, column: Int) -> String {
        guard row < 10 && column < 10 else { return "1" }
        return contentMatrix[row][column]
    }
    
    public func rowsAndColumns(_ x: Int) -> (row: Int, col: Int) {
        var column = 0
        var row = x
        
        while row >= 10 {
            row -= 10
            column += 1
        }
        
        return (row, column)
    }
    
    public func isWordInBank(_ word: String) -> Bool {
        return wordBankSet.contains(word.lowercased())
    }
    
    public func removeWordFromBank(_ word: String) {
        wordBank.text = wordBank.text.replacingOccurrences(of: "\(word.lowercased()) ", with: "")
    }
    
    public func resetWordBank() {
        wordBank.text = wordBankSet.reduce("", { (result, word) -> String in
            return result + word + " "
        })
    }
    
    public func determineDirection(_ former: Int, _ current: Int) -> Direction {
        let difference = current - former
        
        switch difference {
        case -11:
            return Direction.northWest
        case -10:
            return Direction.north
        case -9:
            return Direction.northEast
        case 1:
            return Direction.east
        case 11:
            return Direction.southEast
        case 10:
            return Direction.south
        case 9:
            return Direction.southWest
        case -1:
            return Direction.west
        default:
            return Direction.none
        }
    }
    
    public func isValidSelection(_ old: Int, _ new: Int, _ direction: Direction) -> Bool {
        
        guard old != new else { return false }
        
        let oldTuple = rowsAndColumns(old)
        let newTuple = rowsAndColumns(new)
        
        switch direction {
        case .northEast where newTuple.row == oldTuple.row + 1 && newTuple.col == oldTuple.col - 1:
            return true
        case .north where newTuple.col == oldTuple.col - 1 && newTuple.row == oldTuple.row:
            return true
        case .northWest where newTuple.row == oldTuple.row - 1 && newTuple.col == oldTuple.col - 1:
            return true
        case .east where newTuple.row == oldTuple.row + 1 && newTuple.col == oldTuple.col:
            return true
        case .southEast where newTuple.row == oldTuple.row + 1 && newTuple.col == oldTuple.col + 1:
            return true
        case .south where newTuple.col == oldTuple.col + 1 && newTuple.row == oldTuple.row:
            return true
        case .southWest where newTuple.row == oldTuple.row - 1 && newTuple.col == oldTuple.col + 1:
            return true
        case .west where newTuple.row == oldTuple.row - 1 && newTuple.col == oldTuple.col:
            return true
        default:
            return false
        }
    }

}
