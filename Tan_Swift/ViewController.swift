//
//  ViewController.swift
//  Tan_Swift
//
//  Created by M C on 2017/4/21.
//  Copyright © 2017年 M C. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //1、一次定义多个变量
        let num = 10, num2 = 11, num3 = 288;
        let name1 = "大锤", name2 = "张三", name3 = "牛德胜"
        let maximumNumberOfLoginAttempts = 10
        
        var contentStr : String = "what are you speak ? I understand ! no no no no no !\nI'm very very \n"
        print("num:%d, num1: %d, num2: %d, name1: %@, name2: %@, name3: %@, max: %d, contentStr: %@", num, num2, num3, name1, name2, name3, maximumNumberOfLoginAttempts, contentStr)
        contentStr = "🙂\n微笑\n表情🙂😢😊😄😅🏀真正的表情，你懂的！\n"
        print("修改字符串：%@", contentStr)
        
        //2、定义特别字符串为变量名
        let π = 3.14159
        let 你好 = "中文变量名你好世界"
        let 🐶🐮 = "emoji表情变量名dogcow"
        print("π：", π, ", 你好: ", 你好, ", 🐶🐮: ", 🐶🐮)
        
        //3、直接输入常量和变量
        print(contentStr)
        print("string is show：\(contentStr)") //把变量名当做占位符删除
        
//        name1 = "你很厉害！^_^"  //常量不能修改
//        let num4 : UInt8 = -1; //UInt8的取值范围为0-255， 不能赋值负数
        let num5 = 3;
        let num6 = 0.33;
        let num7 = Double(num5) + num6; //需要转化
        let num8 = num5 + Int(num7);
        
        
        //4、类型别名
        typealias MingString = String;
        var mStr : MingString = "类型别名, Hello, World!";
        print("....start: ", mStr, " ....")
        mStr = String(33); //必须转换，已经确定好的类型不能赋值其他类型的值，如需需要进行类型转换
        print(mStr)
        
        //5、元祖 tuble
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

