//
//  weecare_ios_challengeTests.swift
//  weecare-ios-challengeTests
//
//  Created by Miguel Fraire on 9/24/21.
//

import XCTest
@testable import weecare_ios_challenge

class weecare_ios_challengeTests: XCTestCase {
    
    var sut: ITunesAPI!
    let network = Network(sessionConfig: .default)
    
    override func setUp() {
        super.setUp()
        sut = ITunesAPI(network: network)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testAPIService() {
        let expectation = self.expectation(description: "Loading albums")

        sut.getTopAlbums(limit: 10) { result in
            switch result{
                case .success(let album):
                    XCTAssertEqual(album.feed.results.count, 10, "We should have exactly 10 albums.")
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail(error.localizedDescription)
            }
        }
        
        self.waitForExpectations(timeout: 10, handler: nil)
    }
}
