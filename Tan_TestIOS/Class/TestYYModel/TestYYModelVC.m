//
//  TestYYModelVC.m
//  Tan_TestIOS
//
//  Created by M C on 2017/5/23.
//  Copyright © 2017年 M C. All rights reserved.
//

#import "TestYYModelVC.h"
#import "YYModel.h"

@interface TestYYModelVC ()

@end

@implementation TestYYModelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // create model from json json转模型
    YYBook *book = [YYBook yy_modelWithJSON:@"{\"name\": \"Harry Potter\", \"pages\": 256, \"author\": {\"name\": \"J.K.Rowling\", \"birthday\": \"1965-07-31\" }}"];
    NSLog(@"book: %@", book);
    
    // convert model to json  模型转json字符串
    NSString *json = [book yy_modelToJSONString];
    NSLog(@"book->jsonString: %@", json);
    // {"author":{"name":"J.K.Rowling","birthday":"1965-07-31T00:00:00+0000"},"name":"Harry Potter","pages":256}
}

/** json转模型: json可以是json字符串、字典、NSData */
- (IBAction)jsonConvertModel:(UIButton *)sender {
    
    //1、json转模型：json可以是json字符串、字典、NSData
    NSString *jsonString = @"{\"name\": \"Harry Potter\", \"pages\": 256, \"author\": {\"name\": \"J.K.Rowling\", \"birthday\": \"1965-07-31\" }}";
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"jsonString: %@", jsonString);
    NSLog(@"jsonData: %@", jsonData);
    NSLog(@"jsonDict: %@", jsonDict);
    
    YYBook *book1 = [YYBook yy_modelWithJSON:jsonString];
    YYBook *book2 = [YYBook yy_modelWithJSON:jsonData];
    YYBook *book3 = [YYBook yy_modelWithJSON:jsonDict];
    NSLog(@"book1: %@", book1);
    NSLog(@"book2: %@", book2);
    NSLog(@"book3: %@", book3);
    //验证结果： json字符串/NSData/字典 --> 模型
    
    //字符串转二进制后变化
    NSData *data0 = [@"n" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data01 = [@"na" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data02 = [@"nam" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data1 = [@"name" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data2 = [@"{\"name\":\"zhangsan\"}" dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"data0: %@", data0);  //data0: <6e>  n 对应ASCII码的十进制为：123  十六进制为：6e
    NSLog(@"data01: %@", data01); //data01: <6e61> a对应ASCII码的数字为: 97  十六进制为：61
    NSLog(@"data02: %@", data02); //data02: <6e616d>
    NSLog(@"data1: %@", data1);  //data1: <6e616d65>
    NSLog(@"data2: %@", data2);  //data2: <7b226e61 6d65223a 227a6861 6e677361 6e227d>
    //{对应ASCII码的十进制为：123, 十六进制为：7b;   "双引号对应ASCII码十进制为34， 十六进制为：22
    
    
    //测试非json字符串转字典
    NSError *err;
    [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableLeaves error:&err];
    if (err){
        NSLog(@"字符串转字典报错：%@", err);
        //字符串转字典报错：Error Domain=NSCocoaErrorDomain Code=3840 "JSON text did not start with array or object and option to allow fragments not set." UserInfo={NSDebugDescription=JSON text did not start with array or object and option to allow fragments not set.}
    }
    
    
    //2、 字典转模型 各种类型
    NSDictionary *telDict = @{
                              @"id": @(88),
                              @"year": @"2017",
                              @"money": @(1024),
                              @"secondNumber": @(10000),
                              @"moneyNumber": @"5188",
                              @"dateTime": @"2017-05-22 15:31:33",
                              @"valueName": NSStringFromCGRect(self.view.frame),
                              @"imgUrl": @"http://www.baidu.com/tan/tan.png"
                              };
    TestModel *testModel = [TestModel yy_modelWithDictionary:telDict];
    NSLog(@"testModel: %@", testModel);
    //testModel: 0, 2017, 1024.000000, 10000, 5188, 2017-05-22 15:31:33 +0000, http://www.baidu.com/tan/tan.png, (null)
    
    
    
    
    //3、关键字别名、和数组模型
    YYAuthor *auth = [YYAuthor yy_modelWithDictionary:@{@"name":@"周杰伦", @"birthday":@"1976-10-10"}];
    
    NSDictionary *keyDict = @{
                              @"id": @"18",
                              @"description": @"描述性文字。。。",
                              @"array": @[@{@"name":@"王大锤", @"birthday":@"1990-12-02"}, @{@"name":@"李达康", @"birthday":@"1960-08-22"}],
                              @"array2":@[@{@"name":@"艾边城", @"birthday":@"1995-12-02"}, @{@"name":@"段智兴", @"birthday":@"1660-06-18"}],
                              @"array3":@[@{@"name":@"洪七公", @"birthday":@"1655-12-02"}, @{@"name":@"欧阳锋", @"birthday":@"1662-06-18"}],
                              @"dictModel": auth
                              };
    TestModel *model2 = [TestModel yy_modelWithDictionary:keyDict];
    NSLog(@"model2: %@", model2);
    
    
    TestModel *model3 = [TestModel yy_modelWithJSON:keyDict];
    NSLog(@"mdoel3: %@", model3);
    
    
    
    //4、模型转字典
    NSDictionary *dict4 = [model2 yy_modelToJSONObject];
    NSLog(@"模型转字典dict4：%@", dict4);
    
    //5、模型数组转数组
    NSArray *arr4 = [model2.array yy_modelToJSONObject];
    NSLog(@"模型数组转一般数组arr4: %@", arr4);
    
    //6、模型转json字符串
    NSString *jsonStr6 = [model2 yy_modelToJSONString];
    NSLog(@"模型转json字符串jsonStr6: %@", jsonStr6);
    
    //7、yy_modelDictionaryWithClass 方法的意义：字典/json字符串/NSData转模型
    NSDictionary *jsonDict7 = @{@"nickname":jsonDict};
    NSDictionary *dict7 = [NSDictionary yy_modelDictionaryWithClass:[YYBook class] json:jsonDict7];
    NSLog(@"json字符串转字典dict7: %@", dict7);
    
    //yy_modelArrayWithClass 方法的意义：json数组字符串或者NSData/NSArray 转模型
    NSArray *arr7 = [NSArray yy_modelArrayWithClass:[YYAuthor class] json:keyDict[@"array"]];
    NSLog(@"json字符串转数组arr7: %@", arr7);
    
    NSLog(@"...");
}

/** 模型转字典 */
- (IBAction)modelConvertDict:(UIButton *)sender {
    /*
     `NSString` or `NSNumber` -> c number, such as BOOL, int, long, float, NSUInteger...
     `NSString` -> NSDate, parsed with format "yyyy-MM-dd'T'HH:mm:ssZ", "yyyy-MM-dd HH:mm:ss" or "yyyy-MM-dd".
     `NSString` -> NSURL.
     `NSValue` -> struct or union, such as CGRect, CGSize, ...
     `NSString` -> SEL, Class.
     */
  
   
}

@end



@implementation YYAuthor

- (NSString *)description{
    return [NSString stringWithFormat:@"%@, %@", self.name, self.birthday];
}

@end

@implementation YYBook

- (NSString *)description{
    NSMutableString *ms = [NSMutableString stringWithFormat:@"%@, %lu, ", self.name, self.pages];
    
    if (self.author){
        [ms appendFormat:@"%@, %@", self.author.name, self.author.birthday];
    }
    return ms;
}

@end


@implementation TestModel

- (NSString *)description{
    
    return [NSString stringWithFormat:@"%d, %d, %f, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@", self.ID, self.year, self.money, self.secondNumber, self.moneyNumber, self.dateTime, self.imgUrl.absoluteString, self.valueName, self.array, self.array2, self.array3, self.dictModel, self.desc];
}


+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"ID":@"id",
             @"desc":@"description"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
             @"array": [YYAuthor class],
             @"array2": YYAuthor.class,
             @"array3": @"YYAuthor",
             @"dictModel": @"YYAuthor" //验证，字典不可以这样写
             };
}


@end
