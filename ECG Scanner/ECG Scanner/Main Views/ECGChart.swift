import SwiftUI
import Combine

typealias HTTPHeaders = [String: String]
typealias Parameters = [String: Any]

struct ECGChartView: View {
    
    @EnvironmentObject var p: Patient
    
    @State private var showLoadingView = true
    @State private var showDigitalizationView = false
    @State private var showErrorView = false
    @State private var preferences = APIPreferencesLoader.load()
    @State private var jwt: String = UserDefaults.standard.string(forKey: "jwt") ?? ""
    
    let boundary = "example.boundary.\(ProcessInfo.processInfo.globallyUniqueString)"
    let APIUtils = APIUtilsImpl()
    
    @State var values = [Double]()
    
    @GestureState private var isPressed = false
    
    @GestureState private var dragOffset = CGSize.zero
    @State private var position = CGSize.zero
    
    @State private var errorMsg = "Por favor, pruebe con otro fichero o contacte con el administrador si el error persiste."
    
    var body: some View {
        
        VStack{
            
            if showLoadingView {
                LoadingView().frame(width: 50, height: 50)
                .foregroundColor(.orange)
            }
            
            if showDigitalizationView {
                
                LineView(data: self.values, title: "", subtitle: "")
                    .scaleEffect(isPressed ? 1.5 : 1.0)
                    .offset(x: position.width + dragOffset.width, y: position.height + dragOffset.height)
                    .animation(.easeInOut)
                    .gesture(
                        LongPressGesture(minimumDuration: 1.0)
                        .updating($isPressed, body: { (currentState, state, transaction) in
                            state = currentState
                        })
                        .sequenced(before: DragGesture())
                        .updating($dragOffset, body: { (value, state, transaction) in

                            switch value {
                            case .first(true):
                                print("Tapping")
                            case .second(true, let drag):
                                state = drag?.translation ?? .zero
                            default:
                                break
                            }

                        })
                        .onEnded({ (value) in

                            guard case .second(true, let drag?) = value else {
                                return
                            }

                            self.position.height += drag.translation.height
                            self.position.width += drag.translation.width
                        })
                    )
            }
            
            if showErrorView {
                Text("Error: " + errorMsg).padding()
            }
            
        }.onAppear(perform: uploadImage)
        
        

    }
    
    func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    private func createParamBodyItem(paramValue: Bool, paramName: String) -> String {
        
        var postContent = "--\(boundary)\r\n"
        postContent += "Content-Disposition:form-data; name=\"\(paramName)\""
        postContent += "\r\nContent-Type: text"
        postContent += "\r\n\r\n\(paramValue.description)\r\n"

        return postContent
    }
    
    private func createParamBodyItem(paramValue: Double, paramName: String) -> String {
        
        let paramValueString: String = String(format: "%.2f", paramValue)
        
        var postContent = "--\(boundary)\r\n"
        postContent += "Content-Disposition:form-data; name=\"\(paramName)\""
        postContent += "\r\nContent-Type: text"
        postContent += "\r\n\r\n\(paramValueString)\r\n"

        return postContent
    }
    
    private func createParamBodyItem(paramValue: Int, paramName: String) -> String {
        
        var postContent = "--\(boundary)\r\n"
        postContent += "Content-Disposition:form-data; name=\"\(paramName)\""
        postContent += "\r\nContent-Type: text"
        postContent += "\r\n\r\n\(paramValue)\r\n"
        
        return postContent
    }
    
    private func createParamBodyItem(paramValue: String, paramName: String) -> String {
        
        var postContent = "--\(boundary)\r\n"
        postContent += "Content-Disposition:form-data; name=\"\(paramName)\""
        postContent += "\r\nContent-Type: text"
        postContent += "\r\n\r\n\(paramValue)\r\n"
        
        return postContent
    }
    
