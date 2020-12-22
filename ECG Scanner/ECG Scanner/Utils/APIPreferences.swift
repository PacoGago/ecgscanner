//
//  APIPreferences.swift
//  ECG Scanner
//
//  Created by Paco Gago on 22/12/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

struct APIPreferences: Codable {
  var baseURL: String
}

class APIPreferencesLoader {
  static private var plistURL: URL {
    let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    return documents.appendingPathComponent("api_preferences.plist")
  }

  static func load() -> APIPreferences {
    
    if  let path        = Bundle.main.path(forResource: "api_preferences", ofType: "plist"),
        let xml         = FileManager.default.contents(atPath: path),
        let preferences = try? PropertyListDecoder().decode(APIPreferences.self, from: xml)
    {
       return preferences
    }
    return APIPreferences(baseURL: "")
  }
}

extension APIPreferencesLoader {
  static func copyPreferencesFromBundle() {
    if let path = Bundle.main.path(forResource: "api_preferences", ofType: "plist"),
      let data = FileManager.default.contents(atPath: path),
      FileManager.default.fileExists(atPath: plistURL.path) == false {

      FileManager.default.createFile(atPath: plistURL.path, contents: data, attributes: nil)
    }
  }
}



