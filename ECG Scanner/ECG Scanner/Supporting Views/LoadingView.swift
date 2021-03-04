import SwiftUI

struct LoadingView: View {
    
    @State private var showRate = false
    @State private var heartBeat = false

    var body: some View{
        
        ZStack {
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
        
            Image("heart")
                .scaleEffect(heartBeat ? 1 : 1.3)
                .animation(Animation.interpolatingSpring(stiffness: 30, damping: 10).speed(1.3/2).repeatForever(autoreverses: false))
                .onAppear() {
                    self.heartBeat.toggle()
                       }
             
            Image("pulse")
                .clipShape(Rectangle().offset(x: showRate ? 0 : -125))
                .animation(Animation.interpolatingSpring(
                            stiffness: 30, damping: 10).speed(1.3).repeatForever(autoreverses: true).delay(0.2))
                .offset(x: -12)
                .onAppear() {
                    self.showRate.toggle()
            }

            Text("Cargando...")
                    .foregroundColor(Color(#colorLiteral(red: 0.8352941176, green: 0, blue: 0.1882352941, alpha: 1)))
                    .font(.system(size: 15))
                    .bold()
                    .offset(y:92)
        }
        
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
        
    }
}
