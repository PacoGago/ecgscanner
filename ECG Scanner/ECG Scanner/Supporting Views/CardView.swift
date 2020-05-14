//
//  CardView.swift
//  ECG Scanner
//
//  Created by Paco Gago on 11/05/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

import Foundation

import SwiftUI

struct CardView: View {
    
    var card: Card
    
    var body: some View {
       
        VStack(spacing: 0) {
            
            // Logo de la tarjeta
            Image(card.img)
                .resizable()
                .frame(width: 80.0, height: 80.0)
                .aspectRatio(contentMode: .fit)
                .padding(10)
                .foregroundColor(card.cardImageColor)

            VStack {
                
                Text(card.description)
                    .font(.body)
                    .padding(5)
                    .foregroundColor(card.cardFontColor)
                
                HStack{
//                    Image(systemName: "faceid")
//                    .font(.largeTitle)
                    Text(card.buttonText)
                        .font(.body)
                        .fontWeight(.bold)
                    
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(card.buttonFontColor)
                .padding()
                .background(card.buttonBackgroundColor)
                .cornerRadius(10)
                .padding(10)

            }
            
        }
        .background(card.backgroundCardColor)
        .cornerRadius(20)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card(img: "btn_new_scan", description: "Title", buttonText: "Subtitle", backgroundCardColor: Color.white, buttonFontColor: Color.white, buttonBackgroundColor: Color.blue, cardFontColor: Color.black,cardImageColor: Color.blue))
    }
}
