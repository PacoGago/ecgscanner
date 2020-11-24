//
//  Details.swift
//  ECG Scanner
//
//  Created by Paco Gago on 28/07/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

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
            NavigationLink(destination: ContentView()) {
                Text("Guardar")
            }
        )
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView()
    }
}
