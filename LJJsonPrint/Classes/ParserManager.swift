//
//  ParserManager.swift
//  LJKit_Example
//
//  Created by Liujingjie on 2024/10/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

public class ParserManager {
    //保存生成的打印node
    private var nodeDic:[String:ParserNode] = [:]
    private var locationNodeDic:[Int:ParserNode] = [:]
    //记录index
    private var indexDic:[Int:Int] = [:]
    //原始数据
    private var oriValue:Any?
    //展示的层数
    private var showLevel:Int = 3
    
    var activeElements:[MatchElement] = Array()

    var attConfig:ParserAttConfig!
    ///正则配置
    var regexConfig:ParserRegexConfig?
    
    init(){
        attConfig = ParserAttConfig(font: UIFont.systemFont(ofSize: 14), color: .black, lineSpacing: 0)
    }
    
    //MARK: 解析并创建富文本
    public func parseAndFormAtt(value:Any,showLevel:Int) -> NSAttributedString{
        
        let str = parser(value: value, showLevel: showLevel)
        let par = NSMutableParagraphStyle()
        par.lineSpacing = attConfig.lineSpacing
        
        let attStr = NSMutableAttributedString(string: str,attributes: [NSAttributedString.Key.font:attConfig.font,NSAttributedString.Key.foregroundColor:attConfig.color,NSAttributedString.Key.paragraphStyle:par])
        
        if let config = regexConfig {
            activeElements.removeAll()
            createActiveElements(str: str, pattern: config.pattern)
            for item in activeElements {
                attStr.setAttributes([NSAttributedString.Key.font:config.attConfig.font,NSAttributedString.Key.foregroundColor:config.attConfig.color], range: item.range)
            }
        }
        
        
        return attStr
    }
    
    private func createActiveElements(str:String,pattern:String) {
        
        let textLength = str.utf16.count
        let textRange = NSRange(location: 0, length: textLength)
        
        let hashtagElements = createElements(from: str,for:pattern,range: textRange)
        activeElements.append(contentsOf: hashtagElements)
    }
    
    private func createElements(from text: String,
                                            for pattern: String,
                                                range: NSRange,
                                                minLength: Int = 1) -> [MatchElement] {

        guard let createdRegex = try? NSRegularExpression(pattern:pattern, options: [.caseInsensitive]) else { return [] }
        
        
        let matches = createdRegex.matches(in: text, options: [], range: range)
        let nsstring = text as NSString
        var elements: [MatchElement] = []
        
        for match in matches where match.range.length >= minLength {
            let word = nsstring.substring(with: match.range)
                .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let element = MatchElement(text: word, range: match.range)
            elements.append(element)
        }
        return elements
    }
    
    
    //将json数据格式化
   public func parser(value:Any,showLevel:Int) -> String{
        oriValue = value
        self.showLevel = showLevel
        
        var printStr:String = ""
        var traverseArr:[ParserNode] = Array()
        oriValue = value

        if let dic = value as? [AnyHashable:Any] {//字典
            traverseArr.append(getNode(maxIndex: dic.keys.count - 1, spaceCount: 2, level: 0, levelIndex: 0, isOpen: showLevel > 0, data: dic))
        }else if let dataArr = value as? [Any] {//数组
            traverseArr.append(getNode(maxIndex: dataArr.count - 1, spaceCount: 2, level: 0, levelIndex: 0, isOpen: showLevel > 0, data: dataArr))
        }
        
        let levelCount:Int = 4
        
        while traverseArr.count > 0 {
            let tempNode = traverseArr.last!
            ///节点等级
            let nodeLevel = traverseArr.count - 1
            let prefixSignStr:String = tempNode.prefixSignStr
            let suffixSignStr:String = tempNode.suffixSignStr
            
            if tempNode.curIndex == 0 {
                
                if tempNode.isOpen {
                    //是展开状态
                    printStr +=  "➖\(prefixSignStr)\n"
                    tempNode.location = printStr.utf16.count - 2 //设置location
                    locationNodeDic[tempNode.location] = tempNode
                }else{
                    //关闭状态
                    printStr +=  "➕\(prefixSignStr)"
                    tempNode.location = printStr.utf16.count - 1 //设置location
                    locationNodeDic[tempNode.location] = tempNode

                    if let _ = tempNode.sourceData as? [AnyHashable:Any] {
                        printStr +=  " object \(suffixSignStr)"
                    }else if let tempSource = tempNode.sourceData as? [Any] {
                        printStr +=  " \(tempSource.count) \(suffixSignStr)"
                    }
                    
                    if nodeLevel > 0 {
                        traverseArr[nodeLevel - 1].curIndex += 1
                        if traverseArr[nodeLevel - 1].isLast == false {
                            printStr += ",\n"
                        }
                    }
                    traverseArr.removeLast()
                    continue
                    
                }
                
            }
            
//            let spaceStr = getSpaceStr(count: tempNode.spaceCount)
//            printStr += spaceStr
            var isAddSeparate:Bool = false
            
            if let tempSource = tempNode.sourceData as? [AnyHashable:Any],tempSource.keys.count > tempNode.curIndex {//节点是字典
                let spaceStr = getSpaceStr(count: tempNode.spaceCount)
                printStr += spaceStr

                
                var keysArr = Array(tempSource.keys)
                keysArr = keysArr.sorted(by: {$0.hashValue < $1.hashValue})
                let key = keysArr[tempNode.curIndex]
                let tempValue = tempSource[key]
                var keySign:String = "\(key)"
                if key is String {
                    keySign = "\"\(key)\""
                }
                
                let keyCon = keySign + ": "
                printStr += keyCon
                
                if let tempDic = tempValue as? [AnyHashable:Any] {//字典
                    let node = createNode(spaceCount: tempNode.spaceCount + keyCon.count + levelCount, level: traverseArr.count, dic: tempDic)
                    traverseArr.append(node)
                    
                }else if let tempArr = tempValue as? [Any] {//数组
                    let node = createNode(spaceCount: tempNode.spaceCount + keyCon.count + levelCount, level: traverseArr.count, arr: tempArr)
                    traverseArr.append(node)
                }else{
                    if tempValue is String {
                        printStr  +=  "\"\(tempSource[key] ?? "")\""
                    }else{
                        printStr  +=  "\(tempSource[key] ?? "")"
                    }
                    
                    tempNode.curIndex += 1
                    isAddSeparate = true

                }
                
            }else if let tempSource = tempNode.sourceData as? [Any],tempSource.count > tempNode.curIndex {//节点是数组
                let spaceStr = getSpaceStr(count: tempNode.spaceCount)
                printStr += spaceStr

                let tempValue = tempSource[tempNode.curIndex]
                if let tempDic = tempValue as? [AnyHashable:Any] {//字典
                    let node = createNode(spaceCount: tempNode.spaceCount + levelCount, level: traverseArr.count, dic: tempDic)
                    traverseArr.append(node)
                }else if let tempArr = tempValue as? [Any] {//数组
                    let node = createNode(spaceCount: tempNode.spaceCount + levelCount, level: traverseArr.count, arr: tempArr)
                    traverseArr.append(node)
                }else{
                    if tempValue is String {
                        printStr  +=  "\"\(tempValue)\""
                    }else{
                        printStr  +=  "\(tempValue)"
                    }
                    tempNode.curIndex += 1
                    isAddSeparate = true
                }
            }
            
            if tempNode.curIndex > tempNode.maxIndex {//表示是最后一个
            
                
                if tempNode.maxIndex < 0 {
                    let spaceStr = getSpaceStr(count: tempNode.spaceCount)
                    printStr += spaceStr + "null"
                }
                
                if nodeLevel > 0 {
                    traverseArr[nodeLevel - 1].curIndex += 1
                    printStr += "\n\(getSpaceStr(count: tempNode.spaceCount - levelCount) + suffixSignStr)"
                    if traverseArr[nodeLevel - 1].isLast == false {
                        printStr += ",\n"
                    }

                }else{
                    printStr += "\n\(suffixSignStr)"
                }
                
                traverseArr.removeLast()
            }else{
                if isAddSeparate {
                    printStr += ",\n"
                }
            }
        }
        
        return printStr
    }
    
