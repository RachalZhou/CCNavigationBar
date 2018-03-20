# ScrollChangeColorNav
iOS scroll to change the color of navigation.

很多App首页会遇到要做成类似于天猫和京东的导航栏，实现在页面滑动过程中导航栏渐变的效果。之前在项目里用过一个第三方，是采用runtime实现的，后来更新版本后失效了，于是决定结合自己对导航栏的认识来实现一下这个功能。

【文末附运行效果及demo】
## 一、思考与原理
#### 如何给导航栏设置颜色？

```
//方法一
self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
//方法二
[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"red.png"] forBarMetrics:UIBarMetricsDefault];
```

以上两个方法都可以为导航栏添加颜色，但是方法一的效果并非我们的需求。

![直接设置背景色](https://github.com/RachalZhou/MarkdownPhotos/blob/master/nav_color_test1.png?raw=true)

原因在于UINavigationBar的结构中添加了UIView、UIImageView、UILabel等控件，覆盖了UINavigationBar。而方法二的效果是符合预期的。

![UINavigationBar结构图](https://github.com/RachalZhou/MarkdownPhotos/blob/master/UINavigationBarStructure.png?raw=true)

#### 如何将颜色转换为图片？
直接贴代码并附上注释：

```
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
```

#### 如何在滑动时为导航栏设置背景？
通常展示信息页面都存在滑动视图（UItableview、UIcollectionView等），这就不难想到可以在滑动视图的**scrollViewDidScroll**这个方法里根据滑动视图纵向偏移量来计算颜色的透明度的。核心代码：

```
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //计算透明度，90为随意设置的偏移量临界值
    CGFloat alpha = scrollView.contentOffset.y/90.0f >1.0f ? 1:scrollView.contentOffset.y/90.0f;
    //设置一个颜色并转化为图片
    UIImage *image = [self imageWithColor:[UIColor colorWithRed:0.094 green:0.514 blue:0.192 alpha:alpha]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}
```

## 二、实现
除了以上的问题思考和基本原理，实际实现过程中还有一些需要注意的内容。

#### 导航栏的隐藏与显示
当页面下拉时隐藏导航栏，方法有两个:

```
//方法一：
[self.navigationController setNavigationBarHidden:YES];
//方法二：
self.navigationController.navigationBar.hidden = YES;
```

以上两个方法效果相同，区别在于一个是操作navigationController的属性（navigationBar是navigationController的一个属性），一个是操作navigationBar的属性。

但是，方法一会出现一个bug，就是当页面初始状态时setNavigationBarHidden为YES,也就相当于navigationBar那一刻是不存在的，那么导航栏上的控件也就自然看不到，而且navigationBar的出现和消失会很突兀。

采用方法二效果会好很多，因为navigationBar本身是存在的，只是做了显示和隐藏的操作，过渡也相对顺滑很多。

#### 页面切换的处理
导航栏作为的公共区域，我们可以对它进行自定义，同时也要考虑当前页面的导航栏和其他页面导航栏之间的相互影响。
* 导航栏下面那条线其实是一张图片，叫做**shadowImage**，我在页面加载时对其隐藏，又在页面即将消失时对其做了还原。
* 页面即将呈现时为了防止从其他页面回来其他页面设置的导航栏背景色对本页面造成影响，我在页面即将呈现时对导航栏背景色先做了置空处理。
* 为了保证回到该页面时导航栏的颜色和离开时保持一致，我在页面即将呈现时手动调了一下**scrollViewDidScroll**方法来计算当前应该呈现的颜色。

#### 最后：封装
为了方便使用，封装一个UINavigationBar的类别**UINavigationBar+ChangeColor**。使用方法如下：
* **star**使用前，一般在**viewWillAppear**中调用，隐藏导航栏下的横线，将背景色置空；
* **changeColor:WithScrollView:AndValue:**传入颜色、滑动视图、临界值来实现，一般在**scrollViewDidScroll**中调用；
* **reset**显示导航栏下横线，还原导航栏，一般在**viewWillDisappear**中调用。

![效果展示](https://github.com/RachalZhou/MarkdownPhotos/blob/master/effect.gif?raw=true)

[完整demo](https://github.com/RachalZhou/ScrollChangeColorNav)

## 三、总结
* 由于系统自带的导航栏经常不能满足用户的审美需求，因此在开发中导航栏经常需要自定义，哪怕只是修改背景色。
* 了解导航栏的结构处理起来会更容易。
* 自定义导航栏也要考虑和其他页面的导航栏之间的相互影响。
