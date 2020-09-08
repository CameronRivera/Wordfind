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
    
    func testGetMatrixLetter() {
        // Arrange
        let expectedLetter = "X"
        
        // Act
        let actualLetter = view.getMatrixLetter(row: 2, column: 7)
        
        // Assert
        XCTAssertEqual(expectedLetter, actualLetter)
    }
    
    func testRowsAndColumns() {
        // Arrange
        let expectedRowColumnTuple = (2,6)
        
        // Act
        let actualTuple = view.rowsAndColumns(62)
        
        // Assert
        XCTAssertEqual(expectedRowColumnTuple.0, actualTuple.0)
        XCTAssertEqual(expectedRowColumnTuple.1, actualTuple.1)
    }
    
    func testIsInWordBank() {
        // Arrange
        let testWord = "cairn"
        
        // Act
        
        
        // Assert
        XCTAssertTrue(view.isWordInBank(testWord))
    }
    
    func testRemoveWordFromBank() {
        // Arrange
        let testWord = "cost"
        
        // Act
        view.removeWordFromBank(testWord)
        
        // Assert
        XCTAssertFalse(view.wordBank.text.contains(testWord))
        
    }
    
    func testResetWordBank() {
        // Arrange
        let wordInBank = "generate"
        
        // Act
        view.wordBank.text = ""
        view.resetWordBank()
        
        // Assert
        XCTAssertTrue(view.wordBank.text.contains(wordInBank))
    }
    
    func testDetermineDirection() {
        // Arrange
        let targetDirection = Direction.northWest
        
        // Act
        let actualDirection = view.determineDirection(27, 16)
        
        // Assert
        XCTAssertEqual(targetDirection, actualDirection)
    }
    
    func testIsValidSelection() {
        // Arrange
        let targetDirection = Direction.northWest
        let old = 27
        let new = 16
        
        // Act
        let result = view.isValidSelection(old, new, targetDirection)
        
        // Assert
        XCTAssertTrue(result)
    }
    
}
