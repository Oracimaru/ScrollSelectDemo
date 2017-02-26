//
//  ViewController.m
//  ScrollSelectDemo
//
//  Created by zhanghaibin on 17/2/24.
//  Copyright © 2017年 zhanghaibin. All rights reserved.
//

#import "SQHeadScrollSelectView.h"
#import "UIView+frameAdjust.h"
#import "ViewController.h"
@interface ViewController () <SQPagerTabViewDelegate> {
    SQHeadScrollSelectView* _headSelectView;
    NSMutableArray* _AllViewArray;
    NSInteger _selectIndex;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _headSelectView = [[SQHeadScrollSelectView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 44)];
    _headSelectView.scrollBgColor = RGB(245, 245, 245);
    _AllViewArray = [NSMutableArray array];
    for (int i = 0; i < 8; i++) {
        UIView* view = [[UIView alloc] init];
        UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(187, 301, 100, 100)];
        lab.tag = 100 + i;
        lab.text = [NSString stringWithFormat:@"page%d", i];
        [view addSubview:lab];
        lab.textColor = [UIColor blackColor];
        [_AllViewArray addObject:view];
    }
    
    NSMutableArray* tabNameArray = [NSMutableArray array];
    [tabNameArray addObject:@"推荐"];
    
    _headSelectView.items = @[ @"推荐", @"免费试听", @"活动中心", @"19备考", @"收费课", @"活动中心", @"19备考", @"收费课" ];
    _headSelectView.containerView = self.view;
    _headSelectView.delegate = self;
    __weak typeof(self) weakSelf = self;
    _headSelectView.selectBlock = ^(NSInteger selectIndex) {
        _selectIndex = selectIndex;
        [weakSelf.view setNeedsLayout];
        [weakSelf.view layoutIfNeeded];
    };
    [self.view addSubview:_headSelectView];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UILabel* lav = (UILabel*)[self.view viewWithTag:100 + _selectIndex];
    lav.center = self.view.center;
}
- (NSUInteger)numberOfPagers:(SQHeadScrollSelectView*)view
{
    return [_AllViewArray count];
}

- (UIView*)pagerViewOfPagers:(SQHeadScrollSelectView*)view indexOfPagers:(NSUInteger)number
{
    return _AllViewArray[number];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
