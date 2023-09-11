//
//  Canvas.swift
//  Wannado
//
//  Created by admin on 2023/8/23.
//

import Foundation
import UIKit

class CanvasView: UIView {
    
//    var image:UIView?
    var paths:[UIPath] = []
    
    override func draw(_ rect: CGRect) {
        
        print("draw Rect = \(rect)")
        
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        paths.forEach { path in
            switch path.type {
                
            case .move:
                context.move(to: path.point)
                break
            case .line:
                context.addLine(to: path.point)
                break
            case .end:
                
//                UIColor.white.setFill()
                context.closePath()
//                context.fillPath()
//                print("drawing complete")
                break
            }
        }
        context.setLineWidth(5)
        context.setLineCap(.round)
        context.strokePath()
        
    }
    
    func reset(){
        paths.removeAll()
        self.setNeedsDisplay()
    }
    
    func path2Rect() -> CGRect {
        
        print("frame = \(self.frame) \n")
        

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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let point = touches.first?.location(in: self) else { return }
        paths.append(UIPath(type: .move, point: point))
        setNeedsDisplay()
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let point = touches.first?.location(in: self) else { return }
        paths.append(UIPath(type: .line, point: point))
        setNeedsDisplay()
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        paths.append(UIPath(type: .end, point: point))
        setNeedsDisplay()
    }
    
}


class UIPath {
    
    let type:PathType
    let point:CGPoint
    
    init(type: PathType, point: CGPoint) {
        self.type = type
        self.point = point
    }
    
    enum PathType {
        case move
        case line
        case end
    }


}
