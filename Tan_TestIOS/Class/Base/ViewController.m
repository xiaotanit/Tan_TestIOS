//
//  ViewController.m
//  Tan_TestIOS
//
//  Created by M C on 2017/4/13.
//  Copyright © 2017年 M C. All rights reserved.
//

#import "ViewController.h"
#import "TestVC.h"
#import "TestOtherVC.h"
#import "TestEventVC.h"
#import "CameraVC.h"    //相机和相册

@interface ViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *textField3;
@property (weak, nonatomic) IBOutlet UITextField *textField4;

@property (nonatomic, strong) NSTimer *myTimer;
@property (nonatomic, strong) dispatch_source_t timer2;

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
    
    [self testTime1];
    [self testTime2];
    [self testTime3];  //测试sche添加时钟器，还是设置三种RunLoop模式
//    [self gcdTimer];    //添加GCD时钟器
//    [self observer];
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
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:date interval:1.5 target:self selector:@selector(printInfo2) userInfo:@"哈哈哈" repeats:YES];
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

/** 这种模式创建的时钟器不能设置模式：默认是堵塞模式，可以改成非堵塞模式 
 scheduledTimerWithTimeInterval创建的时钟器默认添加到当前RunLoop中，且模式是默认模式
 */
- (void)testTime3{
////    第一种方式
//    [NSTimer scheduledTimerWithTimeInterval:2.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        [self printInfo3];
//    }];
    
//    //第二种方式
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(printInfo3) userInfo:@"哈哈" repeats:YES];
    

//    //第三种方式， 手动将NSTimer设置模式
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self printInfo3];
    }];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    /**  end  **/
    
    
    
    /** **** start  test 将时钟器添加到两种模式上 验证UITrackingRunLoopMode模式 *****/
    NSTimer *timer2 = [NSTimer timerWithTimeInterval:2.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        NSLog(@"test.RunLoop.mode: %@", [NSRunLoop currentRunLoop].currentMode);
        [self printInfo4];
        /*
         打印日志有两个模式（堵塞和非堵塞）：
         test.RunLoop.mode: UITrackingRunLoopMode
         test.RunLoop.mode: UITrackingRunLoopMode
         test.RunLoop.mode: UITrackingRunLoopMode
         test.RunLoop.mode: kCFRunLoopDefaultMode
         */
    }];
    [[NSRunLoop currentRunLoop] addTimer:timer2 forMode:NSDefaultRunLoopMode]; //默认模式
    [[NSRunLoop currentRunLoop] addTimer:timer2 forMode:UITrackingRunLoopMode];    //追踪模式
    /*
     验证结果：
     使用timerWithTimeInterval创建的时钟器默认没有任何模式，
     1、如果手动添加到NSDefaultRunLoopMode模式，则无UI或拖拽事件时调用方法，有UI或拖拽事件停止调用方法
     2、如果手动添加到UITrackingRunLoopMode模式，则无UI或拖拽事件时不会调用方法，有UI或拖拽事件时调用方法
     3、如果通知同时添加NSDefaultRunLoopMode和UITrackingRunLoopMode两种模式，则一直会调用方法
     4、如果只添加到NSRunLoopCommonModes模式，也一直调用方法（其效果相当于NSDefaultRunLoopMode加UITrackingRunLoopMode）
     
     如果使用scheduledTimerWithTimeInterval创建时钟器，则默认已经添加到NSDefaultRunLoopMode模式
     */
    
    /** *** end ****/
    
    
    //在子线程添加时钟器，需要让子线程RunLoop运行起来
    [NSThread detachNewThreadWithBlock:^{
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//            NSLog(@"run2----------%@",[NSRunLoop currentRunLoop].currentMode);
            //打印日志： run2----------kCFRunLoopDefaultMode
        }];
        
        NSLog(@"%@",[NSThread currentThread]);
        NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
        [currentRunLoop addTimer:timer forMode:NSRunLoopCommonModes];
        
        [currentRunLoop run]; //子线程RunLoop默认不运行，需要手动调用
    }];
}

