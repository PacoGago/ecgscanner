//
//  PruebasUnitariasAPIUtils.swift
//  ECG ScannerTests
//
//  Created by Paco Gago on 28/12/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

import XCTest
import SwiftUI
@testable import ECG_Scanner

class PruebasUnitariasAPIUtils: XCTestCase {
    
    func testGetProtocol() throws {
        
        let APIUtils = APIUtilsImpl()
        
        //1. Given
        let sslpreferences: Bool = false
        
        //2. When
        let res = APIUtils.getProtocol(sslPreference: sslpreferences)
        
        //3. Then
        XCTAssertEqual(res, "http")
        
    }
    
    func testGetProtocolSSL() throws {
        
        let APIUtils = APIUtilsImpl()
        
        //1. Given
        let sslpreferences: Bool = true
        
        //2. When
        let res = APIUtils.getProtocol(sslPreference: sslpreferences)
        
        //3. Then
        XCTAssertEqual(res, "https")
        
    }
    
}
