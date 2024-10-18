# LJJsonPrint

[![CI Status](https://img.shields.io/travis/Josh/LJJsonPrint.svg?style=flat)](https://travis-ci.org/Josh/LJJsonPrint)
[![Version](https://img.shields.io/cocoapods/v/LJJsonPrint.svg?style=flat)](https://cocoapods.org/pods/LJJsonPrint)
[![License](https://img.shields.io/cocoapods/l/LJJsonPrint.svg?style=flat)](https://cocoapods.org/pods/LJJsonPrint)
[![Platform](https://img.shields.io/cocoapods/p/LJJsonPrint.svg?style=flat)](https://cocoapods.org/pods/LJJsonPrint)



日常开发中,控制台打印的字典日志并不友好,不容易看出层级结构,这里实现了可以将字典或者数组的结构在视图上展示出来的功能,方便日常开发调试

## 特性

- 可以展示数组、字典
- 可以设置默认展示的层级数
- 支持展开和收起
- 内容展示不全时，支持横向、纵向滚动
- 可以长按触发菜单弹窗(支持复制)

## 安装

### CocoaPods

1. 在Podfile中添加  `pod 'LJJsonPrint` 。
2. 执行 `pod install` 或 `pod update`。
3. 导入 LJJsonPrint。

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
