import SwiftUI
import MobileCoreServices

struct ContentView: View {
    
    @State private var showConfig = false
    @State private var showDocPicker = false
    @State private var user: String = UserDefaults.standard.string(forKey: "user") ?? ""
    @State private var pwd: String = UserDefaults.standard.string(forKey: "pwd") ?? ""
    @State private var jwt: String = UserDefaults.standard.string(forKey: "jwt") ?? ""
    @State private var preferences = APIPreferencesLoader.load()
    @State private var fileContent = ""
    @State private var showFileConfig = false
    @State private var next = true
    
    let APIUtils = APIUtilsImpl()
    
    var cardNew: Card = Card(
        img: "btn_new_scan",
        description: "Permite escaner una imagen de un ECG",
        buttonText: "Escanear un nuevo ECG",
        backgroundCardColor: Color.white,
        buttonFontColor: Color.white,
        buttonBackgroundColor: Color.blue,
        cardFontColor: Color.black,
        cardImageColor: Color.blue
    )
    
    var cardNewDisabled: Card = Card(
        img: "btn_new_scan",
        description: "Permite escaner una imagen de un ECG",
        buttonText: "Escanear un nuevo ECG",
        backgroundCardColor: Color.white,
        buttonFontColor: Color.white,
        buttonBackgroundColor: Color.gray,
        cardFontColor: Color.black,
        cardImageColor: Color.gray
    )
    
    var cardContinue: Card = Card(
        img: "btn_new_scan",
        description: "Ver datos del ECG escogido",
        buttonText: "Continuar",
        backgroundCardColor: Color.white,
        buttonFontColor: Color.white,
        buttonBackgroundColor: Color.green,
        cardFontColor: Color.black,
        cardImageColor: Color.green
    )
    
    var cardContinueDisabled: Card = Card(
        img: "btn_new_scan",
        description: "Ver datos del ECG escogido",
        buttonText: "Continuar",
        backgroundCardColor: Color.white,
        buttonFontColor: Color.white,
        buttonBackgroundColor: Color.gray,
        cardFontColor: Color.black,
        cardImageColor: Color.gray
    )
    
    var cardAdd: Card = Card(
        img: "btn_add_folder",
        description: "Seleccionar un ECG anterior",
        buttonText: "Seleccionar un fichero",
        backgroundCardColor: Color.white,
        buttonFontColor: Color.white,
        buttonBackgroundColor: Color.orange,
        cardFontColor: Color.black,
        cardImageColor: Color.orange
    )
    
    var cardAddDisabled: Card = Card(
        img: "btn_add_folder",
        description: "Seleccionar un ECG anterior",
        buttonText: "Seleccionar un fichero",
        backgroundCardColor: Color.white,
        buttonFontColor: Color.white,
        buttonBackgroundColor: Color.gray,
        cardFontColor: Color.black,
        cardImageColor: Color.gray
    )
    
    var cardAddOther: Card = Card(
        img: "btn_add_folder",
        description: "Seleccionar un ECG anterior",
        buttonText: "Seleccionar otro fichero",
        backgroundCardColor: Color.white,
        buttonFontColor: Color.white,
        buttonBackgroundColor: Color.orange,
        cardFontColor: Color.black,
        cardImageColor: Color.orange
    )
    
    var cardAddOtherDisabled: Card = Card(
        img: "btn_add_folder",
        description: "Seleccionar un ECG anterior",
        buttonText: "Seleccionar otro fichero",
        backgroundCardColor: Color.white,
        buttonFontColor: Color.white,
        buttonBackgroundColor: Color.gray,
        cardFontColor: Color.black,
        cardImageColor: Color.gray
    )
    
