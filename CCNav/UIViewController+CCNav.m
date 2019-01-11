//
//  UIViewController+CCNav.m
//  ScrollChangeNavColor
//
//  Created by 周日朝 on 2018/11/30.
//  Copyright © 2018 RachalZhou. All rights reserved.
//

#import "UIViewController+CCNav.h"
#import "SwizzlingDefine.h"

@implementation UIViewController (CCNav)

#pragma mark - 准备工作

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzling_exchangeMethod([UIViewController class],
                                 @selector(viewWillAppear:),
                                 @selector(swizzled_viewWillAppear:));
        swizzling_exchangeMethod([UIViewController class],
                                 @selector(viewWillDisappear:),
                                 @selector(swizzled_viewWillDisappear:));
    });
}

- (void)swizzled_viewWillAppear:(BOOL)animated {
    [self start];
    [self swizzled_viewWillAppear:animated];
}

- (void)swizzled_viewWillDisappear:(BOOL)animated {
    [self reset];
    [self swizzled_viewWillDisappear:animated];
}

#pragma mark - 业务逻辑

- (void)start {
    self.navigationController.navigationBar.translucent = YES;
    UIImageView *shadowImg = [self seekLineImageViewOn:self.navigationController.navigationBar];
    shadowImg.hidden = YES;
}

- (void)reset {
    self.navigationController.navigationBar.translucent = NO;
    UIImageView *shadowImg = [self seekLineImageViewOn:self.navigationController.navigationBar];
    shadowImg.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

- (void)changeColor:(UIColor *)color scrolllView:(UIScrollView *)scrollView {
    // 默认临界值为200
    [self changeColor:color scrolllView:scrollView criticalValue:200];
}

- (void)changeColor:(UIColor *)color scrolllView:(UIScrollView *)scrollView criticalValue:(CGFloat)value {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    self.navigationController.navigationBar.hidden = offsetY < 0 ? YES : NO;
    
    if (offsetY >= 0) {
        // 透明度
        CGFloat alpha = offsetY / value > 1.0f ? 1 : (offsetY / value);
        self.navigationController.navigationBar.translucent = alpha >= 1.0f ? NO : YES;
        
        // 背景色
        UIImage *image = [self imageWithColor:[color colorWithAlphaComponent:alpha]];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
}

// 查找导航栏下的横线
- (UIImageView *)seekLineImageViewOn:(UIView *)view {
    
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) return (UIImageView *)view;
    
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self seekLineImageViewOn:subview];
        if (imageView) return imageView;
    }
    return nil;
}

#pragma mark - Color To Image

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
