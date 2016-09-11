//
//  Gud_TayUITests.swift
//  Gud TayUITests
//
//  Created by Zev Eisenberg on 7/24/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import XCTest

class GudTayUITests: XCTestCase {

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchEnvironment[ProcessInfo.EnvironmentKey.weatherRefreshInterval.rawValue] = String(1.0)
        app.launchEnvironment[ProcessInfo.EnvironmentKey.weatherAPIClient.rawValue] = WeatherServiceKind.mock.rawValue
        app.launchEnvironment[ProcessInfo.EnvironmentKey.mbtaAPIClient.rawValue] = MBTAServiceKind.mock.rawValue
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    func testSwitchingFromRainToNoRain() {

        RunLoop.main.run(until: Date() + 3)

        let app = XCUIApplication()

        let window = app.windows.element(boundBy: 0)
        XCTAssert(window.exists)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

}
