//
//  ContentView.swift
//  ECG Scanner
//
//  Created by Paco Gago on 05/05/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        
        
        VStack{
            NavigationView {
                       
                       Section {
                           
                           VStack{
                               
                               // Nuevo
                               NavigationLink(destination: Form()) {
                                   HStack {
                                       Image(systemName: "plus.circle")
                                           .font(.body)
                                       Text("Nuevo")
                                           .fontWeight(.semibold)
                                           .font(.body)
                                           .frame(width: 80 , height: 15, alignment: .center)

                                   }
                                   .padding()
                                   .foregroundColor(.white)
                                   .background(Color.red)
                                   .cornerRadius(5)

                               }//END: Nuevo

                               // Cargar
                               NavigationLink(destination: Form()) {
                                   HStack {
                                      Image(systemName: "square.and.arrow.down")
                                          .font(.body)
                                      Text("Abrir...")
                                          .fontWeight(.semibold)
                                          .font(.body)
                                          .frame(width: 80 , height: 15, alignment: .center)
                                   }
                                   .padding()
                                   .foregroundColor(.white)
                                   .background(Color.red)
                                   .cornerRadius(5)
                               }//END: Cargar
                           }.padding(180)
                           
                           
                       }.navigationBarTitle(Text("ECG Scanner"))
                   }
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
