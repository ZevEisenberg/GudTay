//
//  DrawingTests.swift
//  GudTayTests
//
//  Created by Zev Eisenberg on 12/31/18.
//

@testable import GudTay
import SnapshotTesting
import XCTest

private let size = CGSize(width: 200, height: 100)
private var result: UIImage?

class DrawingTests: XCTestCase {

    let sut = DoodleViewModel(size: size, persistence: .inMemory)

    override func setUp() {
        sut.newImageCallback = { result = $0 }
        sut.loadPersistedImage()
    }

    func testEmptyDrawing() {
        assertSnapshot(matching: result!, as: .image)
    }

    func testPoint() {
        sut.startAt(CGPoint(x: 20, y: 30))
        sut.endAt(CGPoint(x: 20, y: 30))
        assertSnapshot(matching: result!, as: .image)
    }

    func testLine() {
        sut.startAt(CGPoint(x: 20, y: 30))
        sut.endAt(CGPoint(x: 40, y: 40))
        assertSnapshot(matching: result!, as: .image)
    }

    func testDrawAZee() {
        // recorded by drawing in the view
        sut.startAt(CGPoint(x: 10.5, y: 12.5))
        sut.continueTo(CGPoint(x: 12.0, y: 12.5))
        sut.continueTo(CGPoint(x: 14.0, y: 12.5))
        sut.continueTo(CGPoint(x: 25.0, y: 12.5))
        sut.continueTo(CGPoint(x: 35.0, y: 12.5))
        sut.continueTo(CGPoint(x: 40.5, y: 12.5))
        sut.continueTo(CGPoint(x: 44.5, y: 12.5))
        sut.continueTo(CGPoint(x: 46.5, y: 12.5))
        sut.continueTo(CGPoint(x: 47.0, y: 12.5))
        sut.continueTo(CGPoint(x: 47.5, y: 12.5))
        sut.continueTo(CGPoint(x: 47.0, y: 13.5))
        sut.continueTo(CGPoint(x: 42.5, y: 17.0))
        sut.continueTo(CGPoint(x: 34.5, y: 22.5))
        sut.continueTo(CGPoint(x: 29.0, y: 26.5))
        sut.continueTo(CGPoint(x: 21.5, y: 32.5))
        sut.continueTo(CGPoint(x: 16.5, y: 36.0))
        sut.continueTo(CGPoint(x: 13.5, y: 39.0))
        sut.continueTo(CGPoint(x: 11.0, y: 41.0))
        sut.continueTo(CGPoint(x: 10.0, y: 42.5))
        sut.continueTo(CGPoint(x: 9.5, y: 43.5))
        sut.continueTo(CGPoint(x: 9.5, y: 44.0))
        sut.continueTo(CGPoint(x: 11.0, y: 44.0))
        sut.continueTo(CGPoint(x: 15.5, y: 43.5))
        sut.continueTo(CGPoint(x: 23.5, y: 42.5))
        sut.continueTo(CGPoint(x: 31.5, y: 42.5))
        sut.continueTo(CGPoint(x: 38.0, y: 42.0))
        sut.continueTo(CGPoint(x: 43.5, y: 42.0))
        sut.continueTo(CGPoint(x: 47.0, y: 42.0))
        sut.continueTo(CGPoint(x: 48.0, y: 42.0))
        sut.continueTo(CGPoint(x: 49.0, y: 42.0))
        sut.endAt(CGPoint(x: 49.5, y: 42.0))
        assertSnapshot(matching: result!, as: .image)
    }

}
