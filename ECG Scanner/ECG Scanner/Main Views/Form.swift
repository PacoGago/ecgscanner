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
    @State private var weight = 50.0
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
    
    
    @State private var selectionProvince = 0
    @State private var pickerVisibleProvince = false
    
    @State private var selectionGenre = 0
    @State private var pickerVisibleGenre = false
    
    @State private var selectionAge = 30
    @State private var pickerVisibleAge = false
    
    @State private var selectionWeight = 100
    @State private var pickerVisibleWeight = false
    
    @State private var selectionHeight = 168
    @State private var pickerVisibleHeight = false

    func weightData() -> [Double]{
        
        var res = Array<Double>()
        
        for index in 1...657 {
            res.append(Double(index))
            res.append(Double(index)+0.5)
        }

        return res
    }
    
    func sanitanizeDoubleWeight(weight_: Double) -> String{
        
        //var weightString = String(format:"%.1f", weight_)
        return String(format:"%.1f", weight_)
    }
    
    func sanitanizeAge(weight_: Int) -> String{
        
        //var weightString = String(format:"%.1f", weight_)
        return String(format:"%.1f", weight_)
    }
    
    var body: some View {
    
        
            
            Form{
                
                // DATOS GENERALES
                Section(header: Text("Datos generales")){
                    
                    
                    // Nombre
                    TextField("Nombre", text: $name).keyboardType(.numberPad)
                    
                    //Primer apellido
                    TextField("Primer apellido", text: $firstSurname)
                    
                    //Segundo apellido
                    TextField("Segundo apellido", text: $secondSurname)
                    
                    //Direccion
                   TextField("Dirección", text: $address)
                   
                   //Ciudad
                   TextField("Ciudad", text: $city)
                   
                    //Genero
                    HStack{
                        Text("Provincia")
                        Spacer()
                        Button(ConstantsViews.provinceOptions[selectionProvince]){
                            self.pickerVisibleProvince.toggle()
                        }.foregroundColor(self.pickerVisibleProvince ? .red : .blue)
                    }
                    
                    if pickerVisibleProvince {
                        HStack{
                            Spacer()
                            Picker(selection: $selectionProvince, label: Text("")) {
                                ForEach(0..<ConstantsViews.provinceOptions.count) {
                                    Text(ConstantsViews.provinceOptions[$0]).foregroundColor(.secondary)
                                }
        
                            }.pickerStyle(WheelPickerStyle())
                                .onTapGesture {
                                    self.pickerVisibleProvince.toggle()
                                    self.province = ConstantsViews.provinceOptions[self.selectionProvince]
                            }
                            Spacer()
                        }
                    }
                    
                    
                }//END: First Section - Datos generales
                
            
                // DATOS MEDICOS
                Section(header: Text("Datos médicos")){
                
                    //Genero
                    HStack{
                        Text("Género")
                        Spacer()
                        Button(ConstantsViews.genderOptions[selectionGenre]){
                            self.pickerVisibleGenre.toggle()
                        }.foregroundColor(self.pickerVisibleGenre ? .red : .blue)
                    }
                    
                    if pickerVisibleGenre {
                        HStack{
                            Spacer()
                            Picker(selection: $selectionGenre, label: Text("")) {
                                ForEach(0..<ConstantsViews.genderOptions.count) {
                                    Text(ConstantsViews.genderOptions[$0]).foregroundColor(.secondary)
                                }
        
                            }.pickerStyle(WheelPickerStyle())
                                .onTapGesture {
                                    self.pickerVisibleGenre.toggle()
                                    self.genre = ConstantsViews.genderOptions[self.selectionGenre]
                            }
                            Spacer()
                        }
                    }
                    
                    //Edad
                    HStack{
                        Text("Edad")
                        Spacer()
                        Button("\(self.selectionAge ) " + (self.selectionAge>1 ? "años" : "año")){
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
                    }//End Edad
                    
                    //Peso
                    HStack{
                        Text("Peso")
                        Spacer()
                        Button(self.sanitanizeDoubleWeight(weight_: self.weightData()[selectionWeight]) + " kg"){
                            self.pickerVisibleWeight.toggle()
                        }.foregroundColor(self.pickerVisibleWeight ? .red : .blue)
                    }

                    if pickerVisibleWeight {

                        HStack{
                            Spacer()
                            Picker(selection: $selectionWeight, label: Text("")) {

                                ForEach((0..<weightData().count)) {

                                    Text(self.sanitanizeDoubleWeight(weight_: self.weightData()[$0]) + " kg")
                                        .foregroundColor(.secondary)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .onTapGesture {
                                self.pickerVisibleWeight.toggle()
                                self.weight = self.weightData()[self.selectionWeight]

                            }
                            Spacer()
                        }
                    }//End Peso
                    
                    //Altura
                    HStack{
                        Text("Altura")
                        Spacer()
                        Button("\(self.selectionHeight) cm"){
                            self.pickerVisibleHeight.toggle()
                        }.foregroundColor(self.pickerVisibleHeight ? .red : .blue)
                    }

                    if pickerVisibleHeight {
                        HStack{
                            Spacer()
                            Picker(selection: $selectionHeight, label: Text("")) {
                                ForEach((1...299), id: \.self) {
                                    Text("\($0) cm").foregroundColor(.secondary)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .onTapGesture {
                                self.pickerVisibleHeight.toggle()
                                self.age = self.selectionHeight

                            }
                            Spacer()
                        }
                    }//End Altura
                    
                }
                        
                
                // DATOS MEDICOS
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
