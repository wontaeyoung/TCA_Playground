//
//  TCA_PlaygroundTests.swift
//  TCA-PlaygroundTests
//
//  Created by 원태영 on 10/2/23.
//

import ComposableArchitecture
import XCTest
@testable import TCA_Playground

@MainActor
final class TCA_PlaygroundTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test증가버튼을눌러서1이되었다가감소버튼을눌러서다시0이된다() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }
        
        await store.send(.incrementButtonTapped) { state in
            state.number = 1
            state.factString = nil
        }
        
        await store.send(.decrementButtonTapped) { state in
            state.number = 0
        }
        
        await store.send(.factResponse(fact: "A")) {
            $0.factString = "B"
        }
    }
    
    func test타이머가토글되면값이변경된다() async throws {
        let store = TestStore(
            initialState: CounterFeature.State()
        ) {
            CounterFeature()
        }
        
        // 타이머 동작
        await store.send(.toggleTimerButtonTapped) { state in
            state.isTimerOn = true
        }
        
        // 1.1초 대기
        try await Task.sleep(for: .milliseconds(1_100))
        
        //
        await store.receive(.timerTicked) {
            $0.number = 1
        }
        
        try await Task.sleep(for: .milliseconds(1_100))
        await store.receive(.timerTicked) {
            $0.number = 2
        }
        
        // 타이머 해제
        await store.send(.toggleTimerButtonTapped) { state in
            state.isTimerOn = false
        }
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
