//
//  SwiftUIImagePicker.swift
//  Wannado
//
//  Created by admin on 2023/8/24.
//

import Foundation
import SwiftUI
import UIKit

struct SwiftUIImagePicker:UIViewControllerRepresentable{
    
    
    enum MediaType{
        case image
        case video
        case all
    }
    
    @Binding var isPresented:Bool
    @Binding var selectedImage:UIImage?
    @Binding var selectedImageURL:String?
    @Binding var selectedVideoURL:String?
    
    var sourceType: UIImagePickerController.SourceType
    var mediaType:MediaType = MediaType.all
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator:NSObject,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
        var parent:SwiftUIImagePicker
        init(parent:SwiftUIImagePicker) {
            self.parent = parent
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let selectedImage = info[.originalImage] as? UIImage , let url = info[.imageURL] as? NSURL{
                self.parent.selectedImage = selectedImage
                self.parent.selectedImageURL = url.absoluteString
//                print("imageURL = \(url)")

            }
            else if let videoUrl = info[.mediaURL] as? NSURL {
                self.parent.selectedVideoURL = videoUrl.absoluteString
            }
            self.parent.isPresented = false
        }
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = UIImagePickerController()
//        kUTTypeMovie
        switch mediaType {
        case .all:
            controller.mediaTypes = ["public.movie" ,"public.image"]
            break
        case .image:
            controller.mediaTypes = ["public.image"]
            break
        case .video:
            controller.mediaTypes = ["public.movie"]
        }
        controller.allowsEditing = true
        controller.sourceType = sourceType
        controller.delegate = context.coordinator
        return controller
    }
}
