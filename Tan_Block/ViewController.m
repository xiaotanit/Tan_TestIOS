//
//  ViewController.m
//  Tan_Block
//
//  Created by PX_Mac on 2017/4/25.
//  Copyright © 2017年 M C. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*
     快捷弹出block ---> inlineBlock
     返回类型  (^block名字)(参数) = ^(参数){ } //实现
     <#returnType#>(^<#blockName#>)(<#parameterTypes#>) = ^(<#parameters#>) {
     <#statements#>
     };
     */
    
    //block的应用场景：1、作为属性 进行存储； 2、作为参数 进行传递；3、作为返回值进行调用
    Person *per = [Person new];
    
    //1、block作为属性进行调用: 先赋值，再调用
    per.runBlock = ^(NSString *name) {
        NSLog(@"block作为属性调用。。.: %@", name);
    };
    per.runBlock(@"王大锤。。。");
    
    
    //2、block作为参数进行传递: 直接调用
    [per transBlock:^{
        NSLog(@"...传递block作为参数调用。。。111_222");
    }];
    
    [per transBlockHasPara:^(NSString *name) {
        NSLog(@"222传递带参数的block调用。。。name: %@", name);
    }];
    
    
    //3、block作为返回值 : 可以把类的方法用点语法点出来
    per.returnBlock();
    per.getBlock(@"李大霄");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
