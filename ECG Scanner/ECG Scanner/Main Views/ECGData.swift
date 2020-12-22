//
//  ECGData.swift
//  ECG Scanner
//
//  Created by Paco Gago on 25/08/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

import SwiftUI

struct ECGDataView: View {
    
    @EnvironmentObject var p: Patient
    @State var smk: String = ""
    
    // Datos asociados al ECG del paciente
    //@State private var origin = ""
    //@State private var ecgModel = ""
    //presion sanguinea (Body Pressure)
    //@State private var bp = 30
    //temperatura corporal (body-temperature)
    //@State private var bt = 30
    //@State private var glucose = 30
    //@State private var reason = ""
    //@State private var ecgType = ""
    //@State private var heartRate = ""
    
    //Variables de la vista
    @State private var ecgequipementModalView: Bool = false
    @State var value : CGFloat = 0 // valor por defecto para el offset del teclado
    
    var body: some View {
        
        Form{
            
            Section(header: ImageTextView(img: Image(systemName: "photo.fill"), txt: Text("Imagen seleccionada").bold())){
                
                Image(uiImage: p.ecg.imageSource)
                .resizable()
                .scaledToFit()
                
            }
            
            // DATOS GENERALES
            Section(header: ImageTextView(img: Image(systemName: "info.circle.fill"), txt: Text("Datos de la prueba").bold())){
                
                // Nombre
                TextField("Origen: ", text: $p.ecg.origin)
                
                // Equipamiento
                HStack {
                    
                    TextField("Equipamiento:", text: $p.ecg.ecgModel)
                    Spacer()
                    
                    Button(action: {
                        self.ecgequipementModalView.toggle()
                    }) {
                        Image(systemName: "info.circle")
                        .accentColor(.gray)
                    }.sheet(isPresented: $ecgequipementModalView) {
                        // Modal con informacion
                        TitleDescriptionAndImageModalView(info: Info(title: "Equipamiento", description: "Se trata del modelo de electrocardiógrafo que se esté usando para esta prueba en cuestión.", img: "monitor_ecg"))
                    }
                }
                // END: Equipamiento
                
                // Presión Sanguínea
                TextField("Presión Sanguínea: ", value: $p.ecg.bodypress, formatter: NumberFormatter()).keyboardType(.decimalPad)
                
                // Temperatura
                TextField("Temperatura: ", value: $p.ecg.bodytemp, formatter: NumberFormatter()).keyboardType(.decimalPad)
                
                // Glucosa
                
                TextField("Glucosa: ", value: $p.ecg.glucose, formatter: NumberFormatter()).keyboardType(.decimalPad)
                
                // Motivo de la prueba
                TextField("Motivo de la prueba: ", text: $p.ecg.reason)
                
                // Tipo de ECG
                TextField("Tipo de ECG: ", text: $p.ecg.ecgType)
                
                // Tasa cardíaca
                TextField("Tasa cardíaca: ", text: $p.ecg.heartRate)
            
                
            }//END: DATOS GENERALES
            
        }
         .offset(y: -self.value)
         .animation(.spring())
         .onAppear{
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main){ (noti) in
                
                let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                
                // Es un ajuste en la altura. en principio deberia ir bien sin el -80
                // Pero no se ajusta adecuadamente. Habria que realizar pruebas en distintos
                // dispositivos para obtener un delta lo adecuado para cada dispositivo
                let height = value.height - 80
                
                self.value = height
            }
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main){ (noti) in
                
                self.value = 0
            }
                
        }//Form
    }
}

struct ECGDataView_Previews: PreviewProvider {
    static var previews: some View {
        ECGDataView()
        
    }
}
