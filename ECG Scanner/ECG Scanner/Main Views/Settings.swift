import SwiftUI

struct SettingsView: View {
    
    let lightGrey = Color(red: 240.0/255.0,
                          green: 242.0/255.0,
                          blue: 245.0/255.0,
                          opacity: 1.0)
    
    //Variables de la vista
    @State private var ecgequipementModalView: Bool = false
    @State private var value : CGFloat = 0 // valor por defecto para el offset del teclado
    @State private var user: String = UserDefaults.standard.string(forKey: "user") ?? ""
    @State private var pwd: String = UserDefaults.standard.string(forKey: "pwd") ?? ""
    @State private var invalidAttempts = 0
    @State private var invalidUser = 0
    @State private var invalidPwd = 0
    @State private var jwt: String = UserDefaults.standard.string(forKey: "jwt") ?? ""
    @State private var error: String = ""
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        
        ZStack(alignment: .top){
            
            Color.init(#colorLiteral(red: 1, green: 0.7382662296, blue: 0, alpha: 1)).edgesIgnoringSafeArea(.all)
                       
            VStack(spacing: 15){
                
                Text("Datos de acceso").font(.system(size: 40)).bold()
                Image("login").resizable().frame(width: 78.0, height: 100.0)
                Text(self.error)
                    .font(.system(size: 15))
                    .foregroundColor(.red)
                    .bold()
                
                HStack{
                    Image(systemName: "person")
                        .foregroundColor(.secondary)
                    TextField("Usuario", text: $user)
                }
                .padding()
                .background(lightGrey)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 1)
                .foregroundColor(invalidAttempts == 0 ? Color.clear : Color.red))
                .modifier(ShakeEffect(animatableData: CGFloat(invalidAttempts)))
                .modifier(ShakeEffect(animatableData: CGFloat(invalidUser)))
                
                HStack{
                    Image(systemName: "lock")
                        .foregroundColor(.secondary)
                    SecureField("Contraseña", text: $pwd)
                }
                .padding()
                .background(lightGrey)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 1)
                .foregroundColor(invalidAttempts == 0 ? Color.clear : Color.red))
                .modifier(ShakeEffect(animatableData: CGFloat(invalidAttempts)))
                .modifier(ShakeEffect(animatableData: CGFloat(invalidPwd)))
                
                Spacer().frame(height: 2)
                
                Button(action:{
                    if(self.validate()){
                        self.login()
                    }
                }, label: {
                     Text("Acceder")
                        .font(.headline).bold()
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 250, height: 60)
                        .background(Color.init(#colorLiteral(red: 0.3449254036, green: 0.2717448175, blue: 0.6082604527, alpha: 1)))
                        .cornerRadius(10)
                })
                
            }.padding()
        
        }.onDisappear(){
            
            UserDefaults.standard.set(self.user, forKey: "user")
            UserDefaults.standard.set(self.pwd, forKey: "pwd")
            UserDefaults.standard.set(self.jwt, forKey: "jwt")
        }
        
    }
    
    func validate() -> Bool{
        
        var res = true
        
        if(user.isEmpty && pwd.isEmpty){
            withAnimation(.default){
                self.invalidAttempts += 1
            }
            self.error = "Debe introducir los datos de acceso."
            res = false
        }else{
            if(user.isEmpty){
                withAnimation(.default){
                    self.invalidUser += 1
                }
                self.error = "Debe introducir el usuario."
                res = false
            }else if(pwd.isEmpty){
                withAnimation(.default){
                    self.invalidPwd += 1
                }
                self.error = "Debe introducir la contraseña."
                res = false
            }
        }
        
        return res
    }
    
    func login (){
          
        let parameters = "user=" + user + "&password=" + pwd
        let postData =  parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "http://192.168.1.33:8080/user")!,timeoutInterval: Double.infinity)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        URLSession.shared.dataTask(with: request) { data, response, error in
          
            if let data = data {
                
                if let JWTResponse = try? JSONDecoder().decode(JWT.self, from: data){
                    
                    DispatchQueue.main.async {
                        if(!JWTResponse.token.isEmpty && JWTResponse.token != "null"){
                            self.jwt = JWTResponse.token
                        }
                        self.presentation.wrappedValue.dismiss()
                    }
                }else{
                    self.error = "Los datos de acceso son incorrectos."
                    withAnimation(.default){
                        self.invalidAttempts += 1
                    }
                }
                
                return
            }
            
            // En caso de error
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            
        }.resume()
    }
    
}

struct ShakeEffect: GeometryEffect{
    
    var travelDistance : CGFloat = 6
    var numOfShakes : CGFloat = 4
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: travelDistance * sin(animatableData * .pi * numOfShakes), y: 0))
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
