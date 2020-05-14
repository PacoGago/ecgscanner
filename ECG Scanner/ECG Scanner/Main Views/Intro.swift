//
//  ContentView.swift
//  ECG Scanner
//
//  Created by Paco Gago on 05/05/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var cardNew: Card = Card(
        img: "btn_new_scan",
        description: "Permite escaner una imagen de un ECG",
        buttonText: "Escanear un nuevo ECG",
        backgroundCardColor: Color.white,
        buttonFontColor: Color.white,
        buttonBackgroundColor: Color.blue,
        cardFontColor: Color.black,
        cardImageColor: Color.blue
    )
    
    var cardAdd: Card = Card(
        img: "btn_add_folder",
        description: "Seleccionar un ECG anterior",
        buttonText: "Seleccionar un fichero",
        backgroundCardColor: Color.white,
        buttonFontColor: Color.white,
        buttonBackgroundColor: Color.orange,
        cardFontColor: Color.black,
        cardImageColor: Color.orange
    )
    
    var body: some View {
        
        VStack{
            
            NavigationView {
                
                ZStack {
                   
                    // Color del fondo
                    Color.init(#colorLiteral(red: 0.9441997409, green: 0.9489384294, blue: 0.9662023187, alpha: 1)).edgesIgnoringSafeArea(.all)
                    
                    Section {
                    
                        VStack{
                            
                            Text("Subtitle de ECG")
                                .font(.body)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .offset(x: 0, y: -20)
                            
                            //Nuevo ECG
                            NavigationLink(destination: Form()) {
                                CardView(card: cardNew).padding()
                            }.offset(x: 0, y: -20)
                            
                            //Examinar un fichero
                            NavigationLink(destination: Form()) {
                                CardView(card: cardAdd).padding()
                            }.offset(x: 0, y: -20)
                           
                        }.navigationBarTitle(Text("ECG Scanner"))
                        
                    }//Section
                    
                }//ZStack
            
            }//Navigation
       
        }//VStack
        
    }//body
    
}//View

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
