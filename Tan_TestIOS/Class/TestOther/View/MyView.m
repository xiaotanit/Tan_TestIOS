//
//  MyView.m
//  Tan_TestIOS
//
//  Created by M C on 2017/8/23.
//  Copyright © 2017年 M C. All rights reserved.
//
//  测试响应者事件链： 先调用hitTest

#import "MyView.h"

@implementation MyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"hitTest...: %@", self.name);
    
    CGRect originRect = self.bounds;
    originRect.origin = CGPointMake(-15.0f, -10.0f);
    originRect.size = CGSizeMake(originRect.size.width + 30.0f, originRect.size.height + 20.0f);
    
    CGPoint touchPoint = [self convertPoint:point toView:self];
    if (CGRectContainsPoint(originRect, touchPoint)) {
        return self;
    }
    return [super hitTest:point withEvent:event];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    NSLog(@"pointInside...自动调用： %@, point: %@", self.name, NSStringFromCGPoint(point));
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"开始触摸。。。: %@", self.name);
}


@end
