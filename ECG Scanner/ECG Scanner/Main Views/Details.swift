//
//  Details.swift
//  ECG Scanner
//
//  Created by Paco Gago on 28/07/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

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
        
        let store = XML(name: "ecg")
            .addAttribute(name: "xml:id", value: "test")
            .addChildren([
                // attributes can be added in the initializer
                XML(name: "image", attributes: [
                    "name": "football"
                ]),
                XML(name: "paciente", attributes: [
                    "nombre": patient.name
                ])
            ])
        
        let file = "ecg.xml"
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
