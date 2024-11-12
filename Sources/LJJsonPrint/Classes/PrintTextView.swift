//
//  PrintTextView.swift
//  LJKit_Example
//
//  Created by Liujingjie on 2024/10/16.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

protocol ParseTextDelegate:AnyObject {
    ///开始匹配
    func match(textIndex:Int) -> MatchElement?

}


class PrintTextView: UITextView {
    weak var parseDelegate:ParseTextDelegate?
    private var selectedElement: MatchElement?
    var customHandler:((_ element:MatchElement)->())?

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    init() {
        super.init(frame: .zero, textContainer: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Handle UI Responder touches
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if onTouch(touch) { return }
        super.touchesBegan(touches, with: event)
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if onTouch(touch) { return }
        super.touchesMoved(touches, with: event)
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        _ = onTouch(touch)
        super.touchesCancelled(touches, with: event)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if onTouch(touch) { return }
        super.touchesEnded(touches, with: event)
    }
    
    // MARK: - touch events
    func onTouch(_ touch: UITouch) -> Bool {
        let location = touch.location(in: self)
        var avoidSuperCall = false
        
        switch touch.phase {
        case .began, .moved:
            
            if let element = element(at: location) {
                if element.range.location != selectedElement?.range.location || element.range.length != selectedElement?.range.length {
                    selectedElement = element
                }
                avoidSuperCall = true
            } else {
                selectedElement = nil
            }
        case .ended:

            guard let selectedElement = selectedElement else { return avoidSuperCall }
            
            customHandler?(selectedElement)
                        
            let when = DispatchTime.now() + Double(Int64(0.25 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.selectedElement = nil
            }
            avoidSuperCall = true
        case .cancelled:
            selectedElement = nil
        case .stationary:
            break
        default:
            break

        }
        
        return avoidSuperCall
    }
    
  
    
    fileprivate func element(at location: CGPoint) -> MatchElement? {
        guard textStorage.length > 0 ,let delegate = parseDelegate else {
            return nil
        }
        
        let correctLocation = location
//        correctLocation.y -= heightCorrection
        let boundingRect = layoutManager.boundingRect(forGlyphRange: NSRange(location: 0, length: textStorage.length), in: textContainer)
        guard boundingRect.contains(correctLocation) else {
            return nil
        }
        
        let index = layoutManager.glyphIndex(for: correctLocation, in: textContainer)
        
        return delegate.match(textIndex: index)
    }


    
    
    
    
    
}
