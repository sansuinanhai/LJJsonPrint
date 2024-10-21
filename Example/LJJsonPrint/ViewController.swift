//
//  ViewController.swift
//  LJJsonPrint
//
//  Created by Josh on 10/17/2024.
//  Copyright (c) 2024 Josh. All rights reserved.
//

import UIKit
import LJJsonPrint

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUpView()
    }
    
    func setUpView(){
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
                   "爱好":["看书":["童话":"白雪公主的故事","武侠":"蜀山传"],
                         "运动":"自行车"],
                   "年龄":18,
                   "性别":"男",
                   "学校":["小学",["其他":["高中","大学"]]],
                   "目标":[],
                   Time.light:1,
                   "天气":Time.dark
        ]
        
        
        printView.show(value: dic, showLevel: 2)

    }
    
    



}

