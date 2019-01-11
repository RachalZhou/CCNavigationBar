## 介绍

简易的iOS导航栏颜色渐变方案，通过新增category并利用runtime的method swizzling实现两行代码轻松搞定。

简洁的API：

```
/** 默认方法，临界值为200
 *  @param color 最终显示颜色
 *  @param scrollView 滑动视图
 */
- (void)changeColor:(UIColor *)color scrolllView:(UIScrollView *)scrollView;

/** 自定义方法，可设置临界值
 *  @param color 最终显示颜色
 *  @param scrollView 滑动视图
 *  @param value 临界值
 */
- (void)changeColor:(UIColor *)color scrolllView:(UIScrollView *)scrollView criticalValue:(CGFloat)va
```

## 用法

在viewController中导入头文件：``#import "UIViewController+CCNav.h"``

在对应方法中写上一下两行代码：
```
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // 第一行代码：手动触发计算当前导航栏颜色
    [self scrollViewDidScroll:self.tableView];
}
```

```
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 第二行代码：滑动中计算导航栏颜色
    [self changeColor:[UIColor redColor] scrolllView:scrollView];
}
```

原理可参考为之前版本写的文章：[简易的iOS导航栏颜色渐变方案](https://www.jianshu.com/p/10c71cb19b5e)