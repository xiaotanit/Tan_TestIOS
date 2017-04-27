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
    //ios 10 本地推送
    static int i = 0;
    i +=1;
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"from the earth's notification";
    content.subtitle = @"to Tan";
    content.body = [NSString stringWithFormat:@"the beautiful's girl to give you 一共%d条信息!", i];
    content.badge = @0;
    content.userInfo = @{@"id":@(88), @"name":@"王大锤", @"email":@"dachui@sina.com", @"content":@"Imagination is more important than knowledge!"};
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"comeon" ofType:@"jpg"];
    NSError *error = nil;
    //将本地图片的路径形成一个图片附件，加入到content中
    UNNotificationAttachment *imgAttach = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
    if (error){
        NSLog(@"异常错误： %@", error);
    }
    content.attachments = @[imgAttach];
    
    //设置为@""以后，进入app将没有启动页
//    content.launchImageName = @"";
    
    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    content.sound = sound;
    
    //设置时间间隔的触发器： 如果需要重复触发通知，时间间隔必须大于60s
    //例如：[UNTimeIntervalNotificationTrigger triggerWithTimeInterval:70 repeats:YES];
    UNTimeIntervalNotificationTrigger *timeTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10 repeats:NO];
    NSString *requestIdentifier = @"time interval request";
    content.categoryIdentifier = @"";
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:timeTrigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        
        if (error){
            NSLog(@"碉堡了，有错误： %@", error);
        }
    }];
    
    /*
     UNUserNotificationCenter通知中心，用以管理通知的注册、权限获取和管理、通知的删除与更新，通过代理分发事件等。
     UNNotification 通知实体，在UNUserNotificationCenter的代理回调事件中，告知App接收到一条通知，包含一个发起通知的请求UNNotificationRequest
     UNNotificationRequest包含通知内容UNNotificationContent和触发器UNNotificationTrigger
     UNNotificationContent 通知内容，通知的title，sound，badge以及相关的图像、声音、视频附件UNNotificationAttachment，触发打开App时候指定的LacnchImage等
     UNNotificationResponse，用户在触发了按钮或者文本提交的UNNotificationAction的时候，会形成一个response，通过通知中心的代理方法回调给App进行处理或者是交给扩展处理。
     UNNotificationServiceExtension，是一个在接收到APNs服务器推送过来的数据进行处理的服务扩展，如果App提供了服务扩展，那么APNs下发推送后在通知显示触发之前，会在UNNotificationServiceExtension内接收到，此处有大约30秒的处理时间，开发者可以进行一些数据下载、数据解密、更新等操作，然后交由而后的内容扩展(UNNotificationContentExtension)或者是App进行触发显示
     UNNotificationCategory,用以定义一组样式类型，该分类包含了某一个通知包含的交互动作的组合，比如说UNNotificationRequest内包含了一个Category标示，那该通知就会以预定义好的交互按钮或者文本框添加到通知实体上。
     UNNotificationAttachment，通知内容UNNotificationContent包含的附件，一般为图片、视频和音频，虽然iOS10的通知数据容量为4k，但依旧很少，在添加了UNNotificationServiceExtension扩展的情况下，可以在服务里下载图片，生成图片、视频等的本地缓存，UNNotificationAttachment根据缓存数据生成并添加到UNNotificationContent中，交由UI显示
     UNNotificationAction，是通知中添加的action，展示在通知栏的下方。默认以的button样式展示。有一个文本输入的子类UNTextInputNotificationAction。可以在点击button之后弹出一个键盘，输入信息。用户点击信息和输入的信息可以在UNNotificationResponse中获取
     
     
     
     ------- 触发器 ----
     UNPushNotificationTrigger，远程推送触发器，一般是远程推送推过来的通知带有这类触发器
     UNTimeIntervalNotificationTrigger，时间间隔触发器，定时或者是重复，在本地推送设置中有用
     UNCalendarNotificationTrigger，日历触发器，指定日期进行通知
     UNLocationNotificationTrigger，地理位置触发器，指定触发通知的条件是地理位置CLRegion这个类型。
     触发器和内容最后形成UNNotificationRequest，一个通知请求，本地通知的请求，直接交给通知中心进行发送，发送成功后，该通知会按照触发器的触发条件进行触发，并且会显示到通知中心上，用户可与指定的category交互方式与通知进行交互
     
     */
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
