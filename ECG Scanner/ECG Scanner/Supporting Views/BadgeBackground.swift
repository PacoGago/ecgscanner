import SwiftUI

struct BadgeBackground: View {
    var body: some View {
               
        GeometryReader { geometry in
            Circle()
            .fill(LinearGradient(
                gradient: .init(colors: [Self.gradientStart, Self.gradientEnd]),
                startPoint: .init(x: 0.5, y: 0),
                endPoint: .init(x: 0.5, y: 0.6)
            ))
                .aspectRatio(1, contentMode: .fit)
                .overlay(Image("base").resizable().scaledToFit())
            
        }
    }
    static let gradientStart = Color(red: 221.0 / 255, green: 94.0 / 255, blue: 137.0 / 255)
    static let gradientEnd = Color(red: 247.0 / 255, green: 187.0 / 255, blue: 151.0 / 255)
}

struct BadgeBackground_Previews: PreviewProvider {
    static var previews: some View {
        BadgeBackground()
    }
}