    private func createHttpBody(binaryData: Data, mimeType: String) -> Data {
        
        let fieldName = "file"
        var postContent = ""
        
        // Parametros con datos (son opcionales en la API)
        
        if (!p.genre.isEmpty){
             postContent += createParamBodyItem(paramValue: p.genre, paramName: "genre")
        }else{
            postContent += createParamBodyItem(paramValue: "Hombre", paramName: "genre")
        }
        
        postContent += createParamBodyItem(paramValue: p.age, paramName: "age")
        
        postContent += createParamBodyItem(paramValue: p.weight, paramName: "weight")
        
        postContent += createParamBodyItem(paramValue: p.height, paramName: "height")
        
        postContent += createParamBodyItem(paramValue: p.bmi, paramName: "bmi")
        
        postContent += createParamBodyItem(paramValue: p.smoker, paramName: "smoker")
        
        if (!p.allergy.isEmpty){
            postContent += createParamBodyItem(paramValue: p.allergy, paramName: "allergy")
        }
        
        if (!p.chronic.isEmpty){
            postContent += createParamBodyItem(paramValue: p.chronic, paramName: "chronic")
        }
        
        if (!p.medication.isEmpty){
            postContent += createParamBodyItem(paramValue: p.medication, paramName: "medication")
        }
        
        if (!p.hospital.isEmpty){
            postContent += createParamBodyItem(paramValue: p.hospital, paramName: "hospital")
        }
        
        if (!p.hospitalProvidence.isEmpty){
            postContent += createParamBodyItem(paramValue: p.hospitalProvidence, paramName: "hospitalProvidence")
        }
        
        if (!p.ecg.origin.isEmpty){
            postContent += createParamBodyItem(paramValue: p.ecg.origin, paramName: "origin")
        }
        
        if (!p.ecg.ecgModel.isEmpty){
            postContent += createParamBodyItem(paramValue: p.ecg.ecgModel, paramName: "ecgModel")
        }
        
        postContent += createParamBodyItem(paramValue: p.ecg.bodypresssystolic, paramName: "bodypresssystolic")
        
        postContent += createParamBodyItem(paramValue: p.ecg.bodypressdiastolic, paramName: "bodypressdiastolic")
        
        postContent += createParamBodyItem(paramValue: p.ecg.bodytemp, paramName: "bodytemp")
        
        postContent += createParamBodyItem(paramValue: p.ecg.glucose, paramName: "glucose")
        
        if (!p.ecg.reason.isEmpty){
            postContent += createParamBodyItem(paramValue: p.ecg.reason, paramName: "reason")
        }
        
        if (!p.ecg.ecgType.isEmpty){
            postContent += createParamBodyItem(paramValue: p.ecg.ecgType, paramName: "ecgType")
        }
        
        postContent += createParamBodyItem(paramValue: p.ecg.heartRate, paramName: "heartRate")
        
        // Imagen
        
        postContent += "--\(boundary)\r\n"
        
        let fileName = "\(UUID().uuidString).jpeg"
        postContent += "Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n"
        postContent += "Content-Type: \(mimeType)\r\n\r\n"

        var data = Data()
        guard let postData = postContent.data(using: .utf8) else { return data }
        data.append(postData)
        data.append(binaryData)

        guard let endData = "\r\n--\(boundary)--\r\n".data(using: .utf8) else { return data }
        data.append(endData)
        return data
    }
    
    func uploadImage() {
        
        var headers: HTTPHeaders {
            return [
                "Content-Type": "multipart/form-data; boundary=\(boundary)",
                "Accept": "application/json"
            ]
        }
        
        let imageData = p.ecg.imageSource.jpegData(compressionQuality: 1)!
        let mimeType = imageData.mimeType!

        var request = URLRequest(url: URL(string: APIUtils.getProtocol(sslPreference: self.preferences.ssl) + "://" + self.preferences.baseURL + ":" + self.preferences.port + "/ecg/upload")!)
        
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(self.jwt, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        request.httpBody = createHttpBody(binaryData: imageData, mimeType: mimeType)
        
        URLSession.shared.dataTask(with: request){ data, response, error in
            
            if let data = data {
                
                if let ECGResponse = try? JSONDecoder().decode(ECGJSON.self, from: data){
                    
                    DispatchQueue.main.async {
                        self.values = ECGResponse.values
                        self.showLoadingView = false
                        self.showDigitalizationView = true
                    }

                    return
                }
            }
            
            if (error?.localizedDescription == "Could not connect to the server."){
                self.errorMsg = "Error no se ha podido conectar con el servidor."
            }
            
            // En caso de error
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            self.showErrorView = true
            self.showLoadingView = false
            
        }.resume()
        
    }
    
}

struct ECGJSON : Codable {
    
    let file: String
    let id: Int
    let values: [Double]
    
    private enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case file = "file"
        case values = "values"
    }
}


struct ECGChartView_Previews: PreviewProvider {
    static var previews: some View {
        ECGChartView()
        
    }
}

extension Data {

    var mimeType: String? {
        var values = [UInt8](repeating: 0, count: 1)
        copyBytes(to: &values, count: 1)

        switch values[0] {
        case 0xFF:
            return "image/jpeg"
        case 0x89:
            return "image/png"
        case 0x47:
            return "image/gif"
        case 0x49, 0x4D:
            return "image/tiff"
        default:
            return nil
        }
    }
}
