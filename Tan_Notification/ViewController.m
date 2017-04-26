//
//  ViewController.m
//  Tan_Notification
//
//  Created by M C on 2017/4/26.
//  Copyright © 2017年 M C. All rights reserved.
//

#import "ViewController.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)addNotification:(UIButton *)sender{
    NSLog(@"....增加本地通知。。。");
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        [self createLatestLocalNotification];
    }
    else{
        [self createLocalNotification];
    }
}

- (void)createLatestLocalNotification{
    // 使用 UNUserNotificationCenter 来管理通知
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    
    //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:@"Hello_Title" arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:@"Hello_Message_Body"
                                                         arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    
    content.userInfo = @{@"name":@"王大锤", @"id":@(88), @"age":@(18)};
    content.subtitle = @"sub标题呢";
//    content.categoryIdentifier = @"_1_2_tan_test";
    
    
    
    // 在 alertTime 后推送本地推送
    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                  triggerWithTimeInterval:10 repeats:NO];
    
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"FiveSecond"
                                                                          content:content trigger:trigger];
    
    //添加推送成功后的处理！
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"本地通知" message:@"成功添加推送" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }];
}

- (void)createLocalNotification{
    /*
     本地Notification所使用的对象是UILocalNotification，UILocalNotification的属性涵盖了所有处理Notification需要的内容。UILocalNotification的属性有fireDate、timeZone、repeatInterval、repeatCalendar、alertBody、 alertAction、hasAction、alertLaunchImage、applicationIconBadgeNumber、 soundName和userInfo。
     UILocalNotification的调度
     
     其中fireDate、timeZone、repeatInterval和repeatCalendar是用于UILocalNotification的调度。fireDate是UILocalNotification的激发的确切时间。timeZone是UILocalNotification激发时间是否根据时区改变而改变，如果设置为nil的话，那么UILocalNotification将在一段时候后被激发，而不是某一个确切时间被激发。 repeatInterval是UILocalNotification被重复激发之间的时间差，不过时间差是完全根据日历单位（NSCalendarUnit）的，例如每周激发的单位，NSWeekCalendarUnit，如果不设置的话，将不会重复激发。 repeatCalendar是UILocalNotification重复激发所使用的日历单位需要参考的日历，如果不设置的话，系统默认的日历将被作为参考日历。
     
     UILocalNotification的提醒内容
     
     alertBody、alertAction、hasAction和alertLaunchImage是当应用不在运行时，系统处理
     */
    
    
    //创建一个本地通知
    UILocalNotification *noti = [[UILocalNotification alloc] init];
    noti.alertAction = @"myalertAction";
    // noti.alertTitle = @"myLocalNotificationTitle"; //通知标题，不写默认是app名称
    
    //设置推送时间: 20秒之后推送
    noti.fireDate = [NSDate dateWithTimeIntervalSinceNow:5.0];
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@"HH:mm:ss"];
    //    NSDate *setDate = [formatter dateFromString:@"15:00:00"];//触发通知的时间
    //    noti.fireDate = setDate;
    
    
    
    //设置重复间隔
    noti.repeatInterval = 2; //NSCalendarUnitWeekOfMonth;
    noti.repeatCalendar = [NSCalendar currentCalendar];
    
    //推送声音
    noti.soundName = UILocalNotificationDefaultSoundName;
    
    //设置时区：默认时区
    noti.timeZone = [NSTimeZone defaultTimeZone];
    
    //内容
    noti.alertBody = @"{\"name\":\"起床闹钟\", \"info\": \"哈哈，一日不读书，人傻好比猪\"}";
    
    //显示在icon上的红色圈中的数子
    noti.applicationIconBadgeNumber = 1;
    
    //设置userinfo 方便在之后需要撤销的时候使用
    noti.userInfo = @{@"key": @"tandaxia", @"url": @"http://cnblogs.com/tandaxia"};
    
    //添加推送到uiapplication
    [[UIApplication sharedApplication] scheduleLocalNotification:noti];
    
    
    
    /*
     //定义本地通知对象
     UILocalNotification *notification=[[UILocalNotification alloc]init];
     //设置调用时间
     notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:10.0];//通知触发的时间，10s以后
     notification.repeatInterval=2;//通知重复次数
     //notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
     
     //设置通知属性
     notification.alertBody =@"最近添加了诸多有趣的特性，是否立即体验？"; //通知主体
     notification.applicationIconBadgeNumber=1;//应用程序图标右上角显示的消息数
     notification.alertAction=@"打开应用"; //待机界面的滑动动作提示
     notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
     //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
     notification.soundName=@"msg.caf";//通知声音（需要真机才能听到声音）
     
     //设置用户信息
     notification.userInfo=@{@"id":@1,@"user":@"Kenshin Cui"};//绑定到通知上的其他附加信息
     
     //调用通知
     [[UIApplication sharedApplication] scheduleLocalNotification:notification];
     */
}

- (IBAction)showNotification:(UIButton *)sender{
    NSLog(@"展示本地通知。。。");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
