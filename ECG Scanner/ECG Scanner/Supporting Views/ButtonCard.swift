//
//  ButtonCard.swift
//  ECG Scanner
//
//  Created by Paco Gago on 11/05/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

import SwiftUI

struct Cards: View {
    var body: some View {
       
        VStack(spacing: 0) {
            
            // Logo de la tarjeta
            Image("btn1")
                .resizable()
                .frame(width: 100.0, height: 100.0)
                .aspectRatio(contentMode: .fit)
                .padding()

            HStack {
                
                // Texto
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text("Title")
                        .font(.title)
                        .foregroundColor(.primary)
                        .lineLimit(3)
                    Text("Subtitle")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .layoutPriority(100)

                Spacer()
                
                //Indicador
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(Font.body.weight(.semibold))
            }
            .padding(.all, 10)
            .background(Color.gray) // This is a custom color set
        }
        .cornerRadius(10)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        )
       
    }
}

struct Cards_Previews: PreviewProvider {
    static var previews: some View {
        Cards()
    }
}
