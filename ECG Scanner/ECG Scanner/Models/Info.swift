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
