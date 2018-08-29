//
//  UINavigationBar+ChangeColor.h
//  ScrollChangeColorNavTest
//
//  Created by Rachal on 2016/11/3.
//  Copyright © 2016年 RachalZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (ChangeColor)

/**
 *  设置导航栏
 */
- (void)start;

/**
 *  还原导航栏
 */
- (void)reset;

/**
 *  @param color 最终显示颜色
 *  @param offsetY 滑动视图水平偏移量
 */
- (void)changeColor:(UIColor *)color withOffsetY:(CGFloat)offsetY;

@end
