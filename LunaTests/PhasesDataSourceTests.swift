//
//  PhasesDataSourceTests.swift
//  Luna
//
//  Created by Andrew Shepard on 4/14/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import UIKit
import XCTest

class PhasesDataSourceTests: XCTestCase {
    
    class FakeTableView: UITableView {
        var expectation: XCTestExpectation?
        
        override func reloadData() {
            expectation?.fulfill()
            super.reloadData()
        }
    }
    
    class FakeDataSource: PhasesDataSource {
        var expectation: XCTestExpectation?
        
        override func phasesDidUpdate(_ notification: NSNotification) {
            expectation?.fulfill()
            super.phasesDidUpdate(notification)
        }
    }
    
    var model: LunarPhaseModel {
        let configuration = NSURLSessionConfiguration.configurationWithProtocol(protocolClass: LocalURLProtocol.self)
        let networkController = NetworkController(configuration: configuration)
        let model = LunarPhaseModel(networkController: networkController)
        return model
    }
    
    func testReloadsTableViewWhenSet() {
        let tableView = FakeTableView()
        tableView.expectation = expectation(withDescription: "reloadData should be called")
        
        let dataSource = PhasesDataSource(model: model)
        dataSource.configureUsing(tableView: tableView)
        
        waitForExpectations(withTimeout: timeout, handler: nil)
    }
    
//    func testHandlesPhasesUpdateNotification() {
//        let dataSource = FakeDataSource(model: model)
//        dataSource.expectation = expectationWithDescription("phasesDidUpdate should be called")
//        
//        let tableView = UITableView(frame: CGRectZero, style: .Plain)
//        dataSource.tableView = tableView
//        
//        
//    }
    
//    func testCellForRowAtIndexPath() {
//        let dataSource = FakeDataSource(model: model)
//        dataSource.expectation = expectationWithDescription("phasesDidUpdate should be called")
//        
//        let tableView = UITableView(frame: CGRectMake(0, 0, 320, 480), style: .Plain)
//        dataSource.tableView = tableView
//        
//        waitForExpectationsWithTimeout(timeout, handler: nil)
//        
//        let cell = dataSource.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
//        
////        let indexPath = NSIndexPath(forRow: 01, inSection: 0)
////        let cell = tableView.dataSource?.tableView(tableView, cellForRowAtIndexPath: indexPath)
////        
//        XCTAssertNotNil(cell, "Cell should not be nil")
//    }
}
