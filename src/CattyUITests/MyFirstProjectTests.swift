/**
 *  Copyright (C) 2010-2023 The Catrobat Team
 *  (http://developer.catrobat.org/credits)
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 *
 *  An additional term exception under section 7 of the GNU Affero
 *  General Public License, version 3, is available at
 *  (http://developer.catrobat.org/license_additional_term)
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see http://www.gnu.org/licenses/.
 */

import XCTest

class MyFirstProjectTests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        app = launchApp()
    }

    func testCanDeleteMultipleObjectsViaEditMode() {
        app.tables.staticTexts[kLocalizedProjectsOnDevice].tap()
        app.tables.staticTexts[kLocalizedMyFirstProject].tap()
        app.staticTexts["\(kLocalizedScene) 1"].tap()
        app.navigationBars["\(kLocalizedScene) 1"].buttons[kLocalizedEdit].tap()
        app.buttons[kLocalizedDeleteObjects].tap()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["\(kLocalizedMole) 1"].tap()
        tablesQuery.staticTexts["\(kLocalizedMole) 2"].tap()
        app.toolbars.buttons[kLocalizedDelete].tap()
        XCTAssert(app.tables.staticTexts[kLocalizedBackground].exists)
        XCTAssert(app.tables.staticTexts["\(kLocalizedMole) 1"].exists == false)
        XCTAssert(app.tables.staticTexts["\(kLocalizedMole) 2"].exists == false)
        XCTAssert(app.tables.staticTexts["\(kLocalizedMole) 3"].exists)
        XCTAssert(app.tables.staticTexts["\(kLocalizedMole) 4"].exists)
    }

    func testCanRenameProjectViaEditMode() {
        app.tables.staticTexts[kLocalizedProjectsOnDevice].tap()
        app.tables.staticTexts[kLocalizedMyFirstProject].tap()
        //app.staticTexts["\(kLocalizedScene) 1"].tap()
        app.navigationBars[kLocalizedMyFirstProject].buttons[kLocalizedEdit].tap()
        app.buttons[kLocalizedRenameProject].tap()

        XCTAssert(app.alerts[kLocalizedRenameProject].exists)
        let alertQuery = app.alerts[kLocalizedRenameProject]

        XCTAssert(alertQuery.buttons["Clear text"].exists)
        alertQuery.buttons["Clear text"].tap()
        alertQuery.textFields[kLocalizedEnterYourProjectNameHere].typeText("My renamed project")
        XCTAssert(alertQuery.buttons[kLocalizedOK].exists)
        alertQuery.buttons[kLocalizedOK].tap()

        //XCTAssert(app.navigationBars["My renamed project"].exists)

        // go back and forth to force reload table view!!
        app.navigationBars["My renamed project"].buttons[kLocalizedProjects].tap()
        app.navigationBars[kLocalizedProjects].buttons[kLocalizedPocketCode].tap()
        app.tables.staticTexts[kLocalizedProjectsOnDevice].tap()

        // check again
        XCTAssert(app.tables.staticTexts["My renamed project"].exists)

    }

    func testCanChangeOrientationViaEditMode() {
        app.tables.staticTexts[kLocalizedProjectsOnDevice].tap()
        app.tables.staticTexts[kLocalizedMyFirstProject].tap()
        app.staticTexts["\(kLocalizedScene) 1"].tap()
        app.navigationBars["\(kLocalizedScene) 1"].buttons[kLocalizedEdit].tap()

        XCTAssert(app.buttons[kLocalizedMakeItLandscape].exists)
        app.buttons[kLocalizedMakeItLandscape].tap()

        XCTAssertFalse(waitForElementToDisappear(app.staticTexts["\(kLocalizedLoading)..."], timeout: 10).exists)

        app.navigationBars["\(kLocalizedScene) 1"].buttons[kLocalizedEdit].tap()
        XCTAssert(waitForElementToAppear(app.buttons[kLocalizedMakeItPortrait]).exists)
    }

    func testCanAbortRenameProjectViaEditMode() {
        app.tables.staticTexts[kLocalizedProjectsOnDevice].tap()
        app.tables.staticTexts[kLocalizedMyFirstProject].tap()
        app.navigationBars[kLocalizedMyFirstProject].buttons[kLocalizedEdit].tap()
        app.buttons[kLocalizedRenameProject].tap()

        XCTAssert(app.alerts[kLocalizedRenameProject].exists)
        let alertQuery = app.alerts[kLocalizedRenameProject]
        XCTAssert(alertQuery.buttons["Clear text"].exists)
        alertQuery.buttons["Clear text"].tap()
        alertQuery.textFields[kLocalizedEnterYourProjectNameHere].typeText("My renamed project")
        XCTAssert(alertQuery.buttons[kLocalizedCancel].exists)
        alertQuery.buttons[kLocalizedCancel].tap()

        XCTAssert(app.navigationBars[kLocalizedMyFirstProject].exists)

        // go back and forth to force reload table view!!
        //app.navigationBars["\(kLocalizedScene) 1"].buttons[kLocalizedMyFirstProject].tap()
        app.navigationBars[kLocalizedMyFirstProject].buttons[kLocalizedProjects].tap()
        app.navigationBars[kLocalizedProjects].buttons[kLocalizedPocketCode].tap()
        app.tables.staticTexts[kLocalizedProjectsOnDevice].tap()

        // check again
        XCTAssert(app.tables.staticTexts[kLocalizedMyFirstProject].exists)
    }

    func testCanShowAndHideDetailsViaEditMode() {
        app.tables.staticTexts[kLocalizedProjectsOnDevice].tap()
        app.tables.staticTexts[kLocalizedMyFirstProject].tap()
        app.staticTexts["\(kLocalizedScene) 1"].tap()
        app.navigationBars["\(kLocalizedScene) 1"].buttons[kLocalizedEdit].tap()

        if app.buttons[kLocalizedHideDetails].exists {
            app.buttons[kLocalizedHideDetails].tap()
            app.navigationBars["\(kLocalizedScene) 1"].buttons[kLocalizedEdit].tap()
        }

        app.buttons[kLocalizedShowDetails].tap()

        app.navigationBars["\(kLocalizedScene) 1"].buttons[kLocalizedEdit].tap()
        XCTAssert(app.buttons[kLocalizedHideDetails].exists)
        app.buttons[kLocalizedHideDetails].tap()
        app.navigationBars["\(kLocalizedScene) 1"].buttons[kLocalizedEdit].tap()

        XCTAssert(app.buttons[kLocalizedShowDetails].exists)
        app.buttons[kLocalizedCancel].tap()

        XCTAssert(app.navigationBars["\(kLocalizedScene) 1"].exists)
    }

    func testCanAbortDeleteSingleObjectViaSwipe() {
        app.tables.staticTexts[kLocalizedProjectsOnDevice].tap()
        app.tables.staticTexts[kLocalizedMyFirstProject].tap()
        app.staticTexts["\(kLocalizedScene) 1"].tap()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["\(kLocalizedMole) 3"].swipeLeft()
        XCTAssert(app.buttons[kLocalizedDelete].exists)

        app.buttons[kLocalizedDelete].tap()
        let yesButton = app.alerts[kLocalizedDeleteThisObject].buttons[kLocalizedCancel]
        yesButton.tap()
        XCTAssert(app.tables.staticTexts["\(kLocalizedMole) 3"].exists)
    }

    func testCanDeleteSingleObjectViaSwipe() {
        app.tables.staticTexts[kLocalizedProjectsOnDevice].tap()
        app.tables.staticTexts[kLocalizedMyFirstProject].tap()
        app.staticTexts["\(kLocalizedScene) 1"].tap()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["\(kLocalizedMole) 1"].swipeLeft()
        XCTAssert(app.buttons[kLocalizedDelete].exists)

        app.buttons[kLocalizedDelete].tap()
        let yesButton = app.alerts[kLocalizedDeleteThisObject].buttons[kLocalizedYes]
        yesButton.tap()
        XCTAssert(app.tables.staticTexts["\(kLocalizedMole) 1"].exists == false)
    }

    func testCanRenameSingleObjectViaSwipe() {
        app.tables.staticTexts[kLocalizedProjectsOnDevice].tap()
        app.tables.staticTexts[kLocalizedMyFirstProject].tap()
        app.staticTexts["\(kLocalizedScene) 1"].tap()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["\(kLocalizedMole) 3"].swipeLeft()
        XCTAssert(app.buttons[kLocalizedMore].exists)

        app.buttons[kLocalizedMore].tap()
        app.buttons[kLocalizedRename].tap()

        let alert = waitForElementToAppear(app.alerts[kLocalizedRenameObject])
        alert.buttons["Clear text"].tap()
        alert.textFields[kLocalizedEnterYourObjectNameHere].typeText("\(kLocalizedMole) 5")
        alert.buttons[kLocalizedOK].tap()

        XCTAssert(app.tables.staticTexts["\(kLocalizedMole) 5"].exists)
    }

    func testCanAbortRenameSingleObjectViaSwipe() {
        app.tables.staticTexts[kLocalizedProjectsOnDevice].tap()
        app.tables.staticTexts[kLocalizedMyFirstProject].tap()
        app.staticTexts["\(kLocalizedScene) 1"].tap()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["\(kLocalizedMole) 1"].swipeLeft()
        XCTAssert(app.buttons[kLocalizedMore].exists)

        app.buttons[kLocalizedMore].tap()
        app.buttons[kLocalizedRename].tap()

        let alert = waitForElementToAppear(app.alerts[kLocalizedRenameObject])
        alert.buttons["Clear text"].tap()
        alert.textFields[kLocalizedEnterYourObjectNameHere].typeText("\(kLocalizedMole) 5")
        alert.buttons[kLocalizedCancel].tap()

        XCTAssert(app.tables.staticTexts["\(kLocalizedMole) 1"].exists)
    }

    func testCanCopySingleObjectViaSwipe() {
        app.tables.staticTexts[kLocalizedProjectsOnDevice].tap()
        app.tables.staticTexts[kLocalizedMyFirstProject].tap()
        app.staticTexts["\(kLocalizedScene) 1"].tap()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["\(kLocalizedMole) 1"].swipeLeft()
        XCTAssert(app.buttons[kLocalizedMore].exists)

        app.buttons[kLocalizedMore].tap()
        app.buttons[kLocalizedCopy].tap()
        app.swipeDown()
        XCTAssert(app.tables.staticTexts["\(kLocalizedMole) 1 (1)"].exists)
    }

    func testCanAbortSwipe() {
        app.tables.staticTexts[kLocalizedProjectsOnDevice].tap()
        app.tables.staticTexts[kLocalizedMyFirstProject].tap()
        app.staticTexts["\(kLocalizedScene) 1"].tap()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["\(kLocalizedMole) 1"].swipeLeft()
        XCTAssert(app.buttons[kLocalizedMore].exists)

        app.buttons[kLocalizedMore].tap()
        app.buttons[kLocalizedCancel].tap()
    }
}
