//
//  OpacityTests.swift
//  MultiplyItTests
//
//  Created by Nowroz Islam on 1/7/23.
//

import XCTest
@testable import MultiplyIt

final class OpacityTests: XCTestCase {
    func testNoSelectedTableOpacity() {
        // Arrange
        let selected: Int? = nil
        let supposedOpacity = 1.0
        let dummyTable = 2
        
        // Act
        let opacity = Selection.getOpacity(of: dummyTable, when: selected)
        
        // Assert
        XCTAssertEqual(supposedOpacity, opacity)
    }
    
    func testSelectedTableOpacity() {
        // Arrange
        let selected: Int? = 5
        let table = 5
        let supposedOpacity = 1.0
        
        // Act
        let opacity = Selection.getOpacity(of: table, when: selected)
        
        // Assert
        XCTAssertEqual(supposedOpacity, opacity)
    }
}
