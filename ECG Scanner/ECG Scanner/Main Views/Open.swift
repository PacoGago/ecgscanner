import SwiftUI

struct OpenView: View {
        
    var body: some View {
    
        ZStack(alignment: .topLeading) {
        
            Text("Open View")
            
        }.frame(minWidth: 0, maxWidth: .infinity)
    }
}

struct OpenView_Previews: PreviewProvider {
    static var previews: some View {
        OpenView()
    }
}
