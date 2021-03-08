import Foundation
import SwiftUI

struct DetailsView: View {
    
    @EnvironmentObject var patient: Patient
    @State var tabIndex:Int = 0
    @State var resumePatientDataView = ResumePatientDataView()
    @State var testDataView = TestDataView()
    @State var ecgDataView = ECGDataView()
    @State var ecgChartView = ECGChartView()
    
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
             Button(action: {
                 
                self.writeFile()
                
             }) {
                 Text("Guardar")
             }
         )
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
                
                XML(name: "paciente", attributes: [
                    "nombre": patient.name,
                    "primerApellido": patient.firstSurname,
                    "segundoApellido": patient.secondSurname,
                    "direccion": patient.address,
                    "ciudad": patient.city,
                    "provincia": patient.province,
                    "genero": patient.genre,
                    "edad": patient.age,
                    "peso": patient.weight,
                    "altura": patient.height,
                    "fumador": patient.smoker,
                    "alergias": patient.allergy,
                    "enfermedadCronica": patient.chronic,
                    "medicacion": patient.medication,
                    "hospital": patient.hospital,
                    "bmi": patient.bmi,
                    "hospitalProvidence": patient.hospitalProvidence
                ]),
                XML(name: "ecg", attributes: [
                    "origen": patient.ecg.origin,
                    "equipamiento": patient.ecg.ecgModel,
                    "presionSanguineaSistolica": patient.ecg.bodypresssystolic,
                    "presionSanguineaDiastolica": patient.ecg.bodypressdiastolic,
                    "temperatura": patient.ecg.bodytemp,
                    "glucosa": patient.ecg.glucose,
                    "motivo": patient.ecg.reason,
                    "tipo": patient.ecg.ecgType,
                    "tasaCardiaca": patient.ecg.heartRate
                ]),
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
                    XML(name: "signalcharacteristics", value: "test"),
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

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView()
    }
}

public extension UIImage {
    var hasContent: Bool {
        return cgImage != nil || ciImage != nil
    }
}
