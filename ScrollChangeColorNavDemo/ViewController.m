//
//  ViewController.m
//  ScrollChangeNavColor
//
//  Created by ahnwjsb on 2016/11/4.
//  Copyright © 2016年 RachalZhou. All rights reserved.
//

#import "ViewController.h"
#import "UINavigationBar+ChangeColor.h"
#import "SecondViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initBaseUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar start];
    
    //该页面呈现时手动调用计算导航栏此时应当显示的颜色
    [self scrollViewDidScroll:_tableview];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar reset];
}

- (void)initBaseUI {
    //导航栏左按钮
    UIImage *imgLeft = [[UIImage imageNamed:@"btn_nav_scan"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:imgLeft style:UIBarButtonItemStylePlain target:self action:@selector(onLeftNavBtnClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //导航栏右按钮
    UIImage *imgRight = [[UIImage imageNamed:@"btn_nav_message"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:imgRight style:UIBarButtonItemStylePlain target:self action:@selector(onRightNavBtnClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //中间搜索框
    UITextField *tfSearch = [[UITextField alloc] init];
    tfSearch.bounds = CGRectMake(0, 0, kScreenW - 100, 28);
    tfSearch.backgroundColor = [UIColor colorWithRed:0.918 green:0.918 blue:0.918 alpha:0.80];
    tfSearch.placeholder = @"搜索";
    tfSearch.borderStyle = UITextBorderStyleRoundedRect;
    tfSearch.font = [UIFont systemFontOfSize:14];
    self.navigationItem.titleView = tfSearch;
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, -kNavH, kScreenW, kScreenH) style:UITableViewStyleGrouped];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [self.view addSubview:_tableview];
    
    //模拟轮播
    UIView *bannerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 130)];
    bannerView.backgroundColor = [UIColor grayColor];
    _tableview.tableHeaderView = bannerView;
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

/* 滑动过程中做处理 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.navigationController.navigationBar changeColor:[UIColor redColor] withOffsetY:scrollView.contentOffset.y];
}

#pragma mark - NavItem
- (void)onLeftNavBtnClick {
    SecondViewController *vc = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onRightNavBtnClick {
    
}

@end
