//
//  FiltersAppUITests.swift
//  FiltersAppUITests
//
//  Created by Никита Казанцев on 21.05.2022.
//

import XCTest

class FiltersAppUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGeneralScreenBasics() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        sleep(5)
        
        // verify Navigation title
        let welcome = app.staticTexts["Presets"]
        XCTAssert(welcome.exists)

        // verify categories
        for label in ["travel", "color", "nature", "urban"] {
            let tmp = app.staticTexts[label]
            XCTAssert(tmp.exists)
        }

        // verify tab bar items
        for label in ["Filters", "Tips", "Favourite"] {
            let tmp = app.tabBars.buttons[label]
            XCTAssert(tmp.exists)
        }
    }

    func testGeneralScreenFiltersBlocksLoadingSuccess() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        sleep(5)

        // verify first pack block title
        let packTitle = app.staticTexts["Porta"]
        XCTAssert(packTitle.exists)

        // verify first pack filters existence
        let firstFilter = app.staticTexts["Porta 1"]
        XCTAssert(firstFilter.exists)

        // scroll block to last filter
        firstFilter.swipeLeft(velocity: .init(rawValue: 1000))

        // verify last pack's filter existence
        let lastFilter = app.staticTexts["Porta 4"]
        XCTAssert(lastFilter.exists)

        // verify filters count label
        let countFilters = app.staticTexts["4 presets"]
        XCTAssert(countFilters.exists)
    }

    func testCategoriesFilteringLogic() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        sleep(5)

        // verify first pack block title
        let travelCategoryButton = app.staticTexts["travel"]
        XCTAssert(travelCategoryButton.exists)

        // tap on category label in order to filter existing filters on main screen
        travelCategoryButton.tap()

        // checking if DB filtering request worked
        let navLabel = app.staticTexts["travel"]
        XCTAssert(navLabel.exists)

        let firstFilterName = app.staticTexts["Moody 3"]
        XCTAssert(firstFilterName.exists)
    }

    func testDetailFilterScreen() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        sleep(5)

        // verify first pack block title and tap on it in order to open datailed screen
        let firstFilter = app.staticTexts["Porta 1"]
        XCTAssert(firstFilter.exists)

        firstFilter.tap()
        sleep(2)

        // verify all ui labels to be rendered

        // nav bar
        let navBar = app.staticTexts["Porta"]
        XCTAssert(navBar.exists)

        // tip label with description how to see photo with or without filter
        let tipLabel = app.staticTexts["Hold photo to see without filter"]
        XCTAssert(tipLabel.exists)

        let hashtags = app.staticTexts["#porta"]
        XCTAssert(hashtags.exists)

        // block with similar filters
        let similarFiltersBlockTitle = app.staticTexts["More like this"]
        XCTAssert(similarFiltersBlockTitle.exists)
    }

    func testLoadMoreFiltersDBRequestLogic() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        sleep(5)

        // checking if main screen rendered correctly
        let firstFilter = app.staticTexts["Porta 1"]
        XCTAssert(firstFilter.exists)

        // scrolling down to load more button
        app.swipeUp(velocity: .fast)
        sleep(4)

        // finding load more button and tapping it to request filters from database
        let loadMoreButtonTitle = app.buttons["Load more"]
        XCTAssert(loadMoreButtonTitle.exists)

        loadMoreButtonTitle.tap()
        sleep(4)

        let newFilterThatWasLoaded = app.staticTexts["Autumn"]
        XCTAssert(newFilterThatWasLoaded.exists)

    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
