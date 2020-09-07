//
//  ViewController.swift
//  WordFind
//
//  Created by Cameron Rivera on 9/6/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    private let mainView = MainView()
    private var dataSource: DataSource!
    private var column: Int = 0
    private var currentWord: String = ""
    private var currentIndexPath: IndexPath = IndexPath()
    private var firstTap: Bool = true
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureButtons()
        configureDataSource()
    }
    
    private func configureUI() {
        navigationItem.title = "WordFind"
        navigationItem.rightBarButtonItem = mainView.directionsButton
        navigationItem.leftBarButtonItem = mainView.playAgainButton
    }
    
    private func configureButtons() {
        mainView.playAgainButton.target = self
        mainView.directionsButton.target = self
        mainView.playAgainButton.action = #selector(playAgainButtonPressed(_:))
        mainView.directionsButton.action = #selector(directionsButtonPressed(_:))
        mainView.submitButton.addTarget(self, action: #selector(submitButtonPressed(_:)), for: .touchUpInside)
        mainView.resetInputButton.addTarget(self, action: #selector(resetInputButtonPressed(_:)), for: .touchUpInside)
        
    }
    
    private func configureDataSource() {
        mainView.collectionView.delegate = self
        dataSource = DataSource(collectionView: mainView.collectionView, cellProvider: { [weak self] (collectionView, indexPath, string) -> UICollectionViewCell? in
            
            guard let xCell = collectionView.dequeueReusableCell(withReuseIdentifier: LetterCell.reuseIdentifier, for: indexPath) as? LetterCell else {
                fatalError("Could not dequeue UICollectionViewCell as a LetterCell.")
            }
            
            if indexPath.row > 0 && indexPath.row % 10 == 0 {
                self?.column += 1
            }
            
            xCell.letterLabel.text = self?.mainView.getMatrixLetter(row: indexPath.row % 10, column: self?.column ?? 0)
            xCell.backgroundColor = UIColor.systemYellow
            xCell.layer.borderColor = UIColor.black.cgColor
            xCell.layer.borderWidth = 1.0
            
            return xCell
        })
        
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(1...100), toSection: .main)
        dataSource.apply(snapshot)
    }
    
    @objc
    private func resetInputButtonPressed(_ sender: UIButton) {
        currentWord = ""
        mainView.currentWordLabel.text = currentWord
        firstTap = true
        currentIndexPath = IndexPath()
    }
    
    @objc
    private func directionsButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
    @objc
    private func submitButtonPressed(_ sender: UIButton) {
        
    }
    
    @objc
    private func playAgainButtonPressed(_ sender: UIBarButtonItem) {
        
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let posTuple = mainView.rowsAndColumns(indexPath.row)
        currentWord += mainView.getMatrixLetter(row: posTuple.row, column: posTuple.col)
        mainView.currentWordLabel.text = currentWord
        if mainView.isWordInBank(currentWord) {
            mainView.removeWordFromBank(currentWord)
        }
    }
}
