//
//  User.swift
//  ECG Scanner
//
//  Created by Paco Gago on 02/12/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

import Foundation

import SwiftUI

class User: ObservableObject{
    
    private init(){}
    
    static let shared = User()
    
    @Published var name = ""
    @Published var pwd = ""
    
}

