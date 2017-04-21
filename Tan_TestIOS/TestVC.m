//
//  TestVC.m
//  Tan_TestIOS
//
//  Created by M C on 2017/4/20.
//  Copyright © 2017年 M C. All rights reserved.
//  测试NSTimer的销毁

#import "TestVC.h"

@interface TestVC ()

@property (nonatomic, weak) NSTimer *timer;

@end

@implementation TestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *fireBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 80, 80, 30)];
    fireBtn.backgroundColor = [UIColor blackColor];
    [fireBtn setTitle:@"返回" forState:UIControlStateNormal];
    [fireBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fireBtn];
    
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self printInfo:timer];
    }];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

- (void)printInfo:(NSTimer *)timer{
    static int num = 100;
    NSLog(@"哈哈哈num: %d", num);
    num++;
}

- (void)back{
    [self.timer invalidate];
    self.timer = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** 如果不处理NSTimer， 控制器得不到释放 */
- (void)dealloc{
    NSLog(@"%@被销毁。。。", self);
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
