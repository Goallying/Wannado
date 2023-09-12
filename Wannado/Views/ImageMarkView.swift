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
    @State var photoItem:PhotosPickerItem?
    @State var selectImage:UIImage?   //= UIImage(named: "test")
    @State var outputImage:UIImage?
    @State var paths:[UIPath] = []
    @State var cavasSize:CGSize = .zero
    
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
                                .scaledToFit()
                                .overlay {
                                    
                                    Canvas { context , size in
                                        DispatchQueue.main.async {
                                            cavasSize = size
                                        }
                                        let rect = CGRect(origin: .zero, size: size)
                                        var path = Rectangle().path(in: rect)
                                        
                                        paths.forEach { apath in
                                            switch apath.type {
                                                
                                            case .move:
                                                path.move(to: apath.point)
                                                break
                                            case .line:
                                                path.addLine(to: apath.point)
                                                break
                                            case .end:
                                                path.closeSubpath()
                                                break
                                            }
                                        }
                                        
                                        context.stroke(path, with: .color(.black), lineWidth: 5)
                                    }
                                    
                                    .gesture(DragGesture(minimumDistance: 5)
                                        .onChanged({ changeValue  in
                                            if paths.isEmpty {
                                                paths.append(UIPath(type: .move, point: changeValue.location))
                                            }
                                            else{
                                                paths.append(UIPath(type: .line, point: changeValue.location))
                                            }
                                            
                                        })
                                        .onEnded({ endValue in
                                            paths.append(UIPath(type: .end, point: endValue.location))
                                        }))
                                    
                                }
                            
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
                .photosPicker(isPresented: $showPicker, selection: $photoItem, matching: .images, preferredItemEncoding: .automatic)
                .onChange(of: photoItem) { newItem in

                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self){
                            selectImage = UIImage(data: data)
                        }
                    }
                }
            })
            
            ToolbarItem (placement: .navigationBarTrailing){
                Button{
                    
                    var ratio:CGFloat = 1
                    let scale = UIScreen.main.scale
                    let imagew = selectImage!.size.width
                    let imageh = selectImage!.size.height
                    let wResized = selectImage!.size.width > (cavasSize.width * scale)
                    let hResized = selectImage!.size.height  > (cavasSize.height * scale)
                    
                    //图片被缩小
                    if wResized && hResized
                    {
                        ratio =  max(imagew / (cavasSize.width * scale), imageh / (cavasSize.height * scale))
                    }
                    else if wResized {
                        ratio = imagew / (cavasSize.width * scale)
                    }
                    else if hResized {
                        ratio = imageh / (cavasSize.height * scale)
                    }
                    //图片被放大
                    else if !wResized && !hResized {
                        ratio = min((imagew / cavasSize.width * scale), imageh / (cavasSize.height * scale))
                    }
                    else if !wResized {
                        ratio = imagew / (cavasSize.width * scale)
                    }
                    else if !hResized {
                        ratio = imageh / (cavasSize.height * scale)
                    }
                    
                    let pathRect = path2Rect() ;
                    let newRect = CGRect(x: pathRect.origin.x * ratio * scale, y: pathRect.origin.y * ratio * scale, width: pathRect.size.width * ratio * scale, height: pathRect.size.height * ratio * scale)
                    outputImage = selectImage!.inpaint(newRect)
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
    
    func path2Rect() -> CGRect {
        
        let first = paths.first
        
        var top :CGFloat = first?.point.y ?? 0
        var left:CGFloat = first?.point.x ?? 0
        var bottom:CGFloat = first?.point.y ?? 0
        var right:CGFloat = first?.point.x ?? 0
        
        
        paths.forEach { path in
            let px = path.point.x
            let py = path.point.y
            
            print("p = \(path.point)\n")
            if py < top {
                top = py
            }
            if px < left {
                left = px
            }
            if py > bottom {
                bottom = py
            }
            if px > right {
                right = px
            }
        }
        let rect = CGRect(x: left, y: top, width: right - left, height: bottom - top)
        print("pathRect = \(rect)")
        return rect
        
    }
}
struct ImageMarkView_Previews: PreviewProvider {
    static var previews: some View {
        ImageMarkView()
    }
}
