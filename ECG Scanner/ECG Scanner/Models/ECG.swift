import SwiftUI

class ECG: ObservableObject{
    
    @Published var origin = ""
    @Published var ecgModel = ""
    @Published var bodypresssystolic = 120.0
    @Published var bodypressdiastolic = 80.0
    @Published var bodytemp = 36.5
    @Published var glucose = 80.0
    @Published var reason = ""
    @Published var ecgType = ""
    @Published var heartRate: Double?
    @Published var rMSSD: Double?
    @Published var mRR: Double?
    @Published var SDNN: Double?
    @Published var imagePro = UIImage()
    @Published var imageSource = UIImage()
    @Published var values = [Double]()
    
}
