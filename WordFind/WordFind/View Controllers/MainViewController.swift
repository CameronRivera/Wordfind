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
    private var direction = Direction.north
    private var directionDetermined: Bool = false
    
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
            
            let letterTuple = self?.mainView.rowsAndColumns(indexPath.row) ?? (0,0)
            
            xCell.letterLabel.text = self?.mainView.getMatrixLetter(row: letterTuple.0, column: letterTuple.1)
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
    
    private func clearInput() {
        currentWord = ""
        mainView.currentWordLabel.text = currentWord
        directionDetermined = false
        currentIndexPath = IndexPath()
    }
    
    private func updateUI(_ path: IndexPath) {
        let posTuple = mainView.rowsAndColumns(path.row)
        currentWord += mainView.getMatrixLetter(row: posTuple.row, column: posTuple.col)
        mainView.currentWordLabel.text = currentWord
        currentIndexPath = path
    }
    
    @objc
    private func resetInputButtonPressed(_ sender: UIButton) {
        clearInput()
    }
    
    @objc
    private func directionsButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
    @objc
    private func submitButtonPressed(_ sender: UIButton) {
        if mainView.isWordInBank(currentWord) {
            showAlert("Well Done", "You found the word \(currentWord.lowercased())! It will be removed from the word bank.", "Ok") { [unowned self] alertAction in
                self.mainView.removeWordFromBank(self.currentWord)
                self.clearInput()
            }

        } else {
            showAlert("Oops", "\(currentWord.lowercased()) is not one of the words in the word bank. Keep searching.", "Ok")
        }
    }
    
    @objc
    private func playAgainButtonPressed(_ sender: UIBarButtonItem) {
        showAlert("Play Again?", nil, "Yes", "No") { [unowned self] alertAction in
            self.clearInput()
            self.mainView.resetWordBank()
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if currentWord.count >= 1 && !directionDetermined {
            
            direction = mainView.determineDirection(currentIndexPath.row, indexPath.row)
            directionDetermined = true

            updateUI(indexPath)
            
        } else if !directionDetermined{
            updateUI(indexPath)
        } else if currentWord.count > 1 && mainView.isValidSelection(currentIndexPath.row, indexPath.row, direction) {
            updateUI(indexPath)
        } else {
            showAlert("Invalid Input", "If you are uncertain about which letters you can tap from this point, then try tapping the instructions button in the top right corner of the screen for help.")
        }
    }
}
