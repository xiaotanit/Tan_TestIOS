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
        
        self.testMulVariable() //1、一次定义多个变量
        self.testMulVariable(); //2、定义特别字符串为变量名
        self.testVariableLocation(); //3、直接输入常量和变量
        self.testTypeChangeWithTypedef();   //4、类型转化和类型别名
        self.testTuble();       //5、元祖
        self.testOptionalValue();   //6、可选类型
        self.testAssertion()        //7、断言测试
        self.testString()           //8、测试字符串
        print("..^_^...end...^_^..")
    }
    
    // 测试一次定义多个变量
    func testMulVariable() {
        let num = 10, num2 = 11, num3 = 288;
        let name1 = "大锤", name2 = "张三", name3 = "牛德胜"
        let maximumNumberOfLoginAttempts = 10
        
        var contentStr : String = "what are you speak ? I understand ! no no no no no !\nI'm very very \n"
        print("num:%d, num1: %d, num2: %d, name1: %@, name2: %@, name3: %@, max: %d, contentStr: %@", num, num2, num3, name1, name2, name3, maximumNumberOfLoginAttempts, contentStr)
        contentStr = "🙂\n微笑\n表情🙂😢😊😄😅🏀真正的表情，你懂的！\n"
        print("修改字符串：%@", contentStr)
    }
    
    //定义特别字符用作变量名
    func testDefineExtraVariable() {
        let π = 3.14159
        let 你好 = "中文变量名你好世界"
        let 🐶🐮 = "emoji表情变量名dogcow"
        print("π：", π, ", 你好: ", 你好, ", 🐶🐮: ", 🐶🐮)
    }
    
    //把变量名当做占位符展示
    func testVariableLocation(){
        let contentStr = "hello, I'm String type variable !\n"
        print(contentStr)
        print("string is show：\(contentStr)") //把变量名当做占位符显示
    }
    
    //类型转换和类型别名
    func testTypeChangeWithTypedef(){
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
        mStr = String(num8); //必须转换，已经确定好的类型不能赋值其他类型的值，如需需要进行类型转换
        print(mStr)
    }
    
    //元祖
    func testTuble() {
        let http404Error = (404, "Not Found!");
        print(http404Error)
        
        let tmpTuble = (true, 1, false, 0, "what's this ?", 518.8);
        print(tmpTuble)
        
        let (statusCode, statusMessage) = http404Error
        print("this status code is : \(statusCode), this status message is: \(statusMessage)")

        let (statusCode2, _) = http404Error
        print("statusCode2: \(statusCode2), tmpTuble.2: \(tmpTuble.2), tmpTuble.4: \(tmpTuble.4)")
        
        let http202Error = (statusCode:200, statusMessage: "connect OK ^_^!");
        print("http202Error.code: \(http202Error.statusCode), msg: \(http202Error.statusMessage)");
        
        /*
         (404, "Not Found!")
         (true, 1, false, 0, "what\'s this ?", 518.79999999999995)
         this status code is : 404, this status message is: Not Found!
         statusCode2: 404, tmpTuble.2: false, tmpTuble.4: what's this ?
         http202Error.code: 200, msg: connect OK ^_^!
        */
    }
    
    //可选类型
    func testOptionalValue(){
        let name : String = "hello"
        let num : Int? = Int(name); //不加？ 编译通不过, ?表示可选类型
        print("name: \(name), num:\(String(describing: num))")
        
        let str : String = "333"
        let num2 : Int = Int(str)!
        
        if let num3 = Int(name) {
            print("success  change value ...: \(num3) , \(num2)")
        }
        else{
            print("转换赋值失败。。。:\(num2)")
        }
        
        if let num4 = Int("222") {
            print("success, num4: \(num4)")
        }
        else{
            print("fail ！")
        }
        
        let str2 : String = "ahha哈喽"
        let str3 : String = str2
        print("str:\(str2), str2:\(str3)")
    }
    
    //断言
    func testAssertion(){
        let num = 0;
        assert(num > -1 , "num is big more than 1")//如果设置成num>0, 则程序停止运行
        
        print("断言会在运行时判断一个逻辑条件是否为 true。从字面意思来说，断言“断言”一个条件是否为真。你可以使用断言来保证在运行其他代码之前，某些重要的条件已经被满足。如果条件判断为 true，代码运行会继续进行；如果条件判断为 false，代码执行结束，你的应用被终止。")
        
        //空合运算符
        let defaultColorName = "red"
        var userDefinedColorName: String?   //默认值为 nil

        let colorNameToUse = userDefinedColorName ?? defaultColorName
        
        print("defaultColorName: \(defaultColorName), userDefinedColorName: \(userDefinedColorName), colorNameToUse: \(colorNameToUse)")
        
        userDefinedColorName = "yellow"
        let colorNameToUse2 = userDefinedColorName ?? defaultColorName;
        print("userDefinedColorName: \(userDefinedColorName), colorNameToUse2: \(colorNameToUse2)")
        
        //区间
        for i in 0...5 {
            print("index: \(i)")
        }
        
        //半区间
        var arr = ["one", "two", "张三", "李四", "王五", "秋月白"]
        let length = arr.count
        for i in 0..<length {
            print("第\(i+1)个元素的值：\(arr[i])")
        }
        
        var strName = "", strName2 : String?, strName3 : String
        if strName.isEmpty {
            print("...strName isEmpty ...")
        }
        else {
            print("...strName is not empty ...")
        }
        
        if strName2 == nil {
            print("strName2 is nil  ... nil is not empty ")
        }
        else{
            print("strName2 is not empty ...")
        }
    }
    
    //测试字符串
    func testString(){
        //字符串是值类型
        var str = "hello"
        str += " world!"
        str .append(" 人无远虑必有近忧")  //追加
        print("str: \(str)")
        
        //循环读取字符串的字符
        for c in "t😊🏀⚔哈h".characters {
            print("字符：\(c)")
        }
        
        //字符数组 转成字符串
        let charactArr : [Character] = ["a", "😄", "😂", "哈", "&"]
        let charactStr : String = String(charactArr)
        print("charctStr: \(charactStr)")
        
        //字符插值
        let num = 3, num2 : Double = 2
        str = "\(num) * 2 value is :\(num * 2), \(num2) * 2.5 value is : \(num2 * 2.5), \(num) * 2.5 value is : \(Double(num) * 2)"
        print("str: \(str)")
        
        //特殊字符，Unicode
        let wiseWords = "\"Imagination is more important than knowledge\" - Einstein"
        let dollarSign = "\u{24}"             // $, Unicode 标量 U+0024
        let blackHeart = "\u{2665}"           // ♥, Unicode 标量 U+2665
        let sparklingHeart = "\u{1F496}"      // 💖, Unicode 标量 U+1F496
        let c1 = "\u{1F425}", c2 = "\u{0061}"
        print("wiseWords: \(wiseWords), dollarSign:\(dollarSign), blackHeart:\(blackHeart), sparklingHeart:\(sparklingHeart), c1:\(c1), c2:\(c2)");
    }
    
    func testCatchError() throws {
//        let str : String = "test is"
//        let str2 : String = str.substring(to, 3) //制造异常
//        print("str: \(str), str2: \(str2)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
