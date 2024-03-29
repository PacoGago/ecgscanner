import SwiftUI

class Patient: ObservableObject{
    
    @Published var id = ""
    @Published var name = ""
    @Published var firstSurname = ""
    @Published var secondSurname = ""

    @Published var address = ""
    @Published var city = ""
    @Published var province = ""
    @Published var postalCode = ""

    @Published var genre = ""
    @Published var age = 30
    @Published var weight = 60.0
    @Published var height = 170
    
    //Indice de masa corporal (body mass index)
    @Published var bmi = 21.25
    @Published var smoker = false
    @Published var allergy = ""
    @Published var chronic = ""
    @Published var medication = ""
    @Published var hospital = ""
    @Published var hospitalProvidence = ""
    
    @Published var ecg = ECG()
    
}
