import SwiftUI

struct ECGDataView: View {
    
    @EnvironmentObject var p: Patient
    @State var smk: String = ""
    
    //Variables de la vista
    @State private var ecgequipementModalView: Bool = false
    @State var value : CGFloat = 0 // valor por defecto para el offset del teclado
    
    // Binding para la conversion de text to double
    var bodypresssystolic: Binding<String> {
        Binding<String>(
            get: { String(format: "%.02f", Double(self.p.ecg.bodypresssystolic)) },
            set: {
                let newString = $0.replacingOccurrences(of: ",", with: ".")
                self.p.ecg.bodypresssystolic = (newString as NSString).doubleValue
            }
        )
    }
    
    var bodypressdiastolic: Binding<String> {
        Binding<String>(
            get: { String(format: "%.02f", Double(self.p.ecg.bodypressdiastolic)) },
            set: {
                let newString = $0.replacingOccurrences(of: ",", with: ".")
                self.p.ecg.bodypressdiastolic = (newString as NSString).doubleValue
            }
        )
    }
    
    var bodytemp: Binding<String> {
        Binding<String>(
            get: { String(format: "%.02f", Double(self.p.ecg.bodytemp)) },
            set: {
                let newString = $0.replacingOccurrences(of: ",", with: ".")
                self.p.ecg.bodytemp = (newString as NSString).doubleValue
            }
        )
    }
    
    var glucose: Binding<String> {
        Binding<String>(
            get: { String(format: "%.02f", Double(self.p.ecg.glucose)) },
            set: {
                let newString = $0.replacingOccurrences(of: ",", with: ".")
                self.p.ecg.glucose = (newString as NSString).doubleValue
            }
        )
    }
    
    var heartRate: Binding<String> {
        Binding<String>(
            get: { String(format: "%.02f", Double(self.p.ecg.heartRate)) },
            set: {
                let newString = $0.replacingOccurrences(of: ",", with: ".")
                self.p.ecg.heartRate = (newString as NSString).doubleValue
            }
        )
    }
    
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
                
                // Motivo de la prueba
                TextField("Motivo de la prueba: ", text: $p.ecg.reason)
                
                // Tipo de ECG
                TextField("Tipo de ECG: ", text: $p.ecg.ecgType)
                
                HStack {
                    Text("Presión Sistólica (mmHg):")
                    TextField(" ", text: bodypresssystolic).keyboardType(.decimalPad)
                }
                
                HStack {
                    Text("Presión Diastólica (mmHg):")
                    TextField(" ", text: bodypressdiastolic).keyboardType(.decimalPad)
                }
                
                HStack {
                    Text("Temperatura (ºC):")
                    TextField(" ", text: bodytemp).keyboardType(.decimalPad)
                }
                
                HStack {
                    Text("Glucosa (mg/dl):")
                    TextField(" ", text: glucose).keyboardType(.decimalPad)
                }
                
                HStack {
                    Text("Tasa cardíaca (PPM):")
                    TextField(" ", text: heartRate).keyboardType(.decimalPad)
                }
                
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

extension String {
    static let numberFormatter = NumberFormatter()
    var doubleValue: Double {
        String.numberFormatter.decimalSeparator = "."
        if let result =  String.numberFormatter.number(from: self) {
            return result.doubleValue
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result = String.numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        return 0
    }
}
