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

