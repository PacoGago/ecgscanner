//
//  JWT.swift
//  ECG Scanner
//
//  Created by Paco Gago on 21/12/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

struct JWT : Codable {
    
    let user: String
    let pwd: String
    let token: String
    
    private enum CodingKeys: String, CodingKey {
        case user = "user"
        case pwd = "pwd"
        case token = "token"
    }
}

