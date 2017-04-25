//
//  Person.h
//  Tan_TestIOS
//
//  Created by PX_Mac on 2017/4/25.
//  Copyright © 2017年 M C. All rights reserved.
//  测试block的用法

#import <Foundation/Foundation.h>

@interface Person : NSObject

//1、block作为属性, 一般arc环境下用strong修饰，非arc环境下用copy修饰
@property (nonatomic, strong) void (^runBlock)(NSString *name);


//2、block作为参数进行传递
- (void)transBlock:(void (^)())block; //传递不带参数的block
- (void)transBlockHasPara:(void (^)(NSString *name))block; //传递带参数的block


//3、block作为返回值
- (void (^)())returnBlock;
- (void (^)(NSString *name))getBlock;


@end
