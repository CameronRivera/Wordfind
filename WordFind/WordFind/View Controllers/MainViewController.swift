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
        dataSource = DataSource(collectionView: mainView.collectionView, cellProvider: { [weak self] (collectionView, indexPath, string) -> UICollectionViewCell? in
            
            guard let xCell = collectionView.dequeueReusableCell(withReuseIdentifier: LetterCell.reuseIdentifier, for: indexPath) as? LetterCell else {
                fatalError("Could not dequeue UICollectionViewCell as a LetterCell.")
            }
            
            let letterTuple = self?.mainView.rowsAndColumns(indexPath.row) ?? (0,0)
            
            xCell.letterLabel.text = self?.mainView.getMatrixLetter(row: letterTuple.0, column: letterTuple.1)
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
        let instructions = """
The objective of this game is to find all of the words in the word bank within the letter grid shown on the screen. The rules are quite simple:
1. The first letter you choose can be any letter in the grid.
2. The second letter you choose may only be one of the letters in any direction immediately touching the first letter. In other words, the second letter must be a diagonal, above, below, to the immediate left, or to the immediate right of the first letter.
3. Once you have chosen a second letter, any subsequent letters you choose must be in the same direction. So for example, if the second letter I choose is in the square directly above the first letter, the third letter must be in the square directly above the second letter, and so on. Any other choice is invalid.

Some things to note:
- As you choose letters, they will appear below the letter grid, so you need not necessarily keep track of which letters you have chosen.
- If you feel that you have found a word contained within the word bank, click the submit button to check it. If it is indeed contained within the word bank, the word will be removed, and you'll have the chance to look for additional words.
- If you make a mistake, you can press the clear button on the bottom left of the screen to clear your selection and start over again.
- At any time you can press the play again button in the top left corner of the screen in order to reset the game.

With that you know everything there is to know. Have fun!
"""
        showAlert("Instructions", instructions)
    }
    
    @objc
    private func submitButtonPressed(_ sender: UIButton) {
        guard !currentWord.isEmpty else { return }
        if mainView.isWordInBank(currentWord) && mainView.wordBank.text.contains(currentWord.lowercased()) {
            showAlert("Well Done", "You found the word \(currentWord.lowercased())! It will be removed from the word bank.", "Ok") { [unowned self] alertAction in
                self.mainView.removeWordFromBank(self.currentWord)
                self.clearInput()
                if self.mainView.wordBank.text == "" {
                    self.showAlert("Congratulations!", "You win.🥳 Play again?", "Yes", "No") { [unowned self] alertAction in
                        self.mainView.resetWordBank()
                    }
                }
            }
        } else if mainView.isWordInBank(currentWord) && !mainView.wordBank.text.contains(currentWord.lowercased()) {
            showAlert("Oops", "It looks like you have already found this word. Take a look at the word bank to see which ones you have yet to find.") { [unowned self] alertAction in
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
