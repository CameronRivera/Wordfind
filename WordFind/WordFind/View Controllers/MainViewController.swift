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
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8274509804, green: 0.8274509804, blue: 0.8274509804, alpha: 1)
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
        dataSource = DataSource(collectionView: mainView.collectionView, cellProvider: { (collectionView, indexPath, string) -> UICollectionViewCell? in
            
            guard let xCell = collectionView.dequeueReusableCell(withReuseIdentifier: LetterCell.reuseIdentifier, for: indexPath) as? LetterCell else {
                fatalError("Could not dequeue UICollectionViewCell as a LetterCell.")
            }
            
            let letterTuple = GameLogic.manager.rowsAndColumns(indexPath.row)
            
            xCell.letterLabel.text = GameLogic.manager.getMatrixLetter(row: letterTuple.0, column: letterTuple.1)
            xCell.backgroundColor = #colorLiteral(red: 0.5, green: 1, blue: 1, alpha: 1)
            xCell.layer.borderColor = UIColor.black.cgColor
            xCell.layer.borderWidth = 1.0
            
            return xCell
        })
        
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(1...100), toSection: .main)
        dataSource.apply(snapshot)
    }
    
    private func updateUI(_ path: IndexPath) {
        let posTuple = GameLogic.manager.rowsAndColumns(path.row)
        GameLogic.manager.appendToCurrentWord(GameLogic.manager.getMatrixLetter(row: posTuple.row, column: posTuple.col)) 
        mainView.currentWordLabel.text = GameLogic.manager.getCurrentWord()
        GameLogic.manager.setCurrentIndexPath(path)
    }
    
    @objc
    private func resetInputButtonPressed(_ sender: UIButton) {
        GameLogic.manager.clearInput(mainView.currentWordLabel)
    }
    
    @objc
    private func directionsButtonPressed(_ sender: UIBarButtonItem) {
        showAlert("Instructions", GameLogic.manager.gameInstructions)
    }
    
    @objc
    private func submitButtonPressed(_ sender: UIButton) {
        guard !GameLogic.manager.getCurrentWord().isEmpty else { return }
        if GameLogic.manager.isWordInBank(GameLogic.manager.getCurrentWord()) && mainView.wordBank.text.contains(GameLogic.manager.getCurrentWord().lowercased()) {
            showAlert("Well Done", "You found the word \(GameLogic.manager.getCurrentWord().lowercased())! It will be removed from the word bank.", "Ok") { [unowned self] alertAction in
                GameLogic.manager.removeWordFromBank(GameLogic.manager.getCurrentWord(), self.mainView.wordBank)
                GameLogic.manager.clearInput(self.mainView.currentWordLabel)
                if self.mainView.wordBank.text == "" {
                    self.showAlert("Congratulations!", "You win.🥳 Play again?", "Yes", "No") { [unowned self] alertAction in
                        GameLogic.manager.resetWordBank(self.mainView.wordBank)
                    }
                }
            }
        } else if GameLogic.manager.isWordInBank(GameLogic.manager.getCurrentWord()) && !mainView.wordBank.text.contains(GameLogic.manager.getCurrentWord().lowercased()) {
            showAlert("Oops", "It looks like you have already found this word. Take a look at the word bank to see which ones you have yet to find.") { [unowned self] alertAction in
                GameLogic.manager.clearInput(self.mainView.currentWordLabel)
            }
        } else {
            showAlert("Oops", "\(GameLogic.manager.getCurrentWord().lowercased()) is not one of the words in the word bank. Keep searching.", "Ok")
        }
    }
    
    @objc
    private func playAgainButtonPressed(_ sender: UIBarButtonItem) {
        showAlert("Play Again?", nil, "Yes", "No") { [unowned self] alertAction in
            GameLogic.manager.clearInput(self.mainView.currentWordLabel)
            GameLogic.manager.resetWordBank(self.mainView.wordBank)
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let currentIndexPath = GameLogic.manager.getCurrentIndexPath()
        
        if GameLogic.manager.getCurrentWord().count >= 1 && !GameLogic.manager.getDirectionDetermined() {
            
            let determinedDirection = GameLogic.manager.determineDirection(currentIndexPath.row, indexPath.row)
            
            GameLogic.manager.setDirection(determinedDirection)
            GameLogic.manager.setDirectionDetermined(true)

            updateUI(indexPath)
            
        } else if !GameLogic.manager.getDirectionDetermined(){
            updateUI(indexPath)
        } else if GameLogic.manager.getCurrentWord().count > 1 && GameLogic.manager.isValidSelection(currentIndexPath.row, indexPath.row, GameLogic.manager.getDirection()) {
            updateUI(indexPath)
        } else {
            showAlert("Invalid Input", "If you are uncertain about which letters you can tap from this point, then try tapping the instructions button in the top right corner of the screen for help.")
        }
    }
}
