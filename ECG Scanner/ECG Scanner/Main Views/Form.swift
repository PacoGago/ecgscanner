//
//  Form.swift
//  ECG Scanner
//
//  Created by Paco Gago on 05/05/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

import SwiftUI

struct FormView: View {
    
    
    // Variables del model
    // Datos relativos al paciente
    @State private var id = ""
    @State private var name = ""
    @State private var firstSurname = ""
    @State private var secondSurname = ""
    
    @State private var address = ""
    @State private var city = ""
    @State private var province = ""
    @State private var postalCode = ""
    
    @State private var genre = ""
    @State private var age = 30
    @State private var weight = 30
    @State private var height = 30
    //Indice de masa corporal (body mass index)
    @State private var bmi = ""
    @State private var smoker = false
    @State private var allergy = ""
    @State private var chronic = ""
    @State private var medication = ""
    @State private var hospital = ""
    
    
    // Datos asociados al ECG del paciente
    @State private var origin = ""
    @State private var ecgModel = ""
    //presion sanguinea (Body Pressure)
    @State private var bp = 30
    //temperatura corporal (body-temperature)
    @State private var bt = 30
    @State private var glucose = 30
    @State private var reason = ""
    @State private var ecgType = ""
    @State private var heartRate = ""
    
    // Variables de la vista
    private var genderOptions = ["Hombre", "Mujer"]
    private var ageOptions = [0,1,2,3,4,5,6,7,8,9,10]
    @State private var selectionGenre = 0
    @State private var pickerVisibleGenre = false
    @State private var selectionAge = 30
    @State private var pickerVisibleAge = false


    
    var body: some View {
    
        
            
            Form{
                
                Section(header: Text("Datos generales")){
                    
                    
                    // Nombre
                    TextField("Nombre", text: $name)
                    
                    //Primer apellido
                    TextField("Primer apellido", text: $firstSurname)
                    
                    //Segundo apellido
                    TextField("Segundo apellido", text: $secondSurname)
                    
                    
                }//Datos generales
                
                Section(header: Text("")){
                    
                    //Direccion
                    TextField("Dirección", text: $address)
                    
                    //Ciudad
                    TextField("Ciudad", text: $city)
                    
                    //Provincia
                    TextField("Provincia", text: $province)
                    
                    //PostaCode
                    TextField("C.P", text: $postalCode)
                    
                    
                    //Genero
                    HStack{
                        Text("Género")
                        Spacer()
                        Button(genderOptions[selectionGenre]){
                            self.pickerVisibleGenre.toggle()
                        }.foregroundColor(self.pickerVisibleGenre ? .red : .blue)
                    }
                    
                    if pickerVisibleGenre {
                        HStack{
                            Spacer()
                            Picker(selection: $selectionGenre, label: Text("")) {
                                ForEach(0..<genderOptions.count) {
                                    Text(self.genderOptions[$0]).foregroundColor(.secondary)
                                }
        
                            }.pickerStyle(WheelPickerStyle())
                                .onTapGesture {
                                    self.pickerVisibleGenre.toggle()
                                    self.genre = self.genderOptions[self.selectionGenre]
                            }
                            Spacer()
                        }
                    }
                    
                    //Edad
                    HStack{
                        Text("Edad")
                        Spacer()
                        Button("\(self.selectionAge )"){
                            self.pickerVisibleAge.toggle()
                        }.foregroundColor(self.pickerVisibleAge ? .red : .blue)
                    }
                    
                    if pickerVisibleAge {
                        HStack{
                            Spacer()
                            Picker(selection: $selectionAge, label: Text("")) {
                                ForEach((1...120), id: \.self) {
                                    Text("\($0)").foregroundColor(.secondary)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .onTapGesture {
                                self.pickerVisibleAge.toggle()
                                self.age = self.selectionAge
                                    
                            }
                            Spacer()
                        }
                    }
                    
                }
                   
                    

                    
                
                
                
                
                
                
                
                
                Section(header: Text("Datos médicos")){
                    
                    // Diabético
                    Toggle(isOn: $smoker, label: {
                        Text("Diabético")
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
