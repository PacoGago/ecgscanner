import Foundation
import SwiftUI

struct DetailsView: View {
    
    @EnvironmentObject var patient: Patient
    @State var tabIndex:Int = 0
    @State var resumePatientDataView = ResumePatientDataView()
    @State var testDataView = TestDataView()
    @State var ecgDataView = ECGDataView()
    @State var ecgChartView = ECGChartView()
    @Binding var shouldPopToRootView : Bool
    @State private var isAlert = false
    @State private var isAlertInfo = false
    @State private var alertText = ""
    
    var body: some View {
        
        TabView(selection: $tabIndex) {
            
            ecgDataView.tabItem { Group{
                    Image(systemName: "doc.richtext")
                    Text("Datos ECG")
                }}.tag(0)
            
            resumePatientDataView.tabItem { Group{
                    Image(systemName: "person")
                    Text("Paciente")
                }}.tag(1)
            
            ecgChartView.tabItem { Group{
                Image(systemName: "waveform.path.ecg")
                Text("Visualizar")
            }}.tag(2)
            
            }.navigationBarTitle(Text("Resumen"), displayMode: .inline)
            .navigationBarItems(trailing:
            
            HStack{
                
                Button (action: {
                    self.isAlert = true
                }){
                    Image(systemName: "trash").frame(width: 30.0, height: 30.0)
                }.padding()
                .alert(isPresented: $isAlert) { () -> Alert in
                    Alert(title: Text("Limpiar datos"), message: Text("¿Desea borrar los datos del paciente?"), primaryButton: .default(Text("Sí"), action: {
                        self.flushPatient()
                        self.shouldPopToRootView = false
                    }), secondaryButton: .default(Text("Cancelar")))
                }
                
                Button(action: {
                   self.writeFile()
                }) {
                   Image(systemName: "tray.and.arrow.down")
                }
                
                if (self.tabIndex == 2 && self.hasAlert()) {
                    Button(action: {
                        self.alertInfo()
                        self.isAlertInfo = true
                    }) {
                       Image(systemName: "info.circle")
                    }.padding().padding(.top,4)
                    .alert(isPresented: $isAlertInfo) { () -> Alert in
                        Alert(
                            title: Text("Información"),
                            message:
                            Text(self.alertText)
                        )
                    }
                }
            }
        )
    }
    
    func hasAlert() -> Bool{
        if (self.patient.ecg.heartRate != 0.0 || self.patient.ecg.heartRate != nil){return true}
        if (self.patient.ecg.mRR != 0.0 || self.patient.ecg.mRR != nil){return true}
        if (self.patient.ecg.rMSSD != 0.0 || self.patient.ecg.rMSSD != nil){return true}
        if (self.patient.ecg.SDNN != 0.0 || self.patient.ecg.SDNN != nil){return true}
        return false
    }
    
    func alertInfo() -> Void {
        
        if (self.patient.ecg.heartRate != 0.0 && self.patient.ecg.heartRate != nil) {
            self.alertText = "Tasa Cardiáca: " + self.patient.ecg.heartRate!.description + "\r\n"
        }
        
        if (self.patient.ecg.mRR != 0.0 && self.patient.ecg.mRR != nil){
            self.alertText = self.alertText + "mRR: " + self.patient.ecg.mRR!.description + "\r\n"
        }
        
        if (self.patient.ecg.rMSSD != 0.0 && self.patient.ecg.rMSSD != nil) {
            self.alertText = self.alertText + "rMSSD: " + self.patient.ecg.rMSSD!.description + "\r\n"
        }
        
        if (self.patient.ecg.SDNN != 0.0 && self.patient.ecg.SDNN != nil) {
            self.alertText = self.alertText + "SDNN: " + self.patient.ecg.SDNN!.description + "\r\n"
        }
    }

