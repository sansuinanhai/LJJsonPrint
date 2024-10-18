//
//  PrintView.swift
//  LJKit_Example
//
//  Created by Liujingjie on 2024/10/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

public class PrintView: UIScrollView {
    public var font: UIFont {
        get  {
            return textView.font
        }
        
        set{
            textView.font = newValue
        }
    }
    
    public var textColor: UIColor! {
        didSet {
            textView.textColor = textColor
        }
    }
    
    public var textAlignment: NSTextAlignment? {
        didSet {
            if let alignment = textAlignment{
                textView.textAlignment = alignment
            }
        }
    }
    
    public var hightlightFont: UIFont? {
        didSet { textView.hightlightFont = hightlightFont }
    }

    public var minimumLineHeight: CGFloat = 0 {
        didSet { textView.minimumLineHeight = minimumLineHeight }
    }
    public var lineSpacing: CGFloat = 0 {
        didSet { textView.lineSpacing = lineSpacing }
    }
    
    private let  manager:ParserManager = ParserManager()
    private var textView:PrintTextView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView(){
        textView = PrintTextView()
        textView.isEditable = false
        textView.backgroundColor = .clear
//        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right:0)
        addSubview(textView)
        let priType:ParserType = .custom(pattern: "(➖)|(➕)")
        
        textView.enabledTypes = [priType]

        textView.handleCustomTap(for:priType) {[weak self] str,range in
            debugPrint("匹配到了内容",str)
            self?.handlerCustom(range: range)
        }

    }
    
    private func handlerCustom(range:NSRange){
        
        if let node = manager.getNode(range: range) {
            node.isOpen = !node.isOpen
            let str = manager.reParse()
            show(text: str)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        let textFrame = CGRect(x: 0, y: 0, width: textView.frame.width, height:textView.frame.height)
        textView.frame = textFrame
    }
    
    
    
    @discardableResult
    public func show(value:Any,showLevel:Int) -> (attStr:NSAttributedString?,size:CGSize){
        
        let str = manager.parser(value: value, showLevel: showLevel)
        show(text: str)
        return (textView.attributedText,contentSize)
    }
    
    private func show(text:String){
        
        textView.text = text
        let strSize2 = textView.attributedText?.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height:CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin,.usesFontLeading], context: nil).size ?? .zero
        
//        textView.text = text
        let textW:CGFloat = strSize2.width + 10
        let textH:CGFloat = strSize2.height + 10
        let textFrame = CGRect(x: 0, y: 0, width:textW, height:textH)
        contentSize = CGSize(width: textW, height: textH)
        textView.frame = textFrame
    }
    
    
}
