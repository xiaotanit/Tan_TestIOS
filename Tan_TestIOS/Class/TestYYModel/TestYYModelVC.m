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
}

/** 模型转字典 */
- (IBAction)modelConvertDict:(UIButton *)sender {
    
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
