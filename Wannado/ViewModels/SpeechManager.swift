//
//  SpeechManager.swift
//  Wannado
//
//  Created by admin on 2023/9/13.
//

import Foundation
import Speech

class SpeechManager {
    
    
    public var isRecording = false
    private var audioEngine:AVAudioEngine!
    private var inputNode:AVAudioNode!
    private var recognizationRequest:SFSpeechAudioBufferRecognitionRequest?
    private var recognizationTask:SFSpeechRecognitionTask?
    
    func checkPermisson(){
        
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                
                switch authStatus {
                    
                case .authorized:
                    break
                default:
                    print("SpeechRecognizer is not available")
                }
            }
        }
    }
    
    func startTranscript(completion:@escaping(String?) ->Void) {
        
        if isRecording {
            stopTranscript()
        }
        else {
            isRecording = true
            start(completion: completion)
        }
        
    }
    private func start(completion:@escaping(String?)->Void){
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record)
            try audioSession.setActive(true ,options: .notifyOthersOnDeactivation)
        }catch {
            print("record Start error - \(error)")
            return
        }
        
        let locale = Locale(identifier: "zh_CN")
        guard let recognizer = SFSpeechRecognizer(locale: locale) ,recognizer.isAvailable else {
            print("SpeechRecognizer startRecording is not available")
            return
        }
        
        recognizationRequest = SFSpeechAudioBufferRecognitionRequest()
        //离线/在线
//        recognizationRequest?.requiresOnDeviceRecognition = false
        //标点符号
        recognizationRequest?.addsPunctuation = true
//        recognizationRequest!.shouldReportPartialResults = true
        recognizationTask = recognizer.recognitionTask(with: recognizationRequest!) { result, error in
            guard error == nil else{
                print("recognitionTask error = \(String(describing: error?.localizedDescription))")
                return
            }
            guard let result = result else { return }
            completion(result.bestTranscription.formattedString)
        }
        
        audioEngine = AVAudioEngine()
        inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        var settings = recordingFormat.settings
        settings[AVLinearPCMBitDepthKey] = 16
        settings[AVSampleRateKey] = 16000
        settings[AVNumberOfChannelsKey] = 1
        settings[AVFormatIDKey] = kAudioFormatAppleLossless
        settings[AVLinearPCMIsFloatKey] = 0
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, time in
            self.recognizationRequest?.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()         
        }catch{
            print("error = \(error.localizedDescription)")
        }
    }
    func stopTranscript(){
        
        if audioEngine.isRunning {
            
            inputNode.removeTap(onBus: 0)
            inputNode.reset()
            audioEngine.stop()
            recognizationRequest?.endAudio()
//            recognizationTask?.cancel()
            recognizationTask?.finish()

            isRecording = false
            recognizationTask = nil
            recognizationRequest = nil
            audioEngine = nil
            inputNode = nil
            
        }
    }
    
}
