//
//  ContentView.swift
//  ECG Scanner
//
//  Created by Paco Gago on 05/05/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

import SwiftUI
import MobileCoreServices

struct ContentView: View {
    
    @State private var showConfig = false
    @State private var showDocPicker = false
    @State private var user: String = UserDefaults.standard.string(forKey: "user") ?? ""
    @State private var pwd: String = UserDefaults.standard.string(forKey: "pwd") ?? ""
    @State private var jwt: String = UserDefaults.standard.string(forKey: "jwt") ?? ""
    @State private var preferences = APIPreferencesLoader.load()
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
                            
                            //Nuevo ECG
                            NavigationLink(destination: FormView()) {
                                CardView(card: cardNew).padding()
                            }.offset(x: 0, y: -10)
                            
                            //Examinar un fichero
                            //TODO: Tenemos que indicar cual el tipo de fichero que queremos
                            //obtener con esta apertura.
                            Button(action: {
                                self.showDocPicker.toggle()
                            }, label: {
                                CardView(card: cardAdd).padding()
                            })
                            .offset(x: 0, y: -30)
                            .sheet(isPresented: self.$showDocPicker){
                                 DocumentPickerView()
                            }
                            
                            //Settings
                            Button(action: {
                                self.showConfig.toggle()
                            }, label: {
                                Image(systemName: "gear")
                                .font(.system(size: 22.0))
                                .frame(width: 50, height: 50)
                                .foregroundColor(.black)
                            })
                            .offset(x: 150, y: -40)
                            .sheet(isPresented: self.$showConfig){
                                SettingsView()
                            }
                           
                        }.navigationBarTitle(Text("ECG Scanner"))
                        
                    }//Section
                    
                }//ZStack
            
            }//Navigation
       
        }.onAppear(){
            self.login()
        }//VStack
        
    }//body
        
    func login(){
        
        let parameters = "user=" + user + "&password=" + pwd
        let postData =  parameters.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: APIUtils.getProtocol(sslPreference: self.preferences.ssl) + "://" + self.preferences.baseURL + ":" + self.preferences.port + "/user")!,timeoutInterval: Double.infinity)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        URLSession.shared.dataTask(with: request) { data, response, error in
          
            if let data = data {
                
                if let JWTResponse = try? JSONDecoder().decode(JWT.self, from: data){
                    
                    DispatchQueue.main.sync {
                        if(!JWTResponse.token.isEmpty && JWTResponse.token != "null"){
                            self.jwt = JWTResponse.token
                            UserDefaults.standard.set(self.jwt, forKey: "jwt")
                        }
                    }
                }else{
                    self.showConfig.toggle()
                }
            }
            
        }.resume()
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct DocumentPickerView: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
    let documentPicker = UIDocumentPickerViewController(documentTypes: [(kUTTypeImage as String)], in: .import)
    return documentPicker
  }

  func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {

  }
}
