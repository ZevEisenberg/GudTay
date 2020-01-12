//
//  MBTAViewTests.swift
//  GudTayTests
//
//  Created by Zev Eisenberg on 1/12/20.
//

@testable import GudTay
import XCTest

class MBTAViewTests: XCTestCase {

    func testNoTrips() {
        let trips = MBTARouteView.UpcomingTrips.none
        let (next, later, afterThat) = trips.strings(forDate: .reference)
        XCTAssertEqual(next, "--")
        XCTAssertEqual(later, "--")
        XCTAssertEqual(afterThat, "--")
    }

    func testTimeOffsetForOneUpcomingTrip() {
        let trips = MBTARouteView.UpcomingTrips.one(next: .oneMinuteAfter)
        let (next, later, afterThat) = trips.strings(forDate: .reference)
        XCTAssertEqual(next, "1")
        XCTAssertEqual(later, "--")
        XCTAssertEqual(afterThat, "--")
    }

    func testTimeOffsetForTwoUpcomingTrips() {
        let trips = MBTARouteView.UpcomingTrips.two(next: .oneMinuteAfter, later: .threeMinutesLater)
        let (next, later, afterThat) = trips.strings(forDate: .reference)
        XCTAssertEqual(next, "1")
        XCTAssertEqual(later, "3")
        XCTAssertEqual(afterThat, "--")
    }

    func testTimeOffsetForThreeUpcomingTrips() {
        let trips = MBTARouteView.UpcomingTrips.three(next: .oneMinuteAfter, later: .threeMinutesLater, afterThat: .fiveMinutesLater)
        let (next, later, afterThat) = trips.strings(forDate: .reference)
        XCTAssertEqual(next, "1")
        XCTAssertEqual(later, "3")
        XCTAssertEqual(afterThat, "5")
    }

    func testTimeOffsetForOneUpcomingTripWithFirstOneEarlierThanNow() {
        let trips = MBTARouteView.UpcomingTrips.one(next: .fortyFiveSecondsBefore)
        let (next, later, afterThat) = trips.strings(forDate: .reference)
        XCTAssertEqual(next, "0")
        XCTAssertEqual(later, "--")
        XCTAssertEqual(afterThat, "--")
    }

    func testTimeOffsetForTwoUpcomingTripsWithFirstOneEarlierThanNow() {
        let trips = MBTARouteView.UpcomingTrips.two(next: .fortyFiveSecondsBefore, later: .threeMinutesLater)
        let (next, later, afterThat) = trips.strings(forDate: .reference)
        XCTAssertEqual(next, "0")
        XCTAssertEqual(later, "5")
        XCTAssertEqual(afterThat, "--")
    }

    func testTimeOffsetForThreeUpcomingTripsWithFirstOneEarlierThanNow() {
        let trips = MBTARouteView.UpcomingTrips.three(next: .fortyFiveSecondsBefore, later: .threeMinutesLater, afterThat: .fiveMinutesLater)
        let (next, later, afterThat) = trips.strings(forDate: .reference)
        XCTAssertEqual(next, "0")
        XCTAssertEqual(later, "5")
        XCTAssertEqual(afterThat, "5")
    }

}

private extension Date {
    static let reference: Date = {
        let comps = DateComponents(
            year: 2020,
            month: 1,
            day: 12,
            hour: 8,
            minute: 0,
            second: 0)
        let cal = Calendar(identifier: .gregorian)
        return cal.date(from: comps)!
    }()

    static let fortyFiveSecondsBefore = reference.addingTimeInterval(-45)

    // Overshoot by 10 second because we floor the time to the nearest minute
    static let oneMinuteAfter = reference.addingTimeInterval(60 + 10)
    static let threeMinutesLater = oneMinuteAfter.addingTimeInterval(60 * 3 + 10)
    static let fiveMinutesLater = threeMinutesLater.addingTimeInterval(60 * 5 + 10)
}
