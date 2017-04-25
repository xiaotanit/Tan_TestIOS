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
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 80, 80, 30)];
    backBtn.backgroundColor = [UIColor blackColor];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *startBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 80, 80, 30)];
    startBtn.backgroundColor = [UIColor blackColor];
    [startBtn setTitle:@"开始" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startRun) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    
    UIButton *pauseBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 80, 80, 30)];
    pauseBtn.backgroundColor = [UIColor blackColor];
    [pauseBtn setTitle:@"暂停" forState:UIControlStateNormal];
    [pauseBtn addTarget:self action:@selector(pauseRun) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pauseBtn];
    
    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(10, 150, 300, 200)];
    redView.backgroundColor = [UIColor redColor];
//    redView.userInteractionEnabled = NO; //当父控件userInteractionEnalbed = NO, 所有子控件的交互都不能操作 UIView的交互默认YES
    [self.view addSubview:redView];
    
    UIButton *clickMeBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 80, 40)];
    [clickMeBtn setTitle:@"点我" forState:UIControlStateNormal];
    [clickMeBtn addTarget:self action:@selector(clickMe) forControlEvents:UIControlEventTouchUpInside];
    clickMeBtn.backgroundColor = [UIColor blackColor];
    [redView addSubview:clickMeBtn];
}

- (void)clickMe{
    UIAlertController *alertVC = [[UIAlertController alloc] init];

    UIAlertAction *action = [UIAlertAction actionWithTitle:@"标题1-默认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点我了1111");
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"标题2-取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点我了22222");
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"标题3-毁灭" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点我了3333");
    }];
    [alertVC addAction:action];
    [alertVC addAction:action2];
    [alertVC addAction:action3];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

/** 开始运行 */
- (void)startRun{
    
    NSLog(@"111-self.timer.isValid: %d", self.timer.isValid);
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self printInfo:timer];
    }];
    
    NSLog(@"222-self.timer.isValid: %d", self.timer.isValid);
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/** 暂停运行 */
- (void)pauseRun{
    [self.timer invalidate];
}

- (void)printInfo:(NSTimer *)timer{
    static int num = 100;
    NSLog(@"哈哈哈num: %d", num);
    num++;
}

/** 如果不处理NSTimer， 控制器得不到释放 */
- (void)back{
    [self.timer invalidate];
    self.timer = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setTimer:(NSTimer *)timer{
    [_timer invalidate];
    _timer = timer;
}

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
