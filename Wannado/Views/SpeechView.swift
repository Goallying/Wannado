//
//  SpeechView.swift
//  Wannado
//
//  Created by admin on 2023/9/13.
//

import SwiftUI
import Speech

struct SpeechView: View {
    
    @State var isRecording:Bool = false
    @State var transferText:String = ""
    
    private var speechManager = SpeechManager()
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        
        VStack {
            
            ScrollView {
                Text(transferText)
            }
            .padding()
            
            Button {
                
                isRecording.toggle()
                transfering()
                
            } label: {
                
                Circle()
                    .stroke(.gray, lineWidth: 4)
                    .frame(width: 64, height: 64)
                    .overlay {
                        RoundedRectangle(cornerRadius: isRecording ? 5 : 27)
                            .fill(.red)
                            .frame(width: isRecording ? 28 : 54 ,height: isRecording ? 28 : 54)
                            .animation(.spring(
                                response: 0.5,
                                dampingFraction: 0.7,
                                blendDuration: 1.0) ,value: isRecording)
                    }
                
                
            }
            
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("语音转写")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading, content: {
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
                
            })
        }
        .onAppear{
            speechManager.checkPermisson()
        }
       
    }
    
    func transfering(){
        
        if speechManager.isRecording {
            speechManager.stopTranscript()
        }
        else {
            speechManager.startTranscript { speechText in
                guard let text = speechText , !text.isEmpty else {
                    return
                }
                transferText = text
            }
        }
        speechManager.isRecording.toggle()
    }
}

struct SpeechView_Previews: PreviewProvider {
    static var previews: some View {
        SpeechView()
    }
}
