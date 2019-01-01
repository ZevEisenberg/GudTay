//
//  ArrayOfPointsTests.swift
//  GudTayTests
//
//  Created by Zev Eisenberg on 1/1/19.
//

@testable import GudTay
import XCTest

class ArrayOfPointsTests: XCTestCase {

    func testDegenerateCase() {
        let points = [CGPoint.zero]
        XCTAssertFalse(points.movesMoreThanOnePt)
    }

    func testAllZeroes() {
        let points = [CGPoint.zero, .zero, .zero, .zero]
        XCTAssertFalse(points.movesMoreThanOnePt)
    }

    func testLastOneMoves() {
        let points = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 0),
            CGPoint(x: 1, y: 1),
        ]
        XCTAssertTrue(points.movesMoreThanOnePt)
    }

    func testSecondOneMoves() {
        let points = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 1, y: 1),
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 0),
            ]
        XCTAssertTrue(points.movesMoreThanOnePt)
    }

    func testMiddleOnesMoves() {
        let points = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 1, y: 1),
            CGPoint(x: 1, y: 1),
            CGPoint(x: 0, y: 0),
            ]
        XCTAssertTrue(points.movesMoreThanOnePt)
    }

    func testLargeNumbersButNoneMove() {
        let points = Array(repeating: CGPoint(x: 300, y: 300), count: 4)
        XCTAssertFalse(points.movesMoreThanOnePt)
    }

    func testRandomMoves() {
        let points = [
            CGPoint(x: 237, y: 581),
            CGPoint(x: 562, y: 6529),
            CGPoint(x: 765423, y: 3),
            ]
        XCTAssertTrue(points.movesMoreThanOnePt)
    }

}
