//
//  UIDialogControllerTests.swift
//  SwiftDialogController
//
//  Created by Hai Pham on 4/28/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import UIKit
import SwiftUIUtilities
import SwiftUtilities
import SwiftUtilitiesTests
import SwiftUIUtilitiesTests
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
import XCTest
@testable import SwiftDialogController

extension CGSize {
    var reversed: CGSize { return CGSize(width: height, height: width) }
}

class UIDialogControllerTests: XCTestCase {
    fileprivate let expectationTimeout: TimeInterval = 5
    fileprivate let disposeBag = DisposeBag()
    fileprivate let tries = 1000
    fileprivate var scheduler: TestScheduler!
    fileprivate var controller: UIDialogController!
    fileprivate var presenter: Presenter!
    
    fileprivate let portraitSize = CGSize(width: 400, height: 700)
    fileprivate let landscapeSize = CGSize(width: 700, height: 400)
    
    fileprivate var targetSize: CGSize {
        return Bool.random() ? portraitSize : landscapeSize
    }
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        scheduler = TestScheduler(initialClock: 0)
        controller = UIDialogController()
        presenter = Presenter(view: controller)
        controller.presenter = presenter
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
        let controller = self.controller!
        let presenter = self.presenter!
        
        for _ in 0..<tries {
            // Setup: Separate the tests in order to call them multiple times.
            let shouldUpdate = Bool.random()
            let firstSize = Bool.random() ? portraitSize : landscapeSize
            let secondSize = firstSize.reversed
            let firstOrientation = BasicOrientation(size: firstSize)
            
            let dialogView = UIPaddingDialogView(
                withDetector: presenter,
                withLongSidePadding: CGFloat(Int.random(0, 100)),
                withShortSidePadding: CGFloat(Int.random(0, 100)),
                updateOnOrientationChanged: shouldUpdate
            )
            
            let testConstraints: () -> Void = {
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
                case .landscape where firstOrientation == .landscape,
                     .landscape where shouldUpdate && firstOrientation == .portrait,
                     .portrait where !shouldUpdate && firstOrientation == .landscape:
                    XCTAssertEqual(left!.constant, dialogView.longSidePadding)
                    XCTAssertEqual(right!.constant, dialogView.longSidePadding)
                    XCTAssertEqual(top!.constant, dialogView.shortSidePadding)
                    XCTAssertEqual(bottom!.constant, dialogView.shortSidePadding)
                    
                case .portrait where firstOrientation == .portrait,
                     .portrait where shouldUpdate && firstOrientation == .landscape,
                     .landscape where !shouldUpdate && firstOrientation == .portrait:
                    XCTAssertEqual(left!.constant, dialogView.shortSidePadding)
                    XCTAssertEqual(right!.constant, dialogView.shortSidePadding)
                    XCTAssertEqual(top!.constant, dialogView.longSidePadding)
                    XCTAssertEqual(bottom!.constant, dialogView.longSidePadding)
                
                default:
                    fatalError()
                }
            }
            
            // When: Fake orientation change.
            controller.viewWillTransition(to: firstSize, with: presenter)
            controller.add(view: dialogView)
            
            // Then: Test that initial build succeeds.
            testConstraints()
            
            // When: Fake orientation change.
            controller.viewWillTransition(to: secondSize, with: presenter)
            
