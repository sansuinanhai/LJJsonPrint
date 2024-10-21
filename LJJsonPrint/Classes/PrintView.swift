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
        get {
            manager.attConfig.font
        }
        set{
            manager.attConfig.font = newValue
            manager.regexConfig?.attConfig.font = newValue
        }
    }
    
    public var textColor: UIColor! {
        didSet {
            manager.attConfig.color = textColor
        }
    }
    
    public var textAlignment: NSTextAlignment? {
        didSet {
            if let alignment = textAlignment{
                textView.textAlignment = alignment
            }
        }
    }
    
    public var lineSpacing: CGFloat = 0 {
        didSet { manager.attConfig.lineSpacing = lineSpacing }
    }
    
    private let  manager:ParserManager = ParserManager()
    private var textView:PrintTextView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        manager.regexConfig = ParserRegexConfig(pattern: "(➖)|(➕)", attConfig: ParserAttConfig(font: font, color: manager.attConfig.color, lineSpacing: 0))
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
        textView.parseDelegate = manager
        textView.customHandler = {
            [weak self] element  in
            self?.handlerCustom(range: element.range)
        }
    }
    
    private func handlerCustom(range:NSRange){
        
        if let node = manager.getNode(range: range) {
            node.isOpen = !node.isOpen
            let attStr = manager.reParse()
            show(attStr: attStr)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        let textFrame = CGRect(x: 0, y: 0, width: textView.frame.width, height:textView.frame.height)
        textView.frame = textFrame
    }
    
    
    
    @discardableResult
    public func show(value:Any,showLevel:Int) -> (attStr:NSAttributedString?,size:CGSize){
        
        let attStr = manager.parseAndFormAtt(value: value, showLevel: showLevel)
    
        show(attStr: attStr)
        return (textView.attributedText,contentSize)
    }
    
    private func show(attStr:NSAttributedString){
        
        textView.attributedText = attStr
        let strSize2 = textView.attributedText?.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height:CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin,.usesFontLeading], context: nil).size ?? .zero
        
//        textView.text = text
        let textW:CGFloat = strSize2.width + 10
        let textH:CGFloat = strSize2.height + 10
        let textFrame = CGRect(x: 0, y: 0, width:textW, height:textH)
        contentSize = CGSize(width: textW, height: textH)
        textView.frame = textFrame
    }
    
    
}
