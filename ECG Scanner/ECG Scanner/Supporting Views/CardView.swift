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

            VStack {
                
                Text(card.description).font(.body).padding(5)
                
                Button(action: {
                    print("Estoy haciendo tap al botón")
                }) {
//                    Image(systemName: "faceid")
//                    .font(.largeTitle)
                    Text(card.buttonText)
                        .font(.body)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(Color.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .padding(10)

            }
            
        }
        .background(Color.white)
        .cornerRadius(20)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card(img: "btn1", description: "Title", buttonText: "Subtitle"))
    }
}

//#colorLiteral(red: 0.9999126792, green: 1, blue: 0.9998814464, alpha: 1)
