import Foundation

import SwiftUI

class User: ObservableObject{
    
    private init(){}
    
    static let shared = User()
    
    @Published var name = ""
    @Published var pwd = ""
    
}

