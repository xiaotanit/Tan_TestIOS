//
//  TestFMDBVC.m
//  Tan_TestIOS
//
//  Created by M C on 2017/4/28.
//  Copyright © 2017年 M C. All rights reserved.
//

#import "TestFMDBVC.h"
#import "FMDB.h"

@interface TestFMDBVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSString *filePath;  //数据库文件路径
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;  //数据库队列

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation TestFMDBVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self selectAllData:nil]; //查询所有数据
}

- (NSString *)filePath{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
    return [path stringByAppendingPathComponent:@"Tan_FMDB.db"];
}

- (FMDatabaseQueue *)dbQueue{
    if (_dbQueue == nil){
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
        NSString *filePath = [path stringByAppendingPathComponent:@"Tan_FMDB.db"];
        
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    }
    return _dbQueue;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentity = @"testFMDBCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentity];
    }
    
    NSDictionary *dict = self.dataArr[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@--%@, age: %d", dict[@"name"], dict[@"email"], [dict[@"age"] intValue]];
    cell.detailTextLabel.text = dict[@"address"];
    
    return cell;
}

#pragma action
/** 创建数据表 */
- (IBAction)createTable:(id)sender{
    [self createTableWithDataBase:nil];
}

/** 一般性插入1w条数据 */
- (IBAction)insertNormalData:(UIButton *)sender{
    [self insertDataWithDataBase:nil];
}

/** 查询所有数据 */
- (IBAction)selectAllData:(id)sender{
    [self selectDataWithDataBase:nil];
}

/** 删除所有数据 */
- (IBAction)deleAllData:(id)sender{
    [self deleteDataWithDataBase:nil];
}

/** 事务插入1w条数据
 模拟器上测试结果：不使用事务插入1w条数据耗时超过10s, 真机更慢；
 使用事务插入1w条数据耗时不到1s
 */
- (IBAction)insertTransactionData:(id)sender{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSLog(@"...start insert: %@", [NSDate date]);
        NSDate *startDate = [NSDate date];
        int alreadyDataCount = [self getDataCount:nil];
        
        FMDatabase *db = [FMDatabase databaseWithPath:self.filePath];
        
        if ([db open]){
            [db beginTransaction]; //开启事务
            
            for (int i = alreadyDataCount; i < alreadyDataCount+10000; i++) {
                NSString *name = [NSString stringWithFormat:@"%@%d", [self getPersonName], i];
                NSString *email = [NSString stringWithFormat:@"e%d%@", i, [self getEmail]];
                int age = 18 + arc4random_uniform(100);
                float experience = arc4random_uniform(20)/3.0;
                NSString *address = [self getAddress];
                NSNumber *time = @([[NSDate date] timeIntervalSince1970]);
                
                NSString *sql = @"insert into tbl_Person (name, email, age, experience, address, createtime) values(?, ?, ?, ?, ?, ?)";
                BOOL isOK = [db executeUpdate:sql withArgumentsInArray:@[name, email, @(age), @(experience), address, time]];
                
                if (!isOK){
                    [db rollback]; //事务回滚
                    [db close];
                    return;
                }
            }
            
            [db commit]; //提交事务
            [db close];
        }
        
        NSLog(@"...end insert: %@", [NSDate date]);
        NSInteger marginSecond = [[NSDate date] timeIntervalSinceDate:startDate];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *alertMsg = [NSString stringWithFormat:@"使用事务插入1w条数据共用时：%d秒", (int)marginSecond];
            
            [self showAlertMsg:alertMsg withBlock:^{
                [self selectAllData:nil];
            }];
        });
        /*
         ..start insert: Fri Apr 28 16:29:50 2017
         ...end insert: Fri Apr 28 16:31:08 2017
         插入1w条数据共用时：31:08 - 29:50 = 78s
         
         模拟器:
         ...start insert: 2017-04-28 08:55:59 +0000
         ...end insert: 2017-04-28 08:56:55 +0000
         56:55 - 55:59 = 56S
         */
    });
}

/** 删除数据表 */
- (IBAction)deleteTable:(id)sender{
    [self deleteTableWithDataBase:nil];
}


