//
//  WordFindTests.swift
//  WordFindTests
//
//  Created by Cameron Rivera on 9/6/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import XCTest
@testable import WordFind

class WordFindTests: XCTestCase {
    
    let view = MainView()
    let manager = GameLogic.manager
    
    func testGetMatrixLetter() {
        // Arrange
        let expectedLetter = "X"
        
        // Act
        let actualLetter = manager.getMatrixLetter(row: 2, column: 7)
        
        // Assert
        XCTAssertEqual(expectedLetter, actualLetter)
    }
    
    func testRowsAndColumns() {
        // Arrange
        let expectedRowColumnTuple = (2,6)
        
        // Act
        let actualTuple = manager.rowsAndColumns(62)
        
        // Assert
        XCTAssertEqual(expectedRowColumnTuple.0, actualTuple.0)
        XCTAssertEqual(expectedRowColumnTuple.1, actualTuple.1)
    }
    
    func testIsInWordBank() {
        // Arrange
        let testWord = "cairn"
        
        // Act
        
        
        // Assert
        XCTAssertTrue(manager.isWordInBank(testWord))
    }
    
    func testRemoveWordFromBank() {
        // Arrange
        let testWord = "cost"
        
        // Act
        manager.removeWordFromBank(testWord, view.wordBank)
        
        // Assert
        XCTAssertFalse(view.wordBank.text.contains(testWord))
        
    }
    
    func testResetWordBank() {
        // Arrange
        let wordInBank = "generate"
        
        // Act
        view.wordBank.text = ""
        manager.resetWordBank(view.wordBank)
        
        // Assert
        XCTAssertTrue(view.wordBank.text.contains(wordInBank))
    }
    
    func testDetermineDirection() {
        // Arrange
        let targetDirection = Direction.northWest
        
        // Act
        let actualDirection = manager.determineDirection(27, 16)
        
        // Assert
        XCTAssertEqual(targetDirection, actualDirection)
    }
    
    func testIsValidSelection() {
        // Arrange
        let targetDirection = Direction.northWest
        let old = 27
        let new = 16
        
        // Act
        let result = manager.isValidSelection(old, new, targetDirection)
        
        // Assert
        XCTAssertTrue(result)
    }
    
}
