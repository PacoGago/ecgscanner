struct APIPreferences: Codable {
    var baseURL: String
    var ssl: Bool
    var port: String
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
    return APIPreferences(baseURL: "", ssl: false, port: "")
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