/** 非线程安全增删查改 */
-(IBAction)noSafetyTest:(id)sender{
    [self insertDataWithDataBase:nil];
    [self deleteDataWithDataBase:nil];
    [self deleteTableWithDataBase:nil];
    [self insertDataWithDataBase:nil];
}
/** 线程安全增删查改： 感觉这个线程安全和非线程安全没有什么区别啊 */
- (IBAction)safetyTest:(id)sender{
//    dispatch_queue_t q1 = dispatch_queue_create("queue1", NULL);
//    
//    dispatch_async(q1, ^{
//        [self.dbQueue inDatabase:^(FMDatabase *db) {
//            NSLog(@"..1111: %@", [NSThread currentThread]);
//            [self insertDataWithDataBase:db];
//        }];
//    });
//    
//    dispatch_async(dispatch_queue_create("queue2", NULL), ^{
//        [self.dbQueue inDatabase:^(FMDatabase *db) {
//            NSLog(@"..2222: %@", [NSThread currentThread]);
//            [self deleteDataWithDataBase:db];
//        }];
//    });
//    
//    dispatch_async(dispatch_queue_create("queue3", NULL), ^{
//        [self.dbQueue inDatabase:^(FMDatabase *db) {
//            NSLog(@"..3333: %@", [NSThread currentThread]);
//            [self deleteTableWithDataBase:db];
//        }];
//    });
//    
//    dispatch_async(dispatch_queue_create("queue4", NULL), ^{
//        [self.dbQueue inDatabase:^(FMDatabase *db) {
//            NSLog(@"..4444: %@", [NSThread currentThread]);
//            [self insertDataWithDataBase:db];
//        }];
//    });
}


- (IBAction)safetyTransationInsert:(UIButton *)sender{
    
    [self checkTableIsExist:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSLog(@"...start insert: %@", [NSDate date]);
        NSDate *startDate = [NSDate date];
        int alreadyDataCount = [self getDataCount:nil];
        
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            if ([db open]){
                [db beginTransaction];
                for (int i = alreadyDataCount; i < alreadyDataCount+10000; i++) {
                    NSString *name = [NSString stringWithFormat:@"%@%d", [self getPersonName], i];
                    NSString *email = [NSString stringWithFormat:@"e%d%@", i, [self getEmail]];
                    int age = 18 + arc4random_uniform(100);
                    float experience = arc4random_uniform(20)/3.0;
                    NSString *address = [self getAddress];
                    NSNumber *time = @([[NSDate date] timeIntervalSince1970]);
                    
                    NSString *sql = @"insert into tbl_Person (name, email, age, experience, address, createtime) values(?, ?, ?, ?, ?, ?)";
                    BOOL isOK = [db executeUpdate:sql withArgumentsInArray:@[name, email, @(age), @(experience), address, time]];
                    
                    if (!isOK){
                        [db rollback];
                        [db close];
                        return;
                    }
                }
                [db commit];
                [db close];
            }
        }];
         
        NSLog(@"...end insert: %@", [NSDate date]);
        NSInteger marginSecond = [[NSDate date] timeIntervalSinceDate:startDate];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *alertMsg = [NSString stringWithFormat:@"使用事务插入1w条数据共用时：%d秒", (int)marginSecond];
            
            [self showAlertMsg:alertMsg withBlock:^{
                [self selectDataWithDataBase:nil];
            }];
        });
    });
}

- (void)checkTableIsExist:(FMDatabase *)db{
    
    if (db == nil) db = [FMDatabase databaseWithPath:self.filePath];

    if ([db open]){
        if (![db tableExists:@"tbl_Person"]){
            [self createTableWithDataBase:db];
        }
    }
    
    [db close];
}

