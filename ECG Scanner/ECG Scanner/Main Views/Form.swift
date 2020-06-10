//
//  Form.swift
//  ECG Scanner
//
//  Created by Paco Gago on 05/05/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

import SwiftUI

struct FormView: View {
    
    
    // Variables del model: Esto se pasara a un modelo Paciente
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
    @State private var weight = 60.0
    @State private var height = 170
    //Indice de masa corporal (body mass index)
    @State private var bmi = 21.25
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
    
    @State private var selectionHeight = 170
    @State private var pickerVisibleHeight = false
    
    @State private var bmiText = "(Normal)"
    @State private var bmiColor = Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
    
    @State var value : CGFloat = 0 // valor por defecto para el offset del teclado
    
    @State private var textStyle = UIFont.TextStyle.body

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
    
   
    //TODO: Sacar a una interfaz
    func getAdultCategoryBMI(bmi_: Double) -> String{
        
        if (bmi_ < 18.50){
            if (bmi_ < 16.0){
                return "(Delgadez severa)"
            }
            
            if (bmi_ >= 16.0 && bmi_ <= 16.99){
                return "(Delgadez moderada)"
            }
              
            if (bmi_ >= 17.00 && bmi_ <= 18.49){
                return "(Delgadez leve)"
            }
        }
        
        if (bmi_ >= 18.5 && bmi_ <= 24.99){
            return "(Normal)"
        }
        
        if (bmi_ >= 25.00 && bmi_ <= 29.99){
            return "(Sobrepeso)"
        }
        
        if (bmi_ >= 30.00 && bmi_ <= 34.99){
            return "(Obesidad leve)"
        }
        
        if (bmi_ >= 35.00 && bmi_ <= 39.99){
            return "(Obesidad media)"
        }
        
        if (bmi_ >= 40.00){
            return "(Obesidad mórbida)"
        }
        
        return ""
    }
    func getAdultColorBMI(bmi_: Double) -> Color{
        
        if (bmi_ < 18.50){
            if (bmi_ < 16.0){
                return Color(.red)
            }
            
            if (bmi_ >= 16.0 && bmi_ <= 16.99){
                return Color(.red)
            }
              
            if (bmi_ >= 17.00 && bmi_ <= 18.49){
                return Color(.orange)
            }
        }
        
        if (bmi_ >= 18.5 && bmi_ <= 24.99){
            return Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
        }
        
        if (bmi_ >= 25.00 && bmi_ <= 29.99){
            return Color(.orange)
        }
        
        if (bmi_ >= 30.00 && bmi_ <= 34.99){
            return Color(.red)
        }
        
        if (bmi_ >= 35.00 && bmi_ <= 39.99){
            return Color(.red)
        }
        
        if (bmi_ >= 40.00){
            return Color(.red)
        }
        
        return Color(.black)
    }
    
    var body: some View {
    
        
            
            Form{
                
                // DATOS GENERALES
                Section(header: Text("Datos generales")){
                    
                    
                    // Nombre
                    TextField("Nombre", text: $name).keyboardType(.numberPad)
                    
                    //Primer apellido
                    TextField("Primer apellido", text: $firstSurname).keyboardType(.default)
                    
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
                            }.onDisappear{
                                    self.province = ConstantsViews.provinceOptions[self.selectionProvince]
                            }
                            Spacer()
                        }
                    }
                    
                    
                }//END: First Section - Datos generales
                
            
                // DATOS MEDICOS
                Section(header: Text("Perfil de salud")){
                
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
                            }.onDisappear{
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
                                    
                            }.onDisappear{
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
                                
                                // Una vez introducido el peso debemos recalcular el BMI
                                self.bmi = Double(self.weight) / pow((Double(self.height)/100),2)
                                self.bmiText = self.getAdultCategoryBMI(bmi_: self.bmi)
                                self.bmiColor = self.getAdultColorBMI(bmi_: self.bmi)
                                
                            }.onDisappear{
                                
                                self.weight = self.weightData()[self.selectionWeight]
                                
                                // Una vez introducido el peso debemos recalcular el BMI
                                self.bmi = Double(self.weight) / pow((Double(self.height)/100),2)
                                self.bmiText = self.getAdultCategoryBMI(bmi_: self.bmi)
                                self.bmiColor = self.getAdultColorBMI(bmi_: self.bmi)
                                
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
                                self.height = self.selectionHeight
                                
                                // Una vez introducida la altura debemos recalcular el BMI
                                self.bmi = Double(self.weight) / pow((Double(self.height)/100),2)
                                self.bmiText = self.getAdultCategoryBMI(bmi_: self.bmi)
                                self.bmiColor = self.getAdultColorBMI(bmi_: self.bmi)

                            }
                            .onDisappear{
                                self.height = self.selectionHeight
                                
                                // Una vez introducida la altura debemos recalcular el BMI
                                self.bmi = Double(self.weight) / pow((Double(self.height)/100),2)
                                self.bmiText = self.getAdultCategoryBMI(bmi_: self.bmi)
                                self.bmiColor = self.getAdultColorBMI(bmi_: self.bmi)
                            }
                            
                            Spacer()
                        }
                    }//End Altura
                    
                    
                    //BMI
                    HStack{
                        Text("IMC " + self.bmiText).foregroundColor(bmiColor)
                        Spacer()
                        Button("\(String(format:"%.1f", self.bmi )) kg/m" + "\u{00B2}")
                        {}.foregroundColor(.gray)
                    }
                    
                    
                }
                        
                
                // DATOS MEDICOS
                Section(header: Text("Datos médicos")){
                    
                        // Diabético
                        Toggle(isOn: $smoker, label: {
                            Text("Fumador")
                        })
                        
                        TextField("Alergías", text: $chronic)
                        
                        TextField("Enf. Crónicas", text: $chronic)
                        
                        TextField("Medicación", text: $medication)
                        
                        TextField("Hospital", text: $hospital)

                }// END SECTION: DATOS MEDICOS
                
                
            // Con esto evitamos que los campos del
            // formulario queden ocultos
            }.offset(y: -self.value)
             .animation(.spring())
             .onAppear{
                
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main){ (noti) in
                    
                    let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                    let height = value.height
                    
                    self.value = height
                }
                
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main){ (noti) in
                    
                    self.value = 0
                }
            }//END FORM
            
        
        
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
