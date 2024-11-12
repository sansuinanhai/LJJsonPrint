# LJJsonPrint

[![Version](https://img.shields.io/cocoapods/v/LJJsonPrint.svg?style=flat)](https://cocoapods.org/pods/LJJsonPrint)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)
[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/LJJsonPrint/main/LICENSE)&nbsp;
[![Platform](https://img.shields.io/cocoapods/p/LJJsonPrint.svg?style=flat)](https://cocoapods.org/pods/LJJsonPrint)
[![Support](https://img.shields.io/badge/support-iOS%2010%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;



日常开发中,控制台打印的字典日志并不友好,不容易看出层级结构,当前库可以将json数据展示出来,类似于[json.cn](http://www.json.cn),方便日常开发调试

- [特性](#特性)
- [安装](#安装)
- [用法](#用法)
- [示例](#示例)
- [系统要求](#系统要求)
- [许可证](#许可证)

## 特性

- [x] 可以展示数组、字典
- [x] 可以设置默认展示的层级数
- [x] 支持展开和收起
- [x] 内容不够展示时，支持横向、纵向滚动
- [x] 可以长按触发菜单弹窗(支持复制)

## 安装

### Swift Package Manager

[Swift Package Manager](https://swift.org/package-manager/) 是一个用于自动分发Swift代码的工具，并集成到`xcode`中 。

在项目中使用非常简单,File -> Add Packages,用地址`https://github.com/sansuinanhai/LJJsonPrint.git`"进行搜索，找到LJJsonPrint,点击下一步安装即可


如果已经创建了`Package.swift`,将LJJsonPrint作为依赖项添加到`Package.swift`的`dependencies`中。

```swift
dependencies: [
    .package(url: "https://github.com/sansuinanhai/LJJsonPrint.git", .upToNextMajor(from: "0.5.0"))
]
```

并设置依赖名称:

```swift
.target(
    dependencies:[
        .product(name: "LJJsonPrint", package: "LJJsonPrint")
    ]
)
```


### CocoaPods

[CocoaPods](https://cocoapods.org) 是Cocoa项目的依赖管理器。有关使用和安装说明，请访问他们的网站。要使用CocoaPods将LJJsonPrint集成到Xcode项目中，请在`Podfile`中指定它：

```ruby
pod 'LJJsonPrint'
```


## 用法

```swift
				
        let printView = PrintView(frame: CGRect(x: 0, y: 150, width: 300, height: 300))
        printView.backgroundColor = .red
        printView.textColor = .white
        printView.lineSpacing = 3
        printView.font = UIFont.systemFont(ofSize: 14)
//        printView.hightlightFont = UIFont.systemBlack(20)
        view.addSubview(printView)
        
        enum Time {
            case light
            case dark
        }
        
        
        let dic:[AnyHashable:Any] = [
                   "姓名":"三岁男孩",
                   "爱好":["看书":["童话":"白雪公主","武侠":"蜀山传"],
                         "运动":"自行车"],
                   "年龄":18,
                   "性别":"男",
                   "学校":["小学",["其他":["高中","大学"]]],
                   "目标":[],
                   Time.light:1,
                   "天气":Time.dark
        ]
        
        
        printView.show(value: dic, showLevel: 2)
```

## 示例

<img src="https://raw.github.com/sansuinanhai/LJJsonPrint/main/Example/gif/demo.gif" width="320">




## 系统要求

该项目最低支持 `ios 10.0`

## 许可证
LJJsonPrint 使用 MIT 许可证，详情见 LICENSE 文件。
