import SwiftUI

struct ImageTextView: View {
    
    var img: Image
    var txt: Text
    
    var body: some View {
        HStack{
            img
            txt
        }
    }
}

struct ImageTextView_Previews: PreviewProvider {
    static var previews: some View {
        ImageTextView(img: Image(systemName: "bookmark"), txt: Text("Test"))
    }
}

