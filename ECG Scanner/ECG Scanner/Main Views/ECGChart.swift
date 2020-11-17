//
//  ECGChart.swift
//  ECG Scanner
//
//  Created by Paco Gago on 14/10/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

import SwiftUI
import Combine

typealias HTTPHeaders = [String: String]
typealias Parameters = [String: Any]

struct ECGChartView: View {
    
    @EnvironmentObject var p: Patient
    
    @State private var showLoadingView = true
    @State private var showDigitalizationView = false
    @State private var showErrorView = false
    
    let boundary = "example.boundary.\(ProcessInfo.processInfo.globallyUniqueString)"
    
    @State var values = [Double]()
    
    var body: some View {
        
        VStack{
            
            if showLoadingView {
                LoadingView().frame(width: 50, height: 50)
                .foregroundColor(.orange)
            }
            
            if showDigitalizationView {
                LineView(data: self.values, title: "", subtitle: "")
                .padding()
            }
            
            if showErrorView {
                Text("Error: ")
            }
            
        }.onAppear(perform: uploadImage)

    }
    
    func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    private func createHttpBody(binaryData: Data, mimeType: String) -> Data {
        
        let fieldName = "file"
        
        var postContent = "--\(boundary)\r\n"
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

        var request = URLRequest(url: URL(string: "http://192.168.1.33:8080/ecg/upload")!)
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
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
