//
//  ContentView.swift
//  ECG Scanner
//
//  Created by Paco Gago on 05/05/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var cardNew: Card = Card(img: "btn1", description: "Permite escaner una imagen de un ECG", buttonText: "Nuevo")
    var cardAdd: Card = Card(img: "btn1", description: "Seleccionar un ECG anterior", buttonText: "Añadir")
    
    var body: some View {
        
        VStack{
            NavigationView {
                   ZStack {
                    Color.init(#colorLiteral(red: 0.9441997409, green: 0.9489384294, blue: 0.9662023187, alpha: 1)).edgesIgnoringSafeArea(.all)
                       Section {
                           
                           VStack{
                               
                            CardView(card: cardNew).padding()
                            CardView(card: cardAdd).padding()
                           
                       }.navigationBarTitle(Text("ECG Scanner"))
                   }
                    
                }//ZStack
            
            }//Navigation
       
        }//VStack
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
