//
//  LogPrintNode.swift
//  LJKit_Example
//
//  Created by Liujingjie on 2024/10/16.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

/**
 解析的节点
 */

class ParserNode
{
    var curIndex:Int = 0
    var maxIndex:Int = 0
    var sourceData:Any?
    ///当前所在层
    var level:Int = 0
    ///当前所在层的所以(比如在第二层的 第五个，此处的值是4)
    var levelIndex:Int = 0
    ///是否展开
    var isOpen:Bool = true
    ///起点所在的位置
    var location:Int = 0
    ///内容长度
    var length:Int = 0
    
    var prefixSignStr:String = "{"
    var suffixSignStr:String = "}"
    var spaceCount:Int
    
    init( maxIndex: Int,spaceCount:Int,level:Int,levelIndex:Int, sourceData: Any? = nil) {
        self.maxIndex = maxIndex
        self.sourceData = sourceData
        self.spaceCount = spaceCount
        self.level = level
        self.levelIndex = levelIndex
        
        if sourceData is [Any] {
            prefixSignStr = "["
            suffixSignStr = "]"
        }
    }
    
    
    func resetIndex(){
        curIndex = 0
    }
    
    var isLast:Bool {
        return curIndex > maxIndex
    }
}
