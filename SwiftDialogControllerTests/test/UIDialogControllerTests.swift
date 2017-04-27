//
//  UIDialogControllerTests.swift
//  SwiftDialogController
//
//  Created by Hai Pham on 4/28/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import UIKit
import SwiftUtilities
import SwiftUtilitiesTests
import SwiftUIUtilitiesTests
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
import XCTest
@testable import SwiftDialogController

class UIDialogControllerTests: XCTestCase {
    fileprivate let expectationTimeout: TimeInterval = 5
    fileprivate let disposeBag = DisposeBag()
    fileprivate var scheduler: TestScheduler!
    fileprivate var controller: UITestDialogController!
    
    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        controller = UITestDialogController()
        controller.viewDidLoad()
    }
    
    func test_pressButton_shouldDismissDialog() {
        // Setup
        let observer = scheduler.createObserver(Any.self)
        let expect = expectation(description: "Should have worked")
        
        // When
        controller.backgroundButton!.rx
            .controlEvent(.touchDown)
            .asObservable()
            .take(1)
            .logNext()
            .cast(to: Any.self)
            .doOnDispose(expect.fulfill)
            .subscribe(observer)
            .addDisposableTo(disposeBag)
        
        controller.backgroundButton!.sendActions(for: .touchDown)
        waitForExpectations(timeout: expectationTimeout, handler: nil)
        
        // Then
        print(observer.nextElements())
    }
}
