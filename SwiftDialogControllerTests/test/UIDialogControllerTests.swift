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
    fileprivate let tries = 1000
    fileprivate var scheduler: TestScheduler!
    fileprivate var controller: UITestDialogController!
    fileprivate var presenter: UITestDialogController.Presenter!
    
    fileprivate let portraitSize = CGSize(width: 1, height: 2)
    fileprivate let landscapeSize = CGSize(width: 2, height: 1)
    
    fileprivate var targetSize: CGSize {
        return Bool.random() ? portraitSize : landscapeSize
    }
    
    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        controller = UITestDialogController()
        presenter = controller.presenter
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
            .cast(to: Any.self)
            .doOnDispose(expect.fulfill)
            .subscribe(observer)
            .addDisposableTo(disposeBag)
        
        controller.backgroundButton!.sendActions(for: .touchDown)
        waitForExpectations(timeout: expectationTimeout, handler: nil)
        
        // Then
        XCTAssertTrue(presenter.fake_dismiss.methodCalled)
    }
    
    func test_addPaddingDialogView_shouldWork() {
        for _ in 0..<tries {
            // Setup
            let dialogView = UIPaddingDialogView(
                withDetector: presenter,
                withLongSidePadding: CGFloat(Int.random(0, 100)),
                withShortSidePadding: CGFloat(Int.random(0, 100))
            )
            
            // Fake orientation change.
            controller.viewWillTransition(to: targetSize, with: presenter)
            
            // When
            controller.add(view: dialogView)
            
            // Then
            let top = controller.view.constraints.filter({
                $0.firstAttribute == .top &&
                $0.firstItem as? UIView == dialogView
            }).first
            
            let left = controller.view.constraints.filter({
                $0.firstAttribute == .left &&
                $0.firstItem as? UIView == dialogView
            }).first
            
            let right = controller.view.constraints.filter({
                $0.firstAttribute == .right &&
                $0.secondItem as? UIView == dialogView
            }).first
            
            let bottom = controller.view.constraints.filter({
                $0.firstAttribute == .bottom &&
                $0.secondItem as? UIView == dialogView
            }).first
            
            XCTAssertNotNil(top)
            XCTAssertNotNil(left)
            XCTAssertNotNil(right)
            XCTAssertNotNil(bottom)
            
            switch presenter.orientation {
            case .landscape:
                XCTAssertEqual(left!.constant, dialogView.longSidePadding)
                XCTAssertEqual(right!.constant, dialogView.longSidePadding)
                XCTAssertEqual(top!.constant, dialogView.shortSidePadding)
                XCTAssertEqual(bottom!.constant, dialogView.shortSidePadding)
                
            case .portrait:
                XCTAssertEqual(left!.constant, dialogView.shortSidePadding)
                XCTAssertEqual(right!.constant, dialogView.shortSidePadding)
                XCTAssertEqual(top!.constant, dialogView.longSidePadding)
                XCTAssertEqual(bottom!.constant, dialogView.longSidePadding)
            }
            
            dialogView.removeFromSuperview()
            controller.view.removeConstraints([top!, left!, bottom!, right!])
        }
    }
    
    func test_addRatioDialogView_shouldWork() {
        for _ in 0..<tries {
            // Setup
            let dialogView = UIRatioDialogView(
                withDetector: presenter,
                withLongSideRatio: CGFloat(Int.random(1, 9)) / 10,
                withShortSideRatio: CGFloat(Int.random(1, 9)) / 10
            )
            
            // Fake orientation change.
            controller.viewWillTransition(to: targetSize, with: presenter)
            
            // When
            controller.add(view: dialogView)
            
            // Then
            let width = controller.view.constraints.filter({
                $0.firstAttribute == .width &&
                $0.firstItem as? UIView == dialogView
            }).first
            
            let height = controller.view.constraints.filter({
                $0.firstAttribute == .height &&
                $0.firstItem as? UIView == dialogView
            }).first
            
            let centerX = controller.view.constraints.filter({
                $0.firstAttribute == .centerX &&
                $0.firstItem as? UIView == dialogView
            }).first
            
            let centerY = controller.view.constraints.filter({
                $0.firstAttribute == .centerX &&
                $0.firstItem as? UIView == dialogView
            }).first
            
            XCTAssertNotNil(width)
            XCTAssertNotNil(height)
            XCTAssertNotNil(centerX)
            XCTAssertNotNil(centerY)
            
            XCTAssertEqual(centerX!.constant, 0)
            XCTAssertEqual(centerY!.constant, 0)
            
            switch presenter.orientation {
            case .landscape:
                XCTAssertEqual(
                    floor(width!.multiplier),
                    floor(dialogView.longSideRatio)
                )
                
                XCTAssertEqual(
                    floor(height!.multiplier),
                    floor(dialogView.shortSideRatio)
                )
                
            case .portrait:
                XCTAssertEqual(
                    floor(width!.multiplier),
                    floor(dialogView.shortSideRatio)
                )
                
                XCTAssertEqual(
                    floor(height!.multiplier),
                    floor(dialogView.longSideRatio)
                )
            }
            
            dialogView.removeFromSuperview()
            controller.view.removeConstraints([width!, height!, centerX!, centerY!])
        }
    }
    
    func test_addRatioPadddingDialogView_shouldWork() {
        for _ in 0..<tries {
            // Setup
            let dialogView = UIRatioPaddingDialogView(
                withDetector: presenter,
                withLongSideRatio: CGFloat(Int.random(1, 9)) / 10,
                withShortSidePadding: CGFloat(Int.random(0, 100))
            )
            
            // Fake orientation change.
            controller.viewWillTransition(to: targetSize, with: presenter)
            
            // When
            controller.add(view: dialogView)
            
            // Then
            let width = controller.view.constraints.filter({
                $0.firstAttribute == .width &&
                $0.firstItem as? UIView == dialogView
            }).first
            
            let height = controller.view.constraints.filter({
                $0.firstAttribute == .height &&
                $0.firstItem as? UIView == dialogView
            }).first
            
            let top = controller.view.constraints.filter({
                $0.firstAttribute == .top &&
                $0.firstItem as? UIView == dialogView
            }).first
            
            let left = controller.view.constraints.filter({
                $0.firstAttribute == .left &&
                $0.firstItem as? UIView == dialogView
            }).first
            
            let right = controller.view.constraints.filter({
                $0.firstAttribute == .right &&
                $0.secondItem as? UIView == dialogView
            }).first
            
            let bottom = controller.view.constraints.filter({
                $0.firstAttribute == .bottom &&
                $0.secondItem as? UIView == dialogView
            }).first
            
            let centerX = controller.view.constraints.filter({
                $0.firstAttribute == .centerX &&
                $0.firstItem as? UIView == dialogView
            }).first
            
            let centerY = controller.view.constraints.filter({
                $0.firstAttribute == .centerX &&
                $0.firstItem as? UIView == dialogView
            }).first
            
            XCTAssertNotNil(centerX)
            XCTAssertNotNil(centerY)
            XCTAssertEqual(centerX!.constant, 0)
            XCTAssertEqual(centerY!.constant, 0)
            
            switch presenter.orientation {
            case .landscape:
                XCTAssertNotNil(top)
                XCTAssertNotNil(bottom)
                XCTAssertNotNil(width)
                XCTAssertEqual(top!.constant, dialogView.shortSidePadding)
                XCTAssertEqual(bottom!.constant, dialogView.shortSidePadding)
                
                XCTAssertEqual(
                    floor(width!.multiplier),
                    floor(dialogView.longSideRatio)
                )
                
                controller.view.removeConstraints(
                    [top!, bottom!, width!, centerX!, centerY!]
                )
                
            case .portrait:
                XCTAssertNotNil(left)
                XCTAssertNotNil(right)
                XCTAssertNotNil(height)
                XCTAssertEqual(left!.constant, dialogView.shortSidePadding)
                XCTAssertEqual(right!.constant, dialogView.shortSidePadding)
                
                XCTAssertEqual(
                    floor(height!.multiplier),
                    floor(dialogView.longSideRatio)
                )
                
                controller.view.removeConstraints(
                    [left!, right!, height!, centerX!, centerY!]
                )
            }
            
            dialogView.removeFromSuperview()
        }
    }
}
