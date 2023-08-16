//
//  VideoMarkView.swift
//  Wannado
//
//  Created by admin on 2023/8/14.
//

import SwiftUI
import PhotosUI
import AVKit


struct VideoMarkView: View {
    
    @State var showPicker:Bool = false
    @State var photoItems:[PhotosPickerItem] = []
    
    @State var video:Movie?
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationStack {
            
            ZStack{
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
                            .onChange(of: photoItems) { newMedia in
                                
                                guard let video = newMedia.last else {
                                    return
                                }
                                video.loadTransferable(type: Movie.self){ result in
                                    
                                    switch result {
                                    case .success(let video):
                                        if let video = video {
                                            print("movie == \(video.url)")
                                            self.video = video
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
                VStack {
                    if let video = video {
                        VideoPlayer(player: AVPlayer(url: video.url))
                            .scaledToFit()
                        Spacer()
                    }
                }
            }
        }
    }
}

extension VideoMarkView {
    
    
}

struct Movie: Transferable {
    let url: URL
    
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie) { movie in
            SentTransferredFile(movie.url)
        } importing: { received in
            let copy = URL.documentsDirectory.appending(path: "movie.mp4")
            
            if FileManager.default.fileExists(atPath: copy.path()) {
                try FileManager.default.removeItem(at: copy)
            }
            
            try FileManager.default.copyItem(at: received.file, to: copy)
            return self.init(url: copy)
        }


    }
}

struct VideoMarkView_Previews: PreviewProvider {
    static var previews: some View {
        VideoMarkView()
    }
}
