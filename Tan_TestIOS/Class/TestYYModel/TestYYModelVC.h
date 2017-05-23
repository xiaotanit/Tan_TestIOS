//
//  TestYYModelVC.h
//  Tan_TestIOS
//
//  Created by M C on 2017/5/23.
//  Copyright © 2017年 M C. All rights reserved.
//

#import "BaseVC.h"

@interface TestYYModelVC : BaseVC

@end



@interface YYAuthor : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSDate *birthday;

@end


@interface YYBook : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger pages;
@property (nonatomic, strong) YYAuthor *author;

@end


@interface TestModel : NSObject 

@property (nonatomic, assign) int ID;  //设置关键字别名
@property (nonatomic, strong) NSString *desc;

@property (nonatomic, assign) int year;
@property (nonatomic, assign) float money;
@property (nonatomic, strong) NSNumber *secondNumber;
@property (nonatomic, strong) NSNumber *moneyNumber;

@property (nonatomic, strong) NSDate *dateTime;

@property (nonatomic, strong) NSURL *imgUrl;

@property (nonatomic, assign) Class *className;
@property (nonatomic, assign) SEL *selName;

@property (nonatomic, strong) NSValue *valueName;


@property (nonatomic, strong) NSDictionary *dict; //字典
@property (nonatomic, strong) NSArray *array;   //数组, 数组里面存储的是模型对象
@property (nonatomic, strong) NSArray *array2;
@property (nonatomic, strong) NSArray *array3;
@property (nonatomic, strong) NSDictionary *dictModel;  //模型转字典

@end