    //MARK: 生成node
    func createNode(spaceCount:Int,level:Int,dic:[AnyHashable:Any])->ParserNode{
        let nodeIndex = getNodeIndex(level: level) + 1
        indexDic[level] = nodeIndex
        let node = getNode(maxIndex: dic.keys.count - 1, spaceCount:spaceCount, level:level, levelIndex: nodeIndex, isOpen: showLevel > level, data: dic)
        return node
    }
    
    func createNode(spaceCount:Int,level:Int,arr:[Any])->ParserNode{
        let nodeIndex = getNodeIndex(level: level) + 1
        indexDic[level] = nodeIndex
        let node = getNode(maxIndex: arr.count - 1, spaceCount: spaceCount, level: level, levelIndex: nodeIndex, isOpen: showLevel > level, data: arr)
        return node
    }
    
    //MARK: 再次解析
    func reParse() -> NSAttributedString{
        guard let value = oriValue else { return NSAttributedString() }
        locationNodeDic.removeAll()
        indexDic.removeAll()
        nodeDic.values.forEach({$0.resetIndex()})
       return  parseAndFormAtt(value: value, showLevel: showLevel)
    }
    
    //MARK: 获取节点
    func getNode(range:NSRange) -> ParserNode? {
        return getNode(index: range.location + range.length)
    }
    
    func getNode(index:Int) -> ParserNode?{
        return locationNodeDic[index]
    }
    
    
    
    
    //获取节点
    private func getNode(maxIndex:Int,spaceCount:Int,level:Int,levelIndex:Int,isOpen:Bool,data:Any?) -> ParserNode {
        let key:String  = "\(level)_\(levelIndex)"
        var node:ParserNode? = nodeDic[key]
        if node == nil {
            node = ParserNode(maxIndex:maxIndex,spaceCount:spaceCount,level: level,levelIndex: levelIndex,sourceData: data)
            node?.isOpen = isOpen
            nodeDic[key] = node
        }
        return node!
    }
    
    
    
    //MARK: 获取当前层的索引
    private func getNodeIndex(level:Int) -> Int {
        var index:Int = -1
        if let tempIndex = indexDic[level] {
            index = tempIndex
        }
        return index
    }
    
    
    
    //MARK: 获取空格字符串
    private func getSpaceStr(count:Int) ->String {
        var spaceStr:String = ""
        for _ in 0..<count {
            spaceStr += "  "
//            spaceStr += "*"

        }
        return spaceStr
    }
    
    
    
    
    

}

extension ParserManager:ParseTextDelegate
{
    func match(textIndex: Int) -> MatchElement? {
        
        for element in activeElements {
            if textIndex >= element.range.location && textIndex <= element.range.location + element.range.length {
                return element
            }
        }

        return nil
        
    }
    
    
    
}
