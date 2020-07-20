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
    
    // Variables de la vista
    @State private var hospitalProvinces = HospitalProvinces()
    @State private var selectionHospitalProvince = 0
    @State private var pickerVisibleHospitalProvince = false
    @State private var hospitalProvince = ""
    @State private var hospitalNames = HospitalNames()
    @State private var selectionHospitalName = 0
    @State private var pickerVisibleHospitalName = false
    @State private var hospitalName = ""

    @State private var selectionProvince = 0
    @State private var pickerVisibleProvince = false
    
    @State private var selectionGenre = 0
    @State private var pickerVisibleGenre = false
    
    @State private var selectionAge = 30
    @State private var pickerVisibleAge = false
    
    let IMCUtil = IMCUtilsImpl()
    @State private var selectionWeight = 100
    @State private var pickerVisibleWeight = false
    @State private var selectionHeight = 170
    @State private var pickerVisibleHeight = false
    @State private var bmiText = "(Normal)"
    @State private var bmiColor = Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
    
    @State var value : CGFloat = 0 // valor por defecto para el offset del teclado
    
    @State private var textStyle = UIFont.TextStyle.body


    
    var body: some View {
    
        
            
            Form{
                
                // DATOS GENERALES
                Section(header: Text("Datos generales")){
                    
                    
                    // Nombre
                    TextField("Nombre", text: $name)
                    
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
                        Button(IMCUtil.sanitanizeDoubleWeight(weight_: IMCUtil.weightData()[selectionWeight]) + " kg"){
                            self.pickerVisibleWeight.toggle()
                        }.foregroundColor(self.pickerVisibleWeight ? .red : .blue)
                    }

                    if pickerVisibleWeight {

                        HStack{
                            Spacer()
                            Picker(selection: $selectionWeight, label: Text("")) {

                                ForEach((0..<self.IMCUtil.weightData().count)) {

                                    Text(self.IMCUtil.sanitanizeDoubleWeight(weight_: self.IMCUtil.weightData()[$0]) + " kg")
                                        .foregroundColor(.secondary)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .onTapGesture {
                                self.pickerVisibleWeight.toggle()
                                self.weight = self.IMCUtil.weightData()[self.selectionWeight]
                                
                                // Una vez introducido el peso debemos recalcular el BMI
                                self.bmi = Double(self.weight) / pow((Double(self.height)/100),2)
                                self.bmiText = self.IMCUtil.getAdultCategoryBMI(bmi_: self.bmi)
                                self.bmiColor = self.IMCUtil.getAdultColorBMI(bmi_: self.bmi)
                                
                            }.onDisappear{
                                
                                self.weight = self.IMCUtil.weightData()[self.selectionWeight]
                                
                                // Una vez introducido el peso debemos recalcular el BMI
                                self.bmi = Double(self.weight) / pow((Double(self.height)/100),2)
                                self.bmiText = self.IMCUtil.getAdultCategoryBMI(bmi_: self.bmi)
                                self.bmiColor = self.IMCUtil.getAdultColorBMI(bmi_: self.bmi)
                                
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
                                self.bmiText = self.IMCUtil.getAdultCategoryBMI(bmi_: self.bmi)
                                self.bmiColor = self.IMCUtil.getAdultColorBMI(bmi_: self.bmi)

                            }
                            .onDisappear{
                                self.height = self.selectionHeight
                                
                                // Una vez introducida la altura debemos recalcular el BMI
                                self.bmi = Double(self.weight) / pow((Double(self.height)/100),2)
                                self.bmiText = self.IMCUtil.getAdultCategoryBMI(bmi_: self.bmi)
                                self.bmiColor = self.IMCUtil.getAdultColorBMI(bmi_: self.bmi)
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
                    
                    TextField("Alergías", text: $allergy)
                        .dismissKeyboardOnTap()

                    TextField("Enf. Crónicas", text: $chronic)
                        .dismissKeyboardOnTap()
                    
                    TextField("Medicación", text: $medication)
                        .dismissKeyboardOnTap()
                    
                    //Hospital
                    HStack{
                        Text("Hospital:")
                    }
                    
                    HStack{
                        Text("Provincia")
                        Spacer()
                        Button(self.hospitalProvinces.names[selectionHospitalProvince].capitalized){
                            self.pickerVisibleHospitalProvince.toggle()
                        }.foregroundColor(self.pickerVisibleHospitalProvince ? .red : .blue)
                    }

                    if pickerVisibleHospitalProvince {
                        
                        HStack{
                            Spacer()
                            Picker(selection: $selectionHospitalProvince, label: Text("")) {
                                ForEach(0..<self.hospitalProvinces.names.count) {
                                    Text(self.hospitalProvinces.names[$0].capitalized).foregroundColor(.secondary)
                                }

                            }.pickerStyle(WheelPickerStyle())
                            .onTapGesture {
                                self.pickerVisibleHospitalProvince.toggle()
                                self.hospitalProvince = self.hospitalProvinces.names[self.selectionHospitalProvince].capitalized
                                self.hospitalNames = HospitalNames(province: self.hospitalProvinces.names[self.selectionHospitalProvince])
                            }.onDisappear{
                                self.hospitalProvince = self.hospitalProvinces.names[self.selectionHospitalProvince].capitalized
                                self.hospitalNames = HospitalNames(province: self.hospitalProvinces.names[self.selectionHospitalProvince])
                            }
                            Spacer()
                        }
                    }
                    
                    HStack{
                        Text("Nombre")
                        Spacer()
                        Button(self.hospitalNames.names[selectionHospitalName].capitalized){
                            self.pickerVisibleHospitalName.toggle()
                        }.foregroundColor(self.pickerVisibleHospitalName ? .red : .blue)
                    }

                    if pickerVisibleHospitalName {
                        
                        HStack{
                            Spacer()
                            Picker(selection: $selectionHospitalName, label: Text("")) {
                                ForEach(0..<self.hospitalNames.names.count) {
                                    Text(self.hospitalNames.names[$0].capitalized).foregroundColor(.secondary)
                                }

                            }.pickerStyle(WheelPickerStyle())
                            .onTapGesture {
                                self.pickerVisibleHospitalName.toggle()
                                self.hospital = self.hospitalNames.names[self.selectionHospitalName].capitalized
                            }.onDisappear{
                                self.hospital = self.hospitalNames.names[self.selectionHospitalName].capitalized
                            }
                            Spacer()
                        }
                    }
                    
                    

                }// END SECTION: DATOS MEDICOS
                
                
            // Con esto evitamos que los campos del
            // formulario queden ocultos
            }.offset(y: -self.value)
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
                
            }//END FORM
        
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView()
    }
}
