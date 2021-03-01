//
//  Info.swift
//  ECG Scanner
//
//  Created by Paco Gago on 21/09/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

import Foundation

import SwiftUI

class Info{
    
    var title: String = ""
    var description: String = ""
    var img: String = ""
    
    init(title: String, description: String, img: String) {
        self.title = title
        self.description = description
        self.img = img
    }
}
