//
//  APIUtils.swift
//  ECG Scanner
//
//  Created by Paco Gago on 22/12/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

import SwiftUI

protocol APIUtils {
    func getProtocol(sslPreference: Bool) -> String
}

class APIUtilsImpl: APIUtils{
    
    func getProtocol(sslPreference: Bool) -> String{
        let res = sslPreference ? "https" : "http"
        return res
    }
    
}