    func flushPatient() -> Void{
        
        self.patient.name = ""
        self.patient.firstSurname = ""
        self.patient.secondSurname = ""
        self.patient.address = ""
        self.patient.city = ""
        self.patient.province = ""
        self.patient.postalCode = ""
        self.patient.genre = ""
        self.patient.age = 30
        self.patient.weight = 60.0
        self.patient.height = 170
        self.patient.bmi = 21.25
        self.patient.smoker = false
        self.patient.allergy = ""
        self.patient.chronic = ""
        self.patient.medication = ""
        self.patient.hospital = ""
        self.patient.hospitalProvidence = ""
        self.patient.ecg = ECG()
        
    }
    
    func writeFile() -> Void{
        
        var fileName = "ECG-DATA"
        
        if !patient.name.isEmpty {
            fileName = patient.name.replacingOccurrences(of: " ", with: "-")
            fileName = fileName.trimmingCharacters(in: .whitespaces).lowercased()
            fileName = fileName.folding(options: .diacriticInsensitive, locale: .current)
        }
        
        var strBase64 = ""
        if patient.ecg.imageSource.hasContent {
            let imageData:NSData = patient.ecg.imageSource.pngData()! as NSData
            strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        }
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let hourandminutes = formatter.string(from: date)
        formatter.dateFormat = "yyyy-MM-dd"
        let dateXML = formatter.string(from: date)
        
        let store = XML(name: "ecgXml")
            .addChildren([
                
                XML(name: "manufacturer").addChildren([
                    XML(name: "model", value: patient.ecg.ecgModel)
                ]),
                XML(name: "patient").addChildren([
                    XML(name: "name").addChildren([
                        XML(name: "firstname", value: patient.name),
                        XML(name: "firstsurname", value: patient.firstSurname),
                        XML(name: "secondsurname", value: patient.secondSurname)
                    ]),
                    XML(name: "address", value: patient.address),
                    XML(name: "city", value: patient.city),
                    XML(name: "province", value: patient.province),
                    XML(name: "genre", value: patient.genre.isEmpty ? "Hombre" : patient.genre),
                    XML(name: "age", value: patient.age),
                    XML(name: "weight", value: patient.weight),
                    XML(name: "height", value: patient.height),
                    XML(name: "bmi", value: patient.bmi),
                    XML(name: "smoker", value: patient.smoker),
                    XML(name: "allergy", value: patient.allergy),
                    XML(name: "chronic", value: patient.chronic),
                    XML(name: "medication", value: patient.medication),
                    XML(name: "hospitalProvidence", value: patient.hospitalProvidence),
                    XML(name: "hospital", value: patient.hospital),
                    XML(name: "origin", value: patient.ecg.origin),
                    XML(name: "bodypresssystolic", value: patient.ecg.bodypresssystolic),
                    XML(name: "bodypressdiastolic", value: patient.ecg.bodypressdiastolic),
                    XML(name: "bodytemp", value: patient.ecg.bodytemp),
                    XML(name: "glucose", value: patient.ecg.glucose),
                    XML(name: "reason", value: patient.ecg.reason),
                    XML(name: "ecgType", value: patient.ecg.ecgType),
                    XML(name: "heartRate", value: patient.ecg.heartRate)
                ]),
                XML(name: "date_time").addChildren([
                    XML(name: "date", value: dateXML),
                    XML(name: "time", value: hourandminutes)
                ]),
                XML(name: "waveforms").addChildren([
                    XML(name: "mRR", value: patient.ecg.mRR),
                    XML(name: "rMSSD", value: patient.ecg.rMSSD),
                    XML(name: "SDNN", value: patient.ecg.SDNN),
                    XML(name: "parsedwaveform", value: patient.ecg.values)
                ]),
                XML(name: "image", attributes: [
                    "value": strBase64
                ])
            ])
        
        let file = fileName + ".xml"
        let dir = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(file)
        let contents = store.toXMLString()

        do {
            try contents.write(to: dir!, atomically: true, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
        }

        var filesToShare = [Any]()
        filesToShare.append(dir!)
        let av = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
        av.isModalInPresentation = true
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
    
}

public extension UIImage {
    var hasContent: Bool {
        return cgImage != nil || ciImage != nil
    }
}
