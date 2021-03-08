import SwiftUI

struct FormView: View {
    
    var fileContent: String
    
    // Variables del model: Esto se pasara a un modelo Paciente
    // Datos relativos al paciente
    @EnvironmentObject var patient: Patient
    
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
    @State private var bmiColor = Color(#colorLiteral(red: 0.8352941176, green: 0, blue: 0.1019607843, alpha: 1))
    
    @State var value : CGFloat = 0 // valor por defecto para el offset del teclado
    
    @State private var textStyle = UIFont.TextStyle.body
    
    @State private var isSheetCameraOrLibrary = false
    @State private var showingActionSheet = false
    @State private var isCamera = false
    @State private var imageIsSelected = true
    
    //Procesamos la imagen capturada
    func rgb2gray(imageOri: UIImage) -> UIImage{
        
        //Convertimos a una image de vista
        //var resImage = OpenCVWrapper.toGray(imageOri)!
        //let resImage = OpenCVWrapper.toGray(imageOri)!
        let resImage = OpenCVWrapper.im2bw(imageOri)!
        
        return resImage
    }
    
    func imageIsNullOrNot(imageName : UIImage) -> Bool{

       let size = CGSize(width: 0, height: 0)
        
       if (imageName.size.width == size.width){
        //self.imageIsSelected = false
        return false
       }else{
        //self.imageIsSelected = true
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
                            Text(self.imageIsNullOrNot(imageName: self.patient.ecg.imageSource) ? "Cambiar..." : "Seleccionar...")
                            Spacer()
                            Image(systemName: "camera.on.rectangle.fill").accentColor(self.imageIsNullOrNot(imageName: self.patient.ecg.imageSource) ? .green : .red)
                        }
                    })
                }.sheet(isPresented: $isSheetCameraOrLibrary) {
                    
                    if self.isCamera == true {
                        ImagePicker(sourceType: .camera, selectedImage: self.$patient.ecg.imageSource)
                    }else{
                        ImagePicker(sourceType: .photoLibrary, selectedImage: self.$patient.ecg.imageSource)
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
                            }.pickerStyle(WheelPickerStyle())
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
                                self.hospitalProvince = self.hospitalProvinces.names[self.selectionHospitalProvince]
                                self.hospitalNames = HospitalNames(province: self.hospitalProvinces.names[self.selectionHospitalProvince])
                            }.onDisappear{
                                self.hospitalProvince = self.hospitalProvinces.names[self.selectionHospitalProvince]
                                self.patient.hospitalProvidence = self.hospitalProvince
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
                                self.patient.hospital = self.hospitalNames.names[self.selectionHospitalName]
                            }.onDisappear{
                                self.patient.hospital = self.hospitalNames.names[self.selectionHospitalName]
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
         .navigationBarItems(trailing:NavigationLink(destination: DetailsView().onAppear {}){Text("Continuar")}.disabled(!self.imageIsNullOrNot(imageName: self.patient.ecg.imageSource))
        ).onAppear(){
            
            if !self.fileContent.isEmpty {
                
                let xml = XML(data: self.fileContent.data(using: .utf8)!)
                
                if let imageBase64 = xml?.image.$value.stringValue {
                    let dataDecoded : Data = Data(base64Encoded: imageBase64, options: .ignoreUnknownCharacters)!
                    let decodedimage = UIImage(data: dataDecoded)
                    self.patient.ecg.imageSource = decodedimage!
                }
                
                if let nombre = xml?.patient.name.firstname.stringValue {
                    self.patient.name = nombre
                }
                
                if let primerApellido = xml?.patient.name.firstsurname.stringValue {
                    self.patient.firstSurname = primerApellido
                }
                    
                if let segundoApellido = xml?.patient.name.secondsurname.stringValue  {
                    self.patient.secondSurname = segundoApellido
                }
                
                if let direccion = xml?.patient.address.stringValue {
                    self.patient.address = direccion
                }
                
                if let ciudad = xml?.patient.city.stringValue{
                    self.patient.city = ciudad
                }
                
                if let provincia = xml?.patient.province.stringValue {
                    self.selectionProvince = ConstantsViews.provinceOptions.firstIndex(of: provincia)!
                    self.patient.province = provincia
                }
                
                if let genero = xml?.patient.genre.stringValue {
                    if !genero.isEmpty{
                        self.selectionGenre = ConstantsViews.genderOptions.firstIndex(of: genero)!
                    }
                    self.patient.genre = genero
                }
                
                if let edad = xml?.patient.age.intValue {
                    self.selectionAge = edad
                    self.patient.age = edad
                }
                
                if let peso = xml?.patient.weight.doubleValue {
                    self.selectionWeight = self.IMCUtil.weightData().firstIndex(of: peso)!
                    self.patient.weight = peso
                }
                
//                if let peso = xml?.paciente.$peso.stringValue {
//                    self.selectionWeight = self.IMCUtil.weightData().firstIndex(of: Double(peso)!)!
//                    self.patient.weight = Double(peso)!
//                }
                
                if let peso = xml?.paciente.$peso.stringValue {
                    self.selectionWeight = self.IMCUtil.weightData().firstIndex(of: Double(peso)!)!
                    self.patient.weight = Double(peso)!
                }
                
                if let bmi = xml?.paciente.$bmi.stringValue{
                    self.patient.bmi = Double(bmi)!
                    self.bmiColor = self.IMCUtil.getAdultColorBMI(bmi_: self.patient.bmi)
                }
                
                if let altura = xml?.paciente.$altura.stringValue {
                    self.selectionHeight = Int(altura)!
                    self.patient.height = Int(altura)!
                }
                
                if let fumador = xml?.paciente.$fumador.stringValue {
                    self.patient.smoker = Bool(fumador)!
                }
                
                if let alergias = xml?.paciente.$alergias.stringValue {
                    self.patient.allergy = alergias
                }
                
                if let enfermedadCronica = xml?.paciente.$enfermedadCronica.stringValue {
                    self.patient.chronic = enfermedadCronica
                }
                
                if let medicacion = xml?.paciente.$medicacion.stringValue {
                    self.patient.medication = medicacion
                }
                
                if let hospitalProvidence = xml?.paciente.$hospitalProvidence.stringValue {
                    
                    if !hospitalProvidence.isEmpty{
                        self.selectionHospitalProvince = self.hospitalProvinces.names.firstIndex(of: hospitalProvidence)!
                        self.hospitalProvince = hospitalProvidence
                         self.hospitalNames = HospitalNames(province: self.hospitalProvinces.names[self.selectionHospitalProvince])
                    }
                    self.patient.hospitalProvidence = hospitalProvidence
                }
                
                if let hospital = xml?.paciente.$hospital.stringValue {
                    
                    if !hospital.isEmpty{
                        self.selectionHospitalName = self.hospitalNames.names.firstIndex(of: hospital)!
                    }
                    self.patient.hospital = hospital
                }
                
                if let origen = xml?.ecg.$origen.stringValue {
                    self.patient.ecg.origin = origen
                }
                
                if let equipamiento = xml?.ecg.$equipamiento.stringValue {
                    self.patient.ecg.ecgModel = equipamiento
                }
                
                if let presionSanguineaSistolica = xml?.ecg.$presionSanguineaSistolica.stringValue {
                    self.patient.ecg.bodypresssystolic = Double(presionSanguineaSistolica)!
                }
                
                if let presionSanguineaDiastolica = xml?.ecg.$presionSanguineaDiastolica.stringValue {
                    self.patient.ecg.bodypressdiastolic = Double(presionSanguineaDiastolica)!
                }
                
                if let temperatura = xml?.ecg.$temperatura.stringValue {
                    self.patient.ecg.bodytemp = Double(temperatura)!
                }
                
                if let glucosa = xml?.ecg.$glucosa.stringValue {
                    self.patient.ecg.glucose = Double(glucosa)!
                }
                
                if let motivo = xml?.ecg.$motivo.stringValue {
                    self.patient.ecg.reason = motivo
                }
                
                if let tipo = xml?.ecg.$tipo.stringValue {
                    self.patient.ecg.ecgType = tipo
                }
                
                if let tasaCardiaca = xml?.ecg.$tasaCardiaca.stringValue {
                    self.patient.ecg.heartRate = Double(tasaCardiaca)!
                }
            }
            
        }//END FORM
        
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView(fileContent: "")
    }
}
