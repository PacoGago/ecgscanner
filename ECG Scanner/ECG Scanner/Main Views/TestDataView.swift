import SwiftUI

struct TestDataView: View {
    
    @EnvironmentObject var p: Patient
    @State var smk: String = ""
    
    var body: some View {
        
        VStack{
            
            Image(uiImage: p.ecg.imageSource)
            .resizable()
            .scaledToFit()
            
            Image(uiImage: p.ecg.imagePro)
            .resizable()
            .scaledToFit()
        }
    }
}

struct TestDataView_Previews: PreviewProvider {
    static var previews: some View {
        TestDataView()
    }
}
