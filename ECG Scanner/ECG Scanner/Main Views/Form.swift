//
//  Form.swift
//  ECG Scanner
//
//  Created by Paco Gago on 05/05/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

import SwiftUI

struct FormView: View {
    
    @State private var name = ""
    @State private var lastName = ""
    @State private var hospital = ""
    @State private var diabetic = false
    @State private var age = 30
    
    var body: some View {
    
        
            
            Form{
                
                Section(header: Text("Datos generales")){
                    
                    // Nombre
                    TextField("Nombre", text: $name)
                    
                    //Apellidos
                    TextField("Apellidos", text: $lastName)
                    
                    // Hospital
                    Picker(selection: $hospital, label: Text("Hospital")){
                        ForEach(HospitalList.allHospitals, id: \.self){
                            hospital in Text(hospital).tag(hospital)
                        }
                    }
                    
                }
                
                Section(header: Text("Datos médicos")){
                    
                    // Diabético
                    Toggle(isOn: $diabetic, label: {
                        Text("Diabético")
                    })
                    
                    Stepper(value: $age, in: 0...120, label: {
                        Text("Edad: \(self.age) años")
                    })
                }
                
            }
            
        
        
    }
}

struct HospitalList {
    
    static let allHospitals = [
        "Puerto Real",
        "Cádiz",
        "Jerez de la Frontera",
        "Sevilla (Virgen del Rocío)"
    ]
    
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView()
    }
}
