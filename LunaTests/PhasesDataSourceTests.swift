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
        
        override func phasesDidUpdate(notification: NSNotification) {
            expectation?.fulfill()
            super.phasesDidUpdate(notification)
        }
    }
    
    var model: LunarPhaseModel {
        let configuration = NSURLSessionConfiguration.configurationWithProtocol(TestURLProtocol)
        let networkController = NetworkController(configuration: configuration)
        let model = LunarPhaseModel(networkController: networkController)
        return model
    }
    
    func testReloadsTableViewWhenSet() {
        let tableView = FakeTableView()
        tableView.expectation = expectationWithDescription("reloadData should be called")
        
        let dataSource = PhasesDataSource(model: model)
        dataSource.tableView = tableView
        
        waitForExpectationsWithTimeout(timeout, handler: nil)
    }
    
    func testHandlesPhasesUpdateNotification() {
        let dataSource = FakeDataSource(model: model)
        dataSource.expectation = expectationWithDescription("phasesDidUpdate should be called")
        
        let tableView = UITableView(frame: CGRectZero, style: .Plain)
        dataSource.tableView = tableView
        
        waitForExpectationsWithTimeout(timeout, handler: nil)
    }
}
