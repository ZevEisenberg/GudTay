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

}
