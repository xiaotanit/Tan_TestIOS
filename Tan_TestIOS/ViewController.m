//
//  ViewController.m
//  Tan_TestIOS
//
//  Created by M C on 2017/4/13.
//  Copyright © 2017年 M C. All rights reserved.
//

#import "ViewController.h"
#import "TestVC.h"

@interface ViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *textField3;
@property (weak, nonatomic) IBOutlet UITextField *textField4;

@property (nonatomic, strong) NSTimer *myTimer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    self.textField.delegate = self;
    self.textField.layer.borderColor = [UIColor redColor].CGColor;
    self.textField.layer.borderWidth = 1;
    self.textField.enablesReturnKeyAutomatically = NO;
    
    self.textView.delegate = self;
//    self.textView.text = nil;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.borderColor = [UIColor greenColor].CGColor;
    self.textView.enablesReturnKeyAutomatically = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    
    NSRunLoop *loop = [NSRunLoop mainRunLoop];
    NSRunLoop *loop2 = [NSRunLoop currentRunLoop];
    
    NSLog(@"loop.model: %@, loop2.model: %@", loop.currentMode, loop2.currentMode);
    
    //遥远的将来，遥远的过去
    NSLog(@"distantFuture: %@, past: %@", [NSDate distantFuture], [NSDate distantPast]);
    
//    [self testTime1];
//    [self testTime2];
    [self testTime3];
    
    UIButton *pauseBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 380, 80, 30)];
    pauseBtn.backgroundColor = [UIColor blackColor];
    [pauseBtn setTitle:@"暂停" forState:UIControlStateNormal];
    [pauseBtn addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pauseBtn];
    
    UIButton *fireBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 380, 80, 30)];
    fireBtn.backgroundColor = [UIColor blackColor];
    [fireBtn setTitle:@"继续" forState:UIControlStateNormal];
    [fireBtn addTarget:self action:@selector(fire) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fireBtn];
}

/** repeats不管是YES还是NO只执行一次 */
- (void)testTime1{
    //第一种方式
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:[NSDate distantPast] interval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self printInfo:timer];
    }];
    [timer fire];
    
    //第二种方式：效果一样
//    NSTimer *timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:1.0 target:self selector:@selector(printInfo:) userInfo:@"哈哈哈" repeats:YES];
//    [timer fire];
}

/** 当前时间的10s后执行方法，repeats控制是否循环调用， timeInterval表示循环调用的时间间隔
 将timer添加到RunLoop后才会循环执行
 */
- (void)testTime2{
    NSLog(@"start .....");
    NSDate *date = [[NSDate date] dateByAddingTimeInterval:5];
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:date interval:1.5 target:self selector:@selector(printInfo:) userInfo:@"哈哈哈" repeats:YES];
    //NSDefaultRunLoopMode表示默认模式 NSRunLoopCommonModes：不堵塞线程模式、
    /*
     kCFRunLoopDefaultMode：app默认Mode，通常主线程是在这个Mode下运行
     UITrackingRunLoopMode：界面跟踪Mode，用于Scrollview追踪触摸滑动，保证界面滑动不受其他Mode影响
     UIInitializationRunLoopMode：在刚启动App时进入的第一个Mode，启动完成后就不再使用
     GSEventReceiveRunLoopMode：接受系统时间的内部Mode，通常用不到
     kCFRunLoopCommonModes：这是一个占位用的Mode，不是一种真正的Mode，即可能kCFRunLoopDefaultMode，也可能是UITrackingRunLoopMode
     */
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.myTimer = timer;
}

/** 这种模式创建的时钟器不能设置模式：默认是堵塞模式，可以改成费堵塞模式 */
- (void)testTime3{
    //第一种方式
//    [NSTimer scheduledTimerWithTimeInterval:2.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        [self printInfo:timer];
//    }];
    
    //第二种方式
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(printInfo:) userInfo:@"哈哈" repeats:YES];
    

    //第三种方式， 手动将NSTimer设置模式
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self printInfo:timer];
    }];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

/** 暂停 */
- (void)pause{
    if (self.myTimer) [self.myTimer invalidate];
}
/** 启用 */
- (void)fire{
    if (self.myTimer) [self.myTimer fire]; //无效之后，启用不了
    
    TestVC *vc = [TestVC new];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)printInfo:(NSTimer *)timer{
    NSLog(@"yes.....");
    static int num = 100;
    self.textField.text = [NSString stringWithFormat:@"11%d", num];
    num++;
    NSLog(@"timer.userino: %@, timervalue: %f, filreDate: %@", timer.userInfo, timer.timeInterval, timer.fireDate);
}

- (void)printInfo2{
    static int num = 100;
    self.textField2.text = [NSString stringWithFormat:@"22%d", num];
    num++;
}

- (void)printInfo3{
    static int num = 100;
    self.textField3.text = [NSString stringWithFormat:@"33%d", num];
    num++;
}

- (void)printInfo4{
    static int num = 100;
    self.textField4.text = [NSString stringWithFormat:@"44%d", num];
    num++;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldChange:(NSNotification *)notice{
    NSLog(@"textField: %@", self.textField.text);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
