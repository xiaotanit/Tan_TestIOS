//
//  TestEventVC.m
//  Tan_TestIOS
//
//  Created by M C on 2017/8/23.
//  Copyright © 2017年 M C. All rights reserved.
//

#import "TestEventVC.h"
#import "MyView.h"

@interface TestEventVC ()

@end

@implementation TestEventVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MyView *redView = [[MyView alloc] initWithFrame:CGRectMake(50, 100, 60, 30)];
    redView.name = @"红色View";
    
    redView.backgroundColor = [UIColor redColor];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    lbl.text = @"点我";
    lbl.textColor = [UIColor whiteColor];
    lbl.textAlignment = NSTextAlignmentCenter;
    [redView addSubview:lbl];
    
    [self.view addSubview:redView];
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
