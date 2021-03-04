import SwiftUI

class Card{
    
    var img: String = ""
    var description: String = ""
    var buttonText: String = ""
    var backgroundCardColor: Color
    var buttonFontColor: Color
    var buttonBackgroundColor: Color
    var cardFontColor: Color
    var cardImageColor: Color
    
    init(img: String, description: String, buttonText: String, backgroundCardColor: Color, buttonFontColor: Color, buttonBackgroundColor: Color, cardFontColor: Color, cardImageColor: Color) {
        self.img = img
        self.description = description
        self.buttonText = buttonText
        self.backgroundCardColor = backgroundCardColor
        self.buttonFontColor = buttonFontColor
        self.buttonBackgroundColor = buttonBackgroundColor
        self.cardFontColor = cardFontColor
        self.cardImageColor = cardImageColor
    }
}
