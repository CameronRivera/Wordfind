//
//  GameLogic.swift
//  WordFind
//
//  Created by Cameron Rivera on 9/8/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

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

class GameLogic {
    
    public let gameInstructions = """
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
    private var column: Int = 0
    private var currentWord: String = ""
    private var currentIndexPath: IndexPath = IndexPath()
    private var direction = Direction.north
    private var directionDetermined: Bool = false
    
    static public var manager = GameLogic()
    
    private init() {}
    
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
    
    public func removeWordFromBank(_ word: String, _ wordBank: UITextView) {
        wordBank.text = wordBank.text.replacingOccurrences(of: "\(word.lowercased()) ", with: "")
    }
    
    public func resetWordBank(_ wordBank: UITextView) {
        wordBank.text = wordBankSet.reduce("", { (result, word) -> String in
            return result + word + " "
        })
    }
    
    public func clearInput(_ label: UILabel) {
        currentWord = ""
        label.text = currentWord
        directionDetermined = false
        currentIndexPath = IndexPath()
    }
    
    public func appendToCurrentWord(_ str: String) {
        currentWord += str
    }
    
    public func getCurrentWord() -> String {
        return currentWord
    }
    
    public func getCurrentIndexPath() -> IndexPath {
        return currentIndexPath
    }
    
    public func setCurrentIndexPath(_ path: IndexPath) {
        currentIndexPath = path
    }
    
    public func getDirectionDetermined() -> Bool {
        return directionDetermined
    }
    
    public func setDirectionDetermined(_ value: Bool) {
        directionDetermined = value
    }
    
    public func getDirection() -> Direction {
        return direction
    }
    
    public func setDirection(_ orientation: Direction) {
        direction = orientation
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
