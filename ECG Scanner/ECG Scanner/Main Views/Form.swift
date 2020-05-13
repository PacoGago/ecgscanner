//
//  Form.swift
//  ECG Scanner
//
//  Created by Paco Gago on 05/05/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

import SwiftUI

struct Form: View {
    var body: some View {
    
        Button(action: {
            print("Estoy haciendo tap al botón")
        }) {
            Text("Iniciar Sesión")
                .font(.title)
                .fontWeight(.bold)
        }
        .foregroundColor(Color.white)
        .padding()
        .background(Color.blue)
        .cornerRadius(10)
    }
}

struct Form_Previews: PreviewProvider {
    static var previews: some View {
        Form()
    }
}
