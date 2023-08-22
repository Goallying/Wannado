//
//  ImageMarkView.swift
//  Wannado
//
//  Created by admin on 2023/8/15.
//

import SwiftUI
import PhotosUI


struct ImageMarkView: View {
    
    @State var showPicker:Bool = false
    @State var photoItems:[PhotosPickerItem] = []
    
    @State var selectImage:Image?
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationStack {
            
            VStack{
                
                if selectImage == nil {
                    Text("请导入图片")
                }else {
                    selectImage?
                        .resizable()
                        .scaledToFill()
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
                    .photosPicker(isPresented: $showPicker,
                                  selection: $photoItems,
                                  maxSelectionCount: 1,
                                  matching: .images,
                                  preferredItemEncoding: .automatic)
                    .onChange(of: photoItems) { newMedia in
                        
                        guard let video = newMedia.last else {
                            return
                        }
                        video.loadTransferable(type: Image.self){ result in
                            
                            switch result {
                            case .success(let image):
                                if let image = image {
                                    print("image == \(image)")
                                    self.selectImage = image
                                }
                                
                            case.failure(let failure):
                                print("failure == \(failure)")
                            }
                        }
                        
                    }
                })
                
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
}

struct ImageMarkView_Previews: PreviewProvider {
    static var previews: some View {
        ImageMarkView()
    }
}
