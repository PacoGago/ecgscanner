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
    @Published var heartRate = 80.0
    @Published var imagePro = UIImage()
    @Published var imageSource = UIImage()
    
}
