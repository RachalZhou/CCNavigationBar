//
//  ViewController.m
//  ScrollChangeNavColor
//
//  Created by ahnwjsb on 2016/11/4.
//  Copyright © 2016年 RachalZhou. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+CCNav.h"
#import "SecondViewController.h"

#define kScreenW CGRectGetWidth([UIScreen mainScreen].bounds)
#define kScreenH CGRectGetHeight([UIScreen mainScreen].bounds)

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self layoutUI];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // 第一行代码：手动触发计算当前导航栏颜色
    [self scrollViewDidScroll:self.tableView];
}

- (void)layoutUI {
    
    // 导航栏左按钮
    UIImage *imgLeft = [[UIImage imageNamed:@"btn_nav_scan"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:imgLeft style:UIBarButtonItemStylePlain target:self action:@selector(onLeftNavBtnClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    // 导航栏右按钮
    UIImage *imgRight = [[UIImage imageNamed:@"btn_nav_message"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:imgRight style:UIBarButtonItemStylePlain target:self action:@selector(onRightNavBtnClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // 中间搜索框
    UITextField *tfSearch = [[UITextField alloc] init];
    tfSearch.bounds = CGRectMake(0, 0, kScreenW - 100, 28);
    tfSearch.backgroundColor = [UIColor colorWithRed:0.918 green:0.918 blue:0.918 alpha:0.80];
    tfSearch.placeholder = @"搜索";
    tfSearch.borderStyle = UITextBorderStyleRoundedRect;
    tfSearch.font = [UIFont systemFontOfSize:14];
    self.navigationItem.titleView = tfSearch;
    
    // 模拟轮播
    UIView *bannerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 130)];
    bannerView.backgroundColor = [UIColor grayColor];
    self.tableView.tableHeaderView = bannerView;
}

#pragma mark - Tableview Datasource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuse = @"reuseCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 第二行代码：滑动中计算导航栏颜色
    [self changeColor:[UIColor redColor] scrolllView:scrollView];
}

#pragma mark - Action
- (void)onLeftNavBtnClick {
    SecondViewController *vc = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onRightNavBtnClick {
    
}

#pragma mark - lazyLoad
- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
