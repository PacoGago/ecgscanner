//
//  Scan.swift
//  ECG Scanner
//
//  Created by Paco Gago on 21/07/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

import SwiftUI

struct ScanView: View {
        
    var body: some View {
    
        CameraViewController()
        .edgesIgnoringSafeArea(.top)
    }
}

struct ScanView_Previews: PreviewProvider {
    static var previews: some View {
        ScanView()
    }
}
