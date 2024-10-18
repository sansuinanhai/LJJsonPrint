//
//  ParserType.swift
//  LJKit_Example
//
//  Created by Liujingjie on 2024/10/16.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit


import Foundation

enum ParserElement {
    case custom(String)

    static func create(with parserType: ParserType, text: String) -> ParserElement {
        switch parserType {
            case .custom: return custom(text)
        }
    }
}

public enum ParserType {
    case custom(pattern: String)
    
    var pattern: String {
        switch self {
        case .custom(let regex): return regex
        }
    }
}

extension ParserType: Hashable, Equatable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .custom(let regex): hasher.combine(regex)
        }
    }
}

public func ==(lhs: ParserType, rhs: ParserType) -> Bool {
    switch (lhs, rhs) {
    case (.custom(let pattern1), .custom(let pattern2)): return pattern1 == pattern2
    }
}