/** 创建数据表 */
- (void)createTableWithDataBase:(FMDatabase *)db{
    
    if (db == nil) db = [FMDatabase databaseWithPath:self.filePath];
    
    if ([db open]){
        NSString *sql = @"create table if not exists tbl_Person(\
        id integer primary key,\
        name text not null,\
        email text not null,\
        age integer check (age >= 18 & age < 120),\
        experience real default 0.0,\
        address text default '',\
        createtime integer default 0\
        )";
        
        if (![db executeUpdate:sql]){
            NSLog(@"create table fail ！");
        }
        else{
            NSLog(@"success create table ^_^");
        }
        [db close];
    }
}
/** 删除表 */
- (void)deleteTableWithDataBase:(FMDatabase *)db{
    
    if (db == nil) db = [FMDatabase databaseWithPath:self.filePath];
    
    if ([db open]){
        NSString *sql = @"drop table tbl_Person";
        
        if (![db executeUpdate:sql]){
            NSLog(@"drop table fail ！");
        }
        else{
            NSLog(@"drop table .success .");
            [self.dataArr removeAllObjects];
            [self.tableView reloadData];
        }
        [db close];
    }
}
/** 删除数据 */
- (void)deleteDataWithDataBase:(FMDatabase *)db{
    
    if (db == nil) db = [FMDatabase databaseWithPath:self.filePath];
    
    if ([db open]){
        NSString *str = @"delete all Data success ^_^";
        if (![db executeUpdate:@"delete from tbl_Person"]){
            str = @"delete all data fail ! ";
        }
        
        [self showAlertMsg:str withBlock:^{
            [self.dataArr removeAllObjects];
            [self.tableView reloadData];
        }];
        [db close];
    }
}
/** 查询数据 */
- (void)selectDataWithDataBase:(FMDatabase *)db{
    
    if (db == nil) db = [FMDatabase databaseWithPath:self.filePath];
    
    [self checkTableIsExist:db];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSMutableArray *array = [NSMutableArray array];
        
        if ([db open]){
            //执行查询SQL语句，返回查询结果
            FMResultSet *result = [db executeQuery: @"select * from tbl_Person"];
            
            NSLog(@"多少列：%d", [result columnCount]);
            
            /* 等效写法
             //        NSError *er;
             //        FMResultSet *rs1 = [self.db executeQuery:@"select * from tbl_Person where 1=?" values:@[@1] error:&er];
             //        NSLog(@"rs1.column: %d", [rs1 columnCount]);
             //        if (er){
             //            NSLog(@"er is err: %@", er);
             //        }
             //
             //        FMResultSet *rs2 = [self.db executeQueryWithFormat:@"select * from tbl_Person where 1=%d", 1];
             //        NSLog(@"rs2.column: %d", [rs2 columnCount]);
             //
             //        FMResultSet *rs3 = [self.db executeQuery:@"select * from tbl_Person where 1=?" withArgumentsInArray:@[@1]];
             //        NSLog(@"rs3.column: %d", [rs3 columnCount]);
             
             //        FMResultSet *rs4 = [self.db executeQuery:@"select * from tbl_Person where 1=?", @(1)];
             //        NSLog(@"rs4.column: %d", [rs4 columnCount]);
             */
            
            
            //获取查询结果的下一个记录
            while ([result next]) {
                NSDictionary *dict = [result resultDictionary];
                [array addObject:dict];
            }
            [result close];
            [db close];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:array];
            
            NSLog(@"arr.count: %d", (int)array.count);
            
            [self.tableView reloadData];
        });
    });
    
    /*
     // 执行查询SQL语句，返回FMResultSet查询结果
     - (FMResultSet *)executeQuery:(NSString*)sql, ... ;
     - (FMResultSet *)executeQueryWithFormat:(NSString*)format, ... ;
     - (FMResultSet *)executeQuery:(NSString *)sql withArgumentsInArray:(NSArray *)arguments;
     
     //处理结果FMResultSet的常用方法：
     //获取下一个记录
     - (BOOL)next;
     //获取记录有多少列
     - (int)columnCount;
     //通过列名得到列序号，通过列序号得到列名
     - (int)columnIndexForName:(NSString *)columnName;
     - (NSString *)columnNameForIndex:(int)columnIdx;
     //获取存储的整形值
     - (int)intForColumn:(NSString *)columnName;
     - (int)intForColumnIndex:(int)columnIdx;
     //获取存储的长整形值
     - (long)longForColumn:(NSString *)columnName;
     - (long)longForColumnIndex:(int)columnIdx;
     //获取存储的布尔值
     - (BOOL)boolForColumn:(NSString *)columnName;
     - (BOOL)boolForColumnIndex:(int)columnIdx;
     //获取存储的浮点值
     - (double)doubleForColumn:(NSString *)columnName;
     - (double)doubleForColumnIndex:(int)columnIdx;
     //获取存储的字符串
     - (NSString *)stringForColumn:(NSString *)columnName;
     - (NSString *)stringForColumnIndex:(int)columnIdx;
     //获取存储的日期数据
     - (NSDate *)dateForColumn:(NSString *)columnName;
     - (NSDate *)dateForColumnIndex:(int)columnIdx;
     //获取存储的二进制数据
     - (NSData *)dataForColumn:(NSString *)columnName;
     - (NSData *)dataForColumnIndex:(int)columnIdx;
     //获取存储的UTF8格式的C语言字符串
     - (const unsigned cahr *)UTF8StringForColumnName:(NSString *)columnName;
     - (const unsigned cahr *)UTF8StringForColumnIndex:(int)columnIdx;
     //获取存储的对象，只能是NSNumber、NSString、NSData、NSNull
     - (id)objectForColumnName:(NSString *)columnName;
     - (id)objectForColumnIndex:(int)columnIdx;
     */
}
- (void)insertDataWithDataBase:(FMDatabase *)db{
    
    if (db == nil) db = [FMDatabase databaseWithPath:self.filePath];
    
    [self checkTableIsExist:db];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSLog(@"...start insert: %@", [NSDate date]);
        NSDate *startDate = [NSDate date];
        int alreadyDataCount = [self getDataCount:db];
        
        if ([db open]){
            for (int i = alreadyDataCount; i < alreadyDataCount+10000; i++) {
                NSString *name = [NSString stringWithFormat:@"%@%d", [self getPersonName], i];
                NSString *email = [NSString stringWithFormat:@"e%d%@", i, [self getEmail]];
                int age = 18 + arc4random_uniform(100);
                float experience = arc4random_uniform(20)/3.0;
                NSString *address = [self getAddress];
                NSNumber *time = @([[NSDate date] timeIntervalSince1970]);
                
                NSString *sql = @"insert into tbl_Person (name, email, age, experience, address, createtime) values(?, ?, ?, ?, ?, ?)";
                [db executeUpdate:sql withArgumentsInArray:@[name, email, @(age), @(experience), address, time]];
            }
            [db close];
        }
        
        
        NSLog(@"...end insert: %@", [NSDate date]);
        NSInteger marginSecond = [[NSDate date] timeIntervalSinceDate:startDate];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *alertMsg = [NSString stringWithFormat:@"插入1w条数据共用时：%d秒", (int)marginSecond];
            
            [self showAlertMsg:alertMsg withBlock:^{
                [self selectDataWithDataBase:db];
            }];
        });
    });
    
    /*
     //四种写法
     [database executeUpdate:@"insert into tbl_Person(num,name,sex) values(0,'liuting','m');"];
     
     NSString *sql = @"insert into tbl_Person(num,name,sex) values(?,?,?);";
     [database executeUpdate:sql,@0,@"liuting",@"m"];
     
     [database executeUpdate:sql withArgumentsInArray:@[@0,@"liuting",@"m"]];
     
     [database executeUpdateWithFormat:@"insert into tbl_Person(num,name,sex) values(%d,%@, %@);",0,@"liuting","m"];
     */
}
/** 获取数据库多少条数据 */
- (int)getDataCount:(FMDatabase *)db{
    
    if (db == nil) db = [FMDatabase databaseWithPath:self.filePath];
    
    [self checkTableIsExist:db];
    
    if ([db open]){
        FMResultSet *result2 = [db executeQueryWithFormat:@"select count(1) from tbl_Person where 1=%d", 1];
        if ([result2 next]){
            NSLog(@"...一共多少条数据： %d", [result2 intForColumnIndex:0]);
        }
        [result2 close];
        
        FMResultSet *result = [db executeQuery:@"select count(1) from tbl_Person"];
        int count = 0;
        
        if ([result next]) {
            count = [result intForColumnIndex:0];
        }
        [result close];
        [db close];
        return count;
    }
    
    return 0;
}


