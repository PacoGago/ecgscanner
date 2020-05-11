//
//  ContentView.swift
//  ECG Scanner
//
//  Created by Paco Gago on 05/05/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var cardNew: Card = Card(title: "Nuevo", subtitle: "Permite escaner una imagen de un ECG", img: "btn1")
    var cardAdd: Card = Card(title: "Añadir", subtitle: "Seleccionar un ECG anterior", img: "btn1")
    
    var body: some View {
        
        VStack{
            NavigationView {
                       
                       Section {
                           
                           VStack{
                               
                            CardView(card: cardNew).padding()
                            CardView(card: cardAdd).padding()
                           
                       }.navigationBarTitle(Text("ECG Scanner"))
                   }
            }
       
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