/** GCD时钟器 */
- (void)gcdTimer {
    /*
     参数1 : 需要创建的源的种类, timer 也是一种数据源
     参数2,参数3: 在你创建timer的时候直接传0就可以了
     参数4: timer触发的代码运行的队列
     */
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    /*
     参数1 : timer定时器
     参数2 : 从什么时间开始触发定时器, DISPATCH_TIME_NOW代表现在
     参数3 : 时间间隔
     参数4 : 表示精度, 传0表示绝对精准
     */
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    
    /*
     封装timer需要触发的操作
     */
    dispatch_source_set_event_handler(timer, ^{
        static int i = 0;
        NSLog(@"GCDTimer-----%@, i=%d",[NSThread currentThread], i);
        NSLog(@"%@",[NSRunLoop currentRunLoop].currentMode);
        i++;
        /*
         GCDTimer-----<NSThread: 0x608000276ec0>{number = 6, name = (null)}, i=15
         (null)
         */
    });
    dispatch_resume(timer);
    
    /*
     用强指针引用, 防止timer释放
     */
    self.timer2 = timer;
}

/**  */
- (void)observer {
    
    /*
     参数1 :分配内存空间的方式, 传默认
     参数2 :RunLoop的运行状态
     参数3 :是否持续观察
     参数4 :优先级, 传0
     参数5 :观察者观测到状态改变时触发的方法
     */
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        
        /*
         typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
         kCFRunLoopEntry = (1UL << 0),
         kCFRunLoopBeforeTimers = (1UL << 1),
         kCFRunLoopBeforeSources = (1UL << 2),
         kCFRunLoopBeforeWaiting = (1UL << 5),
         kCFRunLoopAfterWaiting = (1UL << 6),
         kCFRunLoopExit = (1UL << 7),
         kCFRunLoopAllActivities = 0x0FFFFFFFU
         };
         */
        //一直在kCFRunLoopBeforeTimers -> kCFRunLoopBeforeSources -> kCFRunLoopBeforeWaiting -> kCFRunLoopAfterWaiting 四个循环调用
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"即将被唤醒");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"即将处理定时器事件");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"即将处理输入源事件");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"即将进入休眠");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"休眠结束");
                break;
            case kCFRunLoopExit:
                NSLog(@"运行循环退出");
                break;
            default:
                break;
        }
    });
    /*
     参数1 :运行循环, 传入当前的运行循环
     参数2 :观察者, 观察运行循环的各种状态
     参数3 :运行循环的模式
     */
    CFRunLoopAddObserver(CFRunLoopGetCurrent(),observer, kCFRunLoopDefaultMode);
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


#pragma mark - TestMethod
- (IBAction)Pause:(id)sender{
    if (self.myTimer) [self.myTimer invalidate];
}
- (IBAction)Continue:(id)sender{
    if (self.myTimer) [self.myTimer fire]; //无效之后，启用不了
}

/** 进入下一个run界面 */
- (IBAction)TestRunLoop:(id)sender{
    TestVC *vc = [TestVC new];
    [self presentViewController:vc animated:YES completion:nil];
}

/** 测试FMDB */
- (IBAction)testFMDB:(id)sender{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"FMDB_SB"];
    
    if (vc) [self presentViewController:vc animated:YES completion:nil];
}

/* 测试其他的 */
- (IBAction)testOther:(id)sender{
//    TestOtherVC *vc = [TestOtherVC new];
//    [self presentViewController:vc animated:YES completion:nil];
    
    TestEventVC *vc = [TestEventVC new];
    [self presentViewController:vc animated:YES completion:nil];
}

/* 打开相机和从相册选择相片 */
- (IBAction)testCameraOrAlbum:(id)sender{
    CameraVC *vc = [CameraVC new];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
