import UIKit
import SwiftUI
import MobileCoreServices

struct DocumentPicker: UIViewControllerRepresentable{

    @Binding var fileContent: String

    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController{

        let controller = UIDocumentPickerViewController(documentTypes: [String(kUTTypeXML)], in: .import)
        controller.delegate = context.coordinator
        
        return controller

    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator:NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    
        var parent: DocumentPicker
    
        init(_ parent: DocumentPicker) {
        self.parent = parent
        }
    
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]){
            let fileURL = urls[0]
            if let info = try! String(contentsOf: fileURL, encoding: .utf8) as String?{
                parent.fileContent = info
            }
        }
    }

}


