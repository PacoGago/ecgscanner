//
//  ECG.swift
//  ECG Scanner
//
//  Created by Paco Gago on 31/08/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

import SwiftUI

class ECG: ObservableObject{
    
    @Published var origin = ""
    @Published var ecgModel = ""
    
    //presion sanguinea (Body Pressure)
    @Published var bodypress: Double?
    
    //temperatura corporal (body-temperature)
    @Published var bodytemp: Double?
    @Published var glucose: Double?
    @Published var reason = ""
    @Published var ecgType = ""
    @Published var heartRate = ""
    
    @Published var imagePro = UIImage()
    @Published var imageSource = UIImage()
    
    /*
     Image(uiImage: p.ecg.imageSource)
     .resizable()
     .scaledToFit()
     */
    
}
