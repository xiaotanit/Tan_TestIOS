//
//  TestOtherVC.m
//  Tan_TestIOS
//
//  Created by M C on 2017/8/8.
//  Copyright © 2017年 M C. All rights reserved.
//

#import "TestOtherVC.h"

@interface TestOtherVC ()

@end

@implementation TestOtherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *array=[NSArray array];
    //增加单个
    //array=[NSArray arrayWithObject:@"wujy"];
    //增加多个
    array=[NSArray arrayWithObjects:@"cnblogs",@".com",nil];
    NSInteger arrayCount=array.count;
    NSLog(@"当前array数组个数为：%ld",arrayCount);
    
    int i=0;
    for (id obj in array) {
        NSLog(@"当前第%d个为%@",i,obj);
        i++;
    }
    
    //常用的数组操作
    NSString *lastString=[array lastObject];
    NSLog(@"最后一个对象的值为：%@",lastString);
    
    NSString *firstString=[array firstObject];
    NSLog(@"第一个对象的值为：%@",firstString);
    
    NSString *indexString=[array objectAtIndex:1];
    NSLog(@"第二个对象的值为:%@",indexString);
    
    NSInteger indexInt=[array indexOfObject:@"cnblogs"];
    NSLog(@"返回索引的位置：%ld",indexInt);
    
    //将字符串转化成数组
    NSString *arrayString=@"a,b,c,d";
    NSArray *newArray=[arrayString componentsSeparatedByString:@","];
    for (id obj in newArray) {
        NSLog(@"当前字符串转化为%@",obj);
    }
    
    //判断数组是否存在元素
    if ([newArray containsObject:@"c"]) {
        NSLog(@"存在字母c的元素");
    }
    else
    {
        NSLog(@"不存在字母c的元素");
    }
    
    //简便创建
    NSArray *twoArray=[NSArray arrayWithObjects:@1,@2,@3,@4,@5,nil];
    //迭代器遍历  reverseObjectEnumerator数组元素从后向前访问
    NSEnumerator *arrayenumerator=[twoArray reverseObjectEnumerator];
    id obj=nil;
    while (obj=[arrayenumerator nextObject]) {
        NSLog(@"当前值为：%d",[obj intValue]);
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
