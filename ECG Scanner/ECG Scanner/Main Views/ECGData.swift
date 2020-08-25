//
//  ECGData.swift
//  ECG Scanner
//
//  Created by Paco Gago on 25/08/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

import SwiftUI

struct ECGDataView: View {
    
    @EnvironmentObject var p: Patient
    @State var smk: String = ""
    
    var body: some View {
        
        Text("Nombre: ").bold() + Text(p.name)
    }
}

struct ECGDataView_Previews: PreviewProvider {
    static var previews: some View {
        ECGDataView()
    }
}
