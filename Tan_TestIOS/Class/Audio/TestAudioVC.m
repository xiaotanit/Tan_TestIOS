//
//  TestAudioVC.m
//  Tan_TestIOS
//
//  Created by M C on 2017/5/2.
//  Copyright © 2017年 M C. All rights reserved.
//

#import "TestAudioVC.h"
#import <AudioToolbox/AudioToolbox.h>



@interface TestAudioVC ()

@end

@implementation TestAudioVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}


- (IBAction)playAudio:(id)sender{
    //*.wav，*.caf 可以播放
    //temp.wav,  qishiwang.mp3,
    [self playSoundEffect:@"wxFile.pcm"]; //videoRing.caf
}


/**
 *  播放完成回调函数
 *
 *  @param soundID    系统声音ID
 *  @param clientData 回调时传递的数据
 */
void soundCompleteCallback(SystemSoundID soundID,void * clientData){
    NSLog(@"播放完成...");
}

/*
 AudioToolbox.framework是一套基于C语言的框架，使用它来播放音效其本质是将短音频注册到系统声音服务（System Sound Service）。System Sound Service是一种简单、底层的声音播放服务，但是它本身也存在着一些限制：
 
 音频播放时间不能超过30s
 数据必须是PCM或者IMA4格式
 音频文件必须打包成.caf、.aif、.wav中的一种（注意这是官方文档的说法，实际测试发现一些.mp3也可以播放）
 使用System Sound Service 播放音效的步骤如下：
 
 调用AudioServicesCreateSystemSoundID(   CFURLRef  inFileURL, SystemSoundID*   outSystemSoundID)函数获得系统声音ID。
 如果需要监听播放完成操作，则使用AudioServicesAddSystemSoundCompletion(  SystemSoundID inSystemSoundID,
 CFRunLoopRef  inRunLoop, CFStringRef  inRunLoopMode, AudioServicesSystemSoundCompletionProc  inCompletionRoutine, void*  inClientData)方法注册回调函数。
 调用AudioServicesPlaySystemSound(SystemSoundID inSystemSoundID) 或者AudioServicesPlayAlertSound(SystemSoundID inSystemSoundID) 方法播放音效（后者带有震动效果）。
 */
-(void)playSoundEffect:(NSString *)name{
    NSString *audioFile=[[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl=[NSURL fileURLWithPath:audioFile];
    //1.获得系统声音ID
    SystemSoundID soundID=0;
    /**
     * inFileUrl:音频文件url
     * outSystemSoundID:声音id（此函数会将音效文件加入到系统音频服务中并返回一个长整形ID）
     */
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    //如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    //2.播放音频
    AudioServicesPlaySystemSound(soundID);//播放音效
    //    AudioServicesPlayAlertSound(soundID);//播放音效并震动
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
