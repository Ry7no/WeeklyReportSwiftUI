//
//  ImagePicker.swift
//  WeeklyReportSwiftUI
//
//  Created by @Ryan on 2023/8/12.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {

    @Binding var uiImage: UIImage?
    @Binding var isPresented: Bool
    
    func makeCoordinator() -> ImagePickerViewCoordinator {
        return ImagePickerViewCoordinator(uiImage: $uiImage, isPresented: $isPresented)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
 
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Nothing to update here
    }

}

class ImagePickerViewCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var uiImage: UIImage?
    @Binding var isPresented: Bool
    
    init(uiImage: Binding<UIImage?>, isPresented: Binding<Bool>) {
        self._uiImage = uiImage
        self._isPresented = isPresented
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            self.uiImage = image
            
            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

                let fileName = "userImage"
                let fileURL = documentsDirectory.appendingPathComponent(fileName)
                guard let data = image.jpegData(compressionQuality: 1) else { return }

                //Checks if file exists, removes it if so.
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    do {
                        try FileManager.default.removeItem(atPath: fileURL.path)
                        print("Removed old image")
                    } catch let removeError {
                        print("couldn't remove file at path", removeError)
                    }

                }

                do {
                    try data.write(to: fileURL)
                } catch let error {
                    print("error saving file with error", error)
                }
        }
        self.isPresented = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.isPresented = false
    }
    
}

