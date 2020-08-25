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
    @EnvironmentObject var patient: Patient
    
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
    
    @State private var isSheetCameraOrLibrary = false
    @State private var showingActionSheet = false
    @State private var isCamera = false
    
    //Procesamos la imagen capturada
    func rgb2gray(imageOri: UIImage) -> UIImage{
        
        //Convertimos a una image de vista
        //var resImage = OpenCVWrapper.toGray(imageOri)!
        //let resImage = OpenCVWrapper.toGray(imageOri)!
        let resImage = OpenCVWrapper.im2bw(imageOri)!
        
        return resImage
    }
    
    func imageIsNullOrNot(imageName : UIImage)-> Bool{

       let size = CGSize(width: 0, height: 0)
       if (imageName.size.width == size.width)
        {
            return false
        }
        else
        {
            return true
        }
    }

    var body: some View {
            
        Form{
                //DATOS DE IMAGEN
                Section(header: ImageTextView(img: Image(systemName: "photo.fill"), txt: Text("Datos de Imagen").bold())){
                    Button(action: {
                        self.showingActionSheet = true
                    }, label: {
                        HStack {
                            Text(self.imageIsNullOrNot(imageName: self.patient.image) ? "Cambiar..." : "Seleccionar...")
                            Spacer()
                            Image(systemName: "camera.on.rectangle.fill").accentColor(self.imageIsNullOrNot(imageName: self.patient.image) ? .green : .red)
                        }
                    })
                }.sheet(isPresented: $isSheetCameraOrLibrary) {
                    
                    if self.isCamera == true {
                        ImagePicker(sourceType: .camera, selectedImage: self.$patient.image)
                    }else{
                        ImagePicker(sourceType: .photoLibrary, selectedImage: self.$patient.image)
                    }
                    
                }.actionSheet(isPresented: $showingActionSheet) {
                    ActionSheet(title: Text("Origen"), message: Text("Seleccione una opción"), buttons: [
                        .default(Text("Cámara")) {
                            self.isSheetCameraOrLibrary = true
                            self.isCamera = true
                        },
                        .default(Text("Librería")) {
                            self.isSheetCameraOrLibrary = true
                            self.isCamera = false
                        },
                        .cancel()
                    ])
                }
                // END SECTION: DATOS DE IMAGEN
            
                // DATOS GENERALES
                Section(header: ImageTextView(img: Image(systemName: "info.circle.fill"), txt: Text("Datos generales").bold())){
                    
                    // Nombre
                    TextField("Nombre", text: $patient.name)
                    
                    //Primer apellido
                    TextField("Primer apellido", text: $patient.firstSurname)
                    
                    //Segundo apellido
                    TextField("Segundo apellido", text: $patient.secondSurname)
                    
                    //Direccion
                    TextField("Dirección", text: $patient.address)
                   
                   //Ciudad
                   TextField("Ciudad", text: $patient.city)
                   
                    //Provincia
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
                                self.patient.province = ConstantsViews.provinceOptions[self.selectionProvince]
                            }.onDisappear{
                                self.patient.province = ConstantsViews.provinceOptions[self.selectionProvince]
                            }
                            Spacer()
                        }
                    }
                    
                    
                }//END: DATOS GENERALES
            
                // DATOS MEDICOS
                Section(header: ImageTextView(img: Image(systemName: "person.circle.fill"), txt: Text("Perfil de salud"))){
                
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
                                self.patient.genre = ConstantsViews.genderOptions[self.selectionGenre]
                            }.onDisappear{
                                self.patient.genre = ConstantsViews.genderOptions[self.selectionGenre]
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
                                self.patient.age = self.selectionAge
                                    
                            }.onDisappear{
                                self.patient.age = self.selectionAge
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
                                self.patient.weight = self.IMCUtil.weightData()[self.selectionWeight]
                                
                                // Una vez introducido el peso debemos recalcular el BMI
                                self.patient.bmi = Double(self.patient.weight) / pow((Double(self.patient.height)/100),2)
                                self.bmiText = self.IMCUtil.getAdultCategoryBMI(bmi_: self.patient.bmi)
                                self.bmiColor = self.IMCUtil.getAdultColorBMI(bmi_: self.patient.bmi)
                                
                            }.onDisappear{
                                
                                self.patient.weight = self.IMCUtil.weightData()[self.selectionWeight]
                                
                                // Una vez introducido el peso debemos recalcular el BMI
                                self.patient.bmi = Double(self.patient.weight) / pow((Double(self.patient.height)/100),2)
                                self.bmiText = self.IMCUtil.getAdultCategoryBMI(bmi_: self.patient.bmi)
                                self.bmiColor = self.IMCUtil.getAdultColorBMI(bmi_: self.patient.bmi)
                                
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
                                self.patient.height = self.selectionHeight
                                
                                // Una vez introducida la altura debemos recalcular el BMI
                                self.patient.bmi = Double(self.patient.weight) / pow((Double(self.patient.height)/100),2)
                                self.bmiText = self.IMCUtil.getAdultCategoryBMI(bmi_: self.patient.bmi)
                                self.bmiColor = self.IMCUtil.getAdultColorBMI(bmi_: self.patient.bmi)

                            }
                            .onDisappear{
                                self.patient.height = self.selectionHeight
                                
                                // Una vez introducida la altura debemos recalcular el BMI
                                self.patient.bmi = Double(self.patient.weight) / pow((Double(self.patient.height)/100),2)
                                self.bmiText = self.IMCUtil.getAdultCategoryBMI(bmi_: self.patient.bmi)
                                self.bmiColor = self.IMCUtil.getAdultColorBMI(bmi_: self.patient.bmi)
                            }
                            
                            Spacer()
                        }
                    }//End Altura
                    
                    
                    //BMI
                    HStack{
                        Text("IMC " + self.bmiText).foregroundColor(bmiColor)
                        Spacer()
                        Button("\(String(format:"%.1f", self.patient.bmi )) kg/m" + "\u{00B2}")
                        {}.foregroundColor(.gray)
                    }
                    
                    
                }
                        
                
                // DATOS MEDICOS
                Section(header: ImageTextView(img: Image(systemName: "heart.circle.fill"), txt: Text("Datos médicos"))){
                    
                    // Diabético
                    Toggle(isOn: $patient.smoker, label: {
                        Text("Fumador")
                    })
                    
                    TextField("Alergías", text: $patient.allergy)
                        .dismissKeyboardOnTap()

                    TextField("Enf. Crónicas", text: $patient.chronic)
                        .dismissKeyboardOnTap()
                    
                    TextField("Medicación", text: $patient.medication)
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
                                self.patient.hospital = self.hospitalNames.names[self.selectionHospitalName].capitalized
                            }.onDisappear{
                                self.patient.hospital = self.hospitalNames.names[self.selectionHospitalName].capitalized
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
                
        }.navigationBarTitle(Text("Paciente"), displayMode: .inline)
         .navigationBarItems(trailing:
            NavigationLink(destination: DetailsView().onAppear {
                //Revisar funcionamiento
                self.patient.image = OpenCVWrapper.toGray(self.patient.image)!
            }) {
                Text("Continuar")
            }
        )//END FORM
        
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView()
    }
}
