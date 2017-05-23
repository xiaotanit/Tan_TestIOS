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
