//
//  ParserRegexConfig.swift
//  LJJsonPrint
//
//  Created by Liujingjie on 2024/10/21.
//

import UIKit

public class ParserRegexConfig {
    public var pattern:String
    public var attConfig:ParserAttConfig
    
    public init(pattern: String, attConfig: ParserAttConfig) {
        self.pattern = pattern
        self.attConfig = attConfig
    }

}
