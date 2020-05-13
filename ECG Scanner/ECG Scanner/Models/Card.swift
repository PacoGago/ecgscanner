//
//  Card.swift
//  ECG Scanner
//
//  Created by Paco Gago on 11/05/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

class Card{
    
    var img: String = ""
    var description: String = ""
    var buttonText: String = ""
    
    init(img: String, description: String, buttonText: String) {
        self.img = img
        self.description = description
        self.buttonText = buttonText
    }
}
