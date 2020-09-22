//
//  ECGEquipementModal.swift
//  ECG Scanner
//
//  Created by Paco Gago on 31/08/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

import SwiftUI

struct TitleDescriptionAndImageModalView: View {
    
    var info: Info

    var body: some View {
        
        VStack(alignment: .center) {
            
            Image(systemName: "info.circle.fill")
                .foregroundColor(.blue).padding().font(.system(size: 22, weight: .regular))
            
            Text(info.title).font(.title).foregroundColor(.blue).bold()
            
            Image(info.img).resizable()
            .frame(width: 200, height: 200, alignment: .center)
            
            Text(info.description)
                .font(.body).padding()
            
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
            
    } //View
}

struct TitleDescriptionAndImageModalView_Previews: PreviewProvider {
    static var previews: some View {
        TitleDescriptionAndImageModalView(info: Info(title: "Equipamiento", description: "Se trata del modelo de electrocardiógrafo que se esté usando para esta prueba en cuestión. También se puede indicar cualquier procdimiento de interés que pueda repercutir en los resultados.", img: "monitor_ecg") )
    }
}
