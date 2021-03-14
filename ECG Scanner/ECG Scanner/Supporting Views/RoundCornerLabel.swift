import SwiftUI

struct RoundCornerLabelView: View {

    var text: String
    
    @State var heartRate = 0.0
    @State var rMSSD = 0.0
    @State var mRR = 0.0
    @State var sdnn = 0.0
    
    var body: some View {
        
        ZStack(alignment: .bottomTrailing) {
            
            Rectangle()
            .foregroundColor(.clear)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            
            VStack{

                Text("TC: " +  self.text)
                Text("rMSSD: " +  self.text)
                Text("mRR: " +  self.text)
                Text("SDNN: " +  self.text)


            }.padding(.all, 15.0)
            .overlay(
                RoundedRectangle(cornerRadius: 7.0)
                    .stroke(lineWidth: 2.0).padding(9.0)
            )
            
        }
    }
}

struct RoundCornerLabelView_Previews: PreviewProvider {
    static var previews: some View {
        RoundCornerLabelView(text: "107.90")
    }
}




