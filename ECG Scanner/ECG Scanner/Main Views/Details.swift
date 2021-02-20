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
        
        let store = XML(name: "ecg")
            .addAttribute(name: "xml:id", value: "test")
            .addChildren([
                
                XML(name: "image", attributes: [
                    "value": strBase64
                ]),
                XML(name: "paciente", attributes: [
                    "nombre": patient.name,
                    "primer-apellido": patient.firstSurname,
                    "segundo-apellido": patient.secondSurname,
                    "direccion": patient.address,
                    "ciudad": patient.city,
                    "provincia": patient.province,
                    "genero": patient.genre,
                    "edad": patient.age,
                    "peso": patient.weight,
                    "altura": patient.height,
                    "fumador": patient.smoker,
                    "alergias": patient.allergy,
                    "enfermedad-cronica": patient.chronic,
                    "medicacion": patient.hospital
                    
                ]),
                XML(name: "ecg", attributes: [
                    "origen": patient.ecg.origin,
                    "equipamiento": patient.ecg.ecgModel,
                    "presion-sanguinea-sistolica": patient.ecg.bodypresssystolic,
                    "presion-sanguinea-diastolica": patient.ecg.bodypressdiastolic,
                    "temperatura": patient.ecg.bodytemp,
                    "glucosa": patient.ecg.glucose,
                    "motivo": patient.ecg.reason,
                    "tipo": patient.ecg.ecgType,
                    "tasa-cardiaca": patient.ecg.heartRate
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
