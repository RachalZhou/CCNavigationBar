//
//  UIViewController+CCNav.h
//  ScrollChangeNavColor
//
//  Created by 周日朝 on 2018/11/30.
//  Copyright © 2018 RachalZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (CCNav)

/**
 *  @param color 最终显示颜色
 *  @param scrollView 滑动视图
 */
- (void)changeColor:(UIColor *)color scrolllView:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
