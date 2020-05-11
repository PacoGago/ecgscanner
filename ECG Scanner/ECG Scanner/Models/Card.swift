//
//  Card.swift
//  ECG Scanner
//
//  Created by Paco Gago on 11/05/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

class Card{
    
    var title: String = ""
    var subtitle: String = ""
    var img: String = ""

    init(title: String, subtitle: String, img: String) {
        self.title = title
        self.subtitle = subtitle
        self.img = img
    }
}
