//
//  VideoMarkView.swift
//  Wannado
//
//  Created by admin on 2023/8/14.
//

import SwiftUI
import PhotosUI

struct VideoMarkView: View {
    
    @State var showPicker:Bool = false
    @State var photoItems:[PhotosPickerItem] = []
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationStack {
            
            Color.clear.edgesIgnoringSafeArea(.all)
                .navigationBarBackButtonHidden(true)
                .navigationTitle("视频去水印")
                .navigationBarTitleDisplayMode(.inline)
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
                                      matching: .videos,
                                      preferredItemEncoding: .automatic)
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

extension VideoMarkView {
    
    
}



struct VideoMarkView_Previews: PreviewProvider {
    static var previews: some View {
        VideoMarkView()
    }
}