            // Then: Test that view constraints are updated accordingly.
            testConstraints()
            dialogView.removeFromSuperview()
        }
    }
    
    func test_addRatioDialogView_shouldWork() {
        let controller = self.controller!
        let presenter = self.presenter!
        
        for _ in 0..<tries {
            // Setup: Separate the tests in order to call them multiple times.
            let shouldUpdate = Bool.random()
            let firstSize = Bool.random() ? portraitSize : landscapeSize
            let secondSize = firstSize.reversed
            let firstOrientation = BasicOrientation(size: firstSize)
            
            let dialogView = UIRatioDialogView(
                withDetector: presenter,
                withLongSideRatio: CGFloat(Int.random(1, 9)) / 10,
                withShortSideRatio: CGFloat(Int.random(1, 9)) / 10,
                updateOnOrientationChanged: shouldUpdate
            )
            
            let testConstraints: () -> Void = {
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
                case .landscape where firstOrientation == .landscape,
                     .landscape where shouldUpdate && firstOrientation == .portrait,
                     .portrait where !shouldUpdate && firstOrientation == .landscape:
                    XCTAssertEqual(floor(width!.multiplier),
                                   floor(dialogView.longSideRatio))
                    
                    XCTAssertEqual(floor(height!.multiplier),
                                   floor(dialogView.shortSideRatio))
                    
                case .portrait where firstOrientation == .portrait,
                     .portrait where shouldUpdate && firstOrientation == .landscape,
                     .landscape where !shouldUpdate && firstOrientation == .portrait:
                    XCTAssertEqual(floor(width!.multiplier),
                                   floor(dialogView.shortSideRatio))
                    
                    XCTAssertEqual(floor(height!.multiplier),
                                   floor(dialogView.longSideRatio))
                    
                default:
                    fatalError()
                }
            }
            
            // When: Fake orientation change.
            controller.viewWillTransition(to: firstSize, with: presenter)
            controller.add(view: dialogView)
            
            // Then: Test that initial build succeeds.
            testConstraints()
            
            // When: Fake orientation change.
            controller.viewWillTransition(to: secondSize, with: presenter)
            
            // Then: Test that view constraints are updated accordingly.
            testConstraints()
            dialogView.removeFromSuperview()
        }
    }
    
    func test_addRatioPadddingDialogView_shouldWork() {
        let controller = self.controller!
        let presenter = self.presenter!
        
        for _ in 0..<tries {
            // Setup: Separate the tests in order to call them multiple times.
            let shouldUpdate = Bool.random()
            let firstSize = Bool.random() ? portraitSize : landscapeSize
            let secondSize = firstSize.reversed
            let firstOrientation = BasicOrientation(size: firstSize)
            
            let dialogView = UIRatioPaddingDialogView(
                withDetector: presenter,
                withLongSideRatio: CGFloat(Int.random(1, 9)) / 10,
                withShortSidePadding: CGFloat(Int.random(0, 100)),
                updateOnOrientationChanged: shouldUpdate
            )
            
            let testConstraints: () -> Void = {
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
                case .landscape where firstOrientation == .landscape,
                     .landscape where shouldUpdate && firstOrientation == .portrait,
                     .portrait where !shouldUpdate && firstOrientation == .landscape:
                    XCTAssertNotNil(top)
                    XCTAssertNotNil(bottom)
                    XCTAssertNotNil(width)
                    XCTAssertEqual(top!.constant, dialogView.shortSidePadding)
                    XCTAssertEqual(bottom!.constant, dialogView.shortSidePadding)
                    
                    XCTAssertEqual(
                        floor(width!.multiplier),
                        floor(dialogView.longSideRatio)
                    )
                    
                case .portrait where firstOrientation == .portrait,
                     .portrait where shouldUpdate && firstOrientation == .landscape,
                     .landscape where !shouldUpdate && firstOrientation == .portrait:
                    XCTAssertNotNil(left)
                    XCTAssertNotNil(right)
                    XCTAssertNotNil(height)
                    XCTAssertEqual(left!.constant, dialogView.shortSidePadding)
                    XCTAssertEqual(right!.constant, dialogView.shortSidePadding)
                    
                    XCTAssertEqual(floor(height!.multiplier),
                                   floor(dialogView.longSideRatio))
                    
                default:
                    fatalError()
                }
            }
            
            // When: Fake orientation change.
            controller.viewWillTransition(to: firstSize, with: presenter)
            controller.add(view: dialogView)
            
            // Then: Test that initial build succeeds.
            testConstraints()
            
            // When: Fake orientation change.
            controller.viewWillTransition(to: secondSize, with: presenter)
            
            // Then: Test that view constraints are updated accordingly.
            testConstraints()
            dialogView.removeFromSuperview()
        }
    }
    
    func test_addPaddingConstantDialogView_shouldWork() {
        // Setup
        let controller = self.controller!
        let presenter = self.presenter!
        
        for _ in 0..<tries {
            // Setup: Separate the tests in order to call them multiple times.
            let shouldUpdate = Bool.random()
            let firstSize = Bool.random() ? portraitSize : landscapeSize
            let secondSize = firstSize.reversed
            let firstOrientation = BasicOrientation(size: firstSize)
            
            let dialogView = UIPaddingConstantDialogView(
                withDetector: presenter,
                withLongSideConstant: CGFloat(Int.random(100, 600)),
                withShortSidePadding: CGFloat(Int.random(0, 100)),
                updateOnOrientationChanged: shouldUpdate
            )
            
            let testConstraints: () -> Void = {
                let width = dialogView.constraints.filter({
                    $0.firstAttribute == .width &&
                    $0.firstItem as? UIView == dialogView
                }).first
                
                let height = dialogView.constraints.filter({
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
                case .landscape where firstOrientation == .landscape,
                     .landscape where shouldUpdate && firstOrientation == .portrait,
                     .portrait where !shouldUpdate && firstOrientation == .landscape:
                    XCTAssertNotNil(top)
                    XCTAssertNotNil(bottom)
                    XCTAssertNotNil(width)
                    XCTAssertEqual(top!.constant, dialogView.shortSidePadding)
                    XCTAssertEqual(bottom!.constant, dialogView.shortSidePadding)
                    
                    XCTAssertEqual(floor(width!.constant),
                                   floor(dialogView.longSideConstant))
                    
                    XCTAssertNil(width!.secondItem)
                    XCTAssertEqual(width!.secondAttribute, .notAnAttribute)
                    
                case .portrait where firstOrientation == .portrait,
                     .portrait where shouldUpdate && firstOrientation == .landscape,
                     .landscape where !shouldUpdate && firstOrientation == .portrait:
                    XCTAssertNotNil(left)
                    XCTAssertNotNil(right)
                    XCTAssertNotNil(height)
                    XCTAssertEqual(left!.constant, dialogView.shortSidePadding)
                    XCTAssertEqual(right!.constant, dialogView.shortSidePadding)
                    
                    XCTAssertEqual(floor(height!.constant),
                                   floor(dialogView.longSideConstant))
                    
                    XCTAssertNil(height!.secondItem)
                    XCTAssertEqual(height!.secondAttribute, .notAnAttribute)
                    
                default:
                    fatalError()
                }
            }
            
            // When: Fake orientation change.
            controller.viewWillTransition(to: firstSize, with: presenter)
            controller.add(view: dialogView)
            
            // Then: Test that initial build succeeds.
            testConstraints()
            
            // When: Fake orientation change.
            controller.viewWillTransition(to: secondSize, with: presenter)
            
            // Then: Test that view constraints are updated accordingly.
            testConstraints()
            dialogView.removeFromSuperview()
        }
    }
    
    func test_addRatioConstantDialogView_shouldWork() {
        // Setup
        let controller = self.controller!
        let presenter = self.presenter!
        
        for _ in 0..<tries {
            // Setup: Separate the tests in order to call them multiple times.
            let shouldUpdate = false
            let firstSize = Bool.random() ? portraitSize : landscapeSize
            let secondSize = firstSize.reversed
            let firstOrientation = BasicOrientation(size: firstSize)
            
            let dialogView = UIRatioConstantDialogView(
                withDetector: presenter,
                withLongSideConstant: CGFloat(Int.random(100, 600)),
                withShortSideRatio: CGFloat(Int.random(1, 9)) / 10,
                updateOnOrientationChanged: shouldUpdate
            )
            
            let testConstraints: () -> Void = {
                let directWidth = dialogView.constraints.filter({
                    $0.firstAttribute == .width &&
                    $0.firstItem as? UIView == dialogView
                }).first
                
                let directHeight = dialogView.constraints.filter({
                    $0.firstAttribute == .height &&
                    $0.firstItem as? UIView == dialogView
                }).first
                
                let ratioWidth = controller.view.constraints.filter({
                    $0.firstAttribute == .width &&
                    $0.firstItem as? UIView == dialogView
                }).first
                
                let ratioHeight = controller.view.constraints.filter({
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
                
                XCTAssertNotNil(centerX)
                XCTAssertNotNil(centerY)
                XCTAssertEqual(centerX!.constant, 0)
                XCTAssertEqual(centerY!.constant, 0)
                
                switch presenter.orientation {
                case .landscape where firstOrientation == .landscape,
                     .landscape where shouldUpdate && firstOrientation == .portrait,
                     .portrait where !shouldUpdate && firstOrientation == .landscape:
                    XCTAssertNotNil(directWidth)
                    XCTAssertNotNil(ratioHeight)
                    
                    XCTAssertEqual(
                        floor(directWidth!.constant),
                        floor(dialogView.longSideConstant)
                    )
                    
                    XCTAssertNil(directWidth!.secondItem)
                    XCTAssertEqual(directWidth!.secondAttribute, .notAnAttribute)
                    
                    XCTAssertEqual(floor(ratioHeight!.multiplier),
                                   floor(dialogView.shortSideRatio))
                    
                case .portrait where firstOrientation == .portrait,
                     .portrait where shouldUpdate && firstOrientation == .landscape,
                     .landscape where !shouldUpdate && firstOrientation == .portrait:
                    XCTAssertNotNil(directHeight)
                    XCTAssertNotNil(ratioWidth)
                    
                    XCTAssertEqual(
                        floor(directHeight!.constant),
                        floor(dialogView.longSideConstant)
                    )
                    
                    XCTAssertNil(directHeight!.secondItem)
                    XCTAssertEqual(directHeight!.secondAttribute, .notAnAttribute)
                    
                    XCTAssertEqual(floor(ratioWidth!.multiplier),
                                   floor(dialogView.shortSideRatio))
                    
                default:
                    fatalError()
                }
            }
            
            // When: Fake orientation change.
            controller.viewWillTransition(to: firstSize, with: presenter)
            controller.add(view: dialogView)
            
            // Then: Test that initial build succeeds.
            testConstraints()
            
            // When: Fake orientation change.
            controller.viewWillTransition(to: secondSize, with: presenter)
            
            // Then: Test that view constraints are updated accordingly.
            testConstraints()
            dialogView.removeFromSuperview()
        }
    }
}
