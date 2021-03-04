import SwiftUI

struct PointView: View {
    
    var label: String
    
    var body: some View {
        
        Circle()
        .strokeBorder(Color.blue,lineWidth: 2)
        .background(Circle().foregroundColor(Color.red))
        .frame(width: 10, height: 10, alignment: .center)
            .overlay(Text(label).bold().foregroundColor(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))).padding(.top, 30))
        
    }
    
}

struct PointView_Previews: PreviewProvider {
    static var previews: some View {
        PointView(label: "R")
    }
}
