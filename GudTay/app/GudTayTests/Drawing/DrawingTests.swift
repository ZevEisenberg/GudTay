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
private var result: CGImage?

extension Snapshotting where Value == CGImage, Format == UIImage {
    public static let cgImage: Snapshotting =
        Snapshotting<UIImage, UIImage>.image.pullback { cgImage in UIImage(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .up) }
}

class DrawingTests: XCTestCase {

    let sut = DoodleViewModel(size: size, persistence: .inMemory)

    override func setUp() {
        sut.newImageCallback = { (image, kind) in result = image }
        sut.loadPersistedImage()
    }

    func testEmptyDrawing() {
        assertSnapshot(matching: result!, as: .cgImage)
    }

    func testPoint() {
        sut.startAt(CGPoint(x: 20, y: 30))
        sut.endAt(CGPoint(x: 20, y: 30))
        assertSnapshot(matching: result!, as: .cgImage)
    }

    func testLine() {
        sut.startAt(CGPoint(x: 20, y: 30))
        sut.endAt(CGPoint(x: 40, y: 40))
        assertSnapshot(matching: result!, as: .cgImage)
    }

    func testDrawAZee() {
        // recorded by drawing in the view
        sut.startAt(CGPoint(x: 10.5, y: 12.5))
        let continueTo = { (x: Double, y: Double) in self.sut.continueTo(CGPoint(x: x, y: y)) }
        continueTo(12.0, 12.5)
        continueTo(14.0, 12.5)
        continueTo(25.0, 12.5)
        continueTo(35.0, 12.5)
        continueTo(40.5, 12.5)
        continueTo(44.5, 12.5)
        continueTo(46.5, 12.5)
        continueTo(47.0, 12.5)
        continueTo(47.5, 12.5)
        continueTo(47.0, 13.5)
        continueTo(42.5, 17.0)
        continueTo(34.5, 22.5)
        continueTo(29.0, 26.5)
        continueTo(21.5, 32.5)
        continueTo(16.5, 36.0)
        continueTo(13.5, 39.0)
        continueTo(11.0, 41.0)
        continueTo(10.0, 42.5)
        continueTo(9.5, 43.5)
        continueTo(9.5, 44.0)
        continueTo(11.0, 44.0)
        continueTo(15.5, 43.5)
        continueTo(23.5, 42.5)
        continueTo(31.5, 42.5)
        continueTo(38.0, 42.0)
        continueTo(43.5, 42.0)
        continueTo(47.0, 42.0)
        continueTo(48.0, 42.0)
        continueTo(49.0, 42.0)
        sut.endAt(CGPoint(x: 49.5, y: 42.0))
        assertSnapshot(matching: result!, as: .cgImage)
    }

    func testExtraEndBit() {
        sut.startAt(CGPoint(x: 14.0, y: 19.5))
        let continueTo = { (x: Double, y: Double) in self.sut.continueTo(CGPoint(x: x, y: y)) }
        continueTo(14.0, 21.0)
        continueTo(14.0, 24.5)
        continueTo(14.0, 31.5)
        continueTo(14.0, 40.0)
        sut.endAt(CGPoint(x: 14.0, y: 46.0))
        assertSnapshot(matching: result!, as: .cgImage)
    }

}
