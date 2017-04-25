//
//  Person.m
//  Tan_TestIOS
//
//  Created by PX_Mac on 2017/4/25.
//  Copyright © 2017年 M C. All rights reserved.
//

#import "Person.h"

@implementation Person

//传递不带参数的block
- (void)transBlock:(void (^)())block{
    NSLog(@"传递不带参数的block作为参数。。。111_111");
    block();
}

//传递带参数的block
- (void)transBlockHasPara:(void (^)(NSString *name))block{
    NSLog(@"传递带参数的block作为参数 ^_^222_111");
    block(@"传递参数one222_222");
}


//返回block
- (void (^)())returnBlock{
    return ^() {
        NSLog(@"返回block, I'm a block ....");
    };
}
//返回带参数的block
- (void (^)(NSString *name))getBlock{
    return ^(NSString *name){
        NSLog(@"返回一个带参数的block, 参数：%@", name);
    };
}


@end
