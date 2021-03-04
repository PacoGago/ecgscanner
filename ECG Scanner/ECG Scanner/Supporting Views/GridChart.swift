import SwiftUI

struct GridChartView: View {
    
    var body: some View{
        
       ZStack {
        
            VStack {
                ForEach(0 ..< 224) { item in
                    Divider().background(Color.init(#colorLiteral(red: 0.8661872745, green: 0.3543272018, blue: 0.4709339142, alpha: 1)))
                }
            }
            
            HStack {
                ForEach(0 ..< 224) { item in
                    Divider().background(Color.init(#colorLiteral(red: 0.8661872745, green: 0.3543272018, blue: 0.4709339142, alpha: 1)))
                }
            }
            
        }
        
    }
}

struct GridChartView_Previews: PreviewProvider {
    static var previews: some View {
        GridChartView()
    }
}
