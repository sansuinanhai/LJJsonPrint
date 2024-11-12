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
    ///当前遍历的索引
    var curIndex:Int = 0
    ///当前最大的索引
    var maxIndex:Int = 0
    ///原来的数据
    var sourceData:Any?
    ///当前所在层
    var level:Int = 0
    ///标识(用于当做缓存的key)
    var identifier:String = ""
    ///是否展开
    var isOpen:Bool = true
    ///起点所在的位置
    var location:Int = 0
    ///内容长度
    var length:Int = 0
    
    var prefixSignStr:String = "{"
    var suffixSignStr:String = "}"
    var spaceCount:Int
    
    init( maxIndex: Int,spaceCount:Int,level:Int,identifier:String, sourceData: Any? = nil) {
        self.maxIndex = maxIndex
        self.sourceData = sourceData
        self.spaceCount = spaceCount
        self.level = level
        self.identifier = identifier
        
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
