//
//  ImageMarkView.swift
//  Wannado
//
//  Created by admin on 2023/8/15.
//

import SwiftUI
import PhotosUI
import UIKit

struct ImageMarkView: View {
    
    @State var showPicker:Bool = false
//    @State var photoItems:[PhotosPickerItem] = []
//    @State var selectImage:Image?
    @State var selectImage:UIImage?  // = UIImage(named: "sample.png")
    @State var selectedImageURL:String?
    
    @State var outputImage:UIImage?
    
    var cavasView:SwiftUICanvas = SwiftUICanvas()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationStack {
            
            VStack{
                
                if selectImage == nil {
                    
                    Text("请导入图片")
                    
                }else {
                    
                    ZStack {
                        
                        if outputImage != nil {
                            Image(uiImage: outputImage!)
                                .resizable()
                                .scaledToFit()
                        }
                        else {
                            
                            Image(uiImage: selectImage!)
                                .resizable()
                                .scaledToFill()
                            
                            cavasView
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("图片去水印")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button {
                    showPicker.toggle()
                } label: {
                    Image(systemName: "square.and.arrow.down")
                }
                .sheet(isPresented: $showPicker) {
                    
                    SwiftUIImagePicker(isPresented: $showPicker,
                                       selectedImage: $selectImage,
                                       selectedImageURL: $selectedImageURL,
                                       selectedVideoURL: Binding.constant(nil),
                                       sourceType: UIImagePickerController.SourceType.photoLibrary ,
                                       mediaType: .image)
                }
                
                         
            })
            
            ToolbarItem (placement: .navigationBarTrailing){
                Button{
                    outputImage = selectImage!.inpaint(cavasView.pathRect())
                } label: {
                    Image(systemName: "eraser")
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading, content: {
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
                
            })
        }
        
    }
}

struct SwiftUICanvas:UIViewRepresentable {
    
    var image:UIView?
    var canvasView:Canvas = Canvas()
    
    func pathRect() ->CGRect {
        canvasView.path2Rect()
    }
    func makeUIView(context: Context) -> some UIView {
        canvasView
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.backgroundColor = .clear
    }
}

struct ImageMarkView_Previews: PreviewProvider {
    static var previews: some View {
        ImageMarkView()
    }
}

// swift UI code
//                    .photosPicker(isPresented: $showPicker,
//                                  selection: $photoItems,
//                                  maxSelectionCount: 1,
//                                  matching: .images,
//                                  preferredItemEncoding: .automatic)
//                    .onChange(of: photoItems) { newMedia in
//
//                        print("media = \(newMedia)")
//                        guard let i = newMedia.last else {
//                            return
//                        }
//                        i.loadTransferable(type: Image.self){ result in
//
//                            switch result {
//                            case .success(let image):
//                                if let image = image {
//                                    print("image == \(image)")
//                                    self.selectImage = image
//                                }
//
//                            case.failure(let failure):
//                                print("failure == \(failure)")
//                            }
//                        }
//
//                    }