#pragma mark 辅助方法
- (NSString *)getPersonName{
    NSArray *arr = @[@"王大锤", @"任我行", @"张无忌", @"风清扬", @"李慕白", @"燕南天", @"李寻欢", @"段智深", @"洪熙官", @"方世玉", @"楚留香", @"陆小凤", @"谢烟客", @"周伯通", @"王重阳"];
    return arr[arc4random_uniform((int)arr.count)];
}

- (NSString *)getEmail{
    NSArray *arr = @[@"dachui@sina.com", @"yam@hotmail.com", @"mubai@163.com", @"xunhuan@126.com", @"shen@139.com", @"teng@aliyun.com", @"mahua@outlook.com", @"gege@gmail.com", @"luohu@yahoo.com", @"chao@sohu.com"];
    return arr[arc4random_uniform((int)arr.count)];
}

- (NSString *)getAddress{
    NSArray *arr = @[@"鹏城第一峰", @"西乡步行街", @"南山科技园", @"天安数码城", @"罗湖莲花山", @"盐田大梅沙", @"龙华富士康", @"福永万福壁", @"深圳图书馆", @"福田华强北", @"宝安碧海湾"];
    return arr[arc4random_uniform((int)arr.count)];
}

- (NSMutableArray *)dataArr{
    if (_dataArr == nil){
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}

- (void)showAlertMsg:(NSString *)alertMsg withBlock:(void (^)())successBlock{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:alertMsg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (successBlock) successBlock();
    }];
    [alertVC addAction:action];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)dealloc{
    NSLog(@"控制器被销毁： %@", self);
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