    var body: some View {
        
        VStack{
            
            NavigationView {
                
                ZStack {
                   
                    // Color del fondo
                    Color.init(#colorLiteral(red: 0.9441997409, green: 0.9489384294, blue: 0.9662023187, alpha: 1)).edgesIgnoringSafeArea(.all)
                    
                    Section {
                    
                        VStack{
                            
                            //Subtitle
                            Text("Digitalización de ECG")
                                .font(.body)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .offset(x: 0, y: 5)
                            
                            // Nuevo ECG
                            NavigationLink(destination: FormView(fileContent: self.fileContent)) {
                                
                                if (self.next){
                                  CardView(card: self.fileContent.isEmpty ? cardNew : cardContinue).padding()
                                }else{
                                  CardView(card: self.fileContent.isEmpty ? cardNewDisabled : cardContinueDisabled).padding()
                                }
                                
                                }.disabled(!self.next).offset(x: 0, y: -10)
                            
                            
                            // Import ECG
                            Button(action: {
                                self.showDocPicker.toggle()
                            }, label: {
                                
                                if (self.next){
                                  CardView(card: self.fileContent.isEmpty ? cardAdd : cardAddOther)
                                }else{
                                  CardView(card: self.fileContent.isEmpty ? cardAddDisabled : cardAddOther)
                                }
                                
                            }).disabled(!self.next)
                            .offset(x: 0, y: -30)
                            .padding()
                            .sheet(isPresented: self.$showDocPicker){
                                DocumentPicker(fileContent: self.$fileContent)
                            }
                            
                            
                            HStack{
                                
                                // Borrar fichero
                                // TODO: poner el fichero a 0
                                 Button(action: {
                                    self.fileContent = ""
                                 }, label: {
                                    if !self.fileContent.isEmpty {
                                        Image(systemName: "text.badge.minus")
                                         .font(.system(size: 22.0))
                                         .frame(width: 50, height: 50)
                                         .foregroundColor(.black)
                                        Text("Deseleccionar fichero").offset(x: -13, y: 2)
                                    }
                                     
                                 })
                                 .offset(x: -40, y: -45)
                                 
                                //Settings
                                Button(action: {
                                    self.showConfig.toggle()
                                }, label: {
                                    Image(systemName: "gear")
                                    .font(.system(size: 22.0))
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.black)
                                    //.offset(x: self.fileContent.isEmpty ? 150 : 38, y: self.fileContent.isEmpty ? -40 : -40)
                                }).offset(x: self.fileContent.isEmpty ? 150 : 38, y: self.fileContent.isEmpty ? -40 : -40)
                                .sheet(isPresented: self.$showConfig){
                                    SettingsView().onDisappear(){self.login()}
                                }
                                
                            }
                           
                        }.navigationBarTitle(Text("ECG Scanner"))
                        
                    }//Section
                    
                }//ZStack
            
            } //Navigation
       
        }.onAppear(){
            self.login()
        }
        
        //VStack
        
    }//body
    
    func login(){
        
        self.user = UserDefaults.standard.string(forKey: "user") ?? ""
        self.pwd = UserDefaults.standard.string(forKey: "pwd") ?? ""
        self.jwt = UserDefaults.standard.string(forKey: "jwt") ?? ""
        
        let parameters = "user=" + user + "&password=" + pwd
        let postData =  parameters.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: APIUtils.getProtocol(sslPreference: self.preferences.ssl) + "://" + self.preferences.baseURL + ":" + self.preferences.port + "/user")!,timeoutInterval: Double.infinity)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Control de conexion con la API
            if error != nil {
                self.showConfig.toggle()
                self.next = false
            }
            
            if let data = data {
                
                if let JWTResponse = try? JSONDecoder().decode(JWT.self, from: data){
                    
                    DispatchQueue.main.sync {
                        if(!JWTResponse.token.isEmpty && JWTResponse.token != "null"){
                            self.jwt = JWTResponse.token
                            UserDefaults.standard.set(self.jwt, forKey: "jwt")
                            self.next = true
                        }
                    }
                }else{
                    self.showConfig.toggle()
                    self.next = false
                }
            }
            
            }.resume()
        
    }
    
}

struct Intro_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

   
