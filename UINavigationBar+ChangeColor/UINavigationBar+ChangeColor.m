//
//  UINavigationBar+ChangeColor.m
//  ScrollChangeColorNavTest
//
//  Created by Rachal on 2016/11/3.
//  Copyright © 2016年 RachalZhou. All rights reserved.
//

#import "UINavigationBar+ChangeColor.h"

@implementation UINavigationBar (ChangeColor)

- (void)start {
    
    self.translucent = YES;
    UIImageView *shadowImg = [self seekLineImageViewOn:self];
    shadowImg.hidden = YES;
}

- (void)reset {
    
    self.translucent = NO;
    UIImageView *shadowImg = [self seekLineImageViewOn:self];
    shadowImg.hidden = NO;
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

- (void)changeColor:(UIColor *)color withOffsetY:(CGFloat)offsetY {
    
    if (offsetY < 0) {
        
        //下拉时导航栏隐藏
        self.hidden = YES;
    }else {
        
        self.hidden = NO;
        //计算透明度
        CGFloat alpha = offsetY / 180 > 1.0f ? 1 : (offsetY / 180);
        
        //设置一个颜色并转化为图片
        UIImage *image = [self imageWithColor:[color colorWithAlphaComponent:alpha]];
        [self setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        
        self.translucent = alpha >= 1.0f ? NO : YES;
    }
}

//寻找导航栏下的横线
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
    //创建1像素区域并开始图片绘图
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    
    //创建画板并填充颜色和区域
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    //从画板上获取图片并关闭图片绘图
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
