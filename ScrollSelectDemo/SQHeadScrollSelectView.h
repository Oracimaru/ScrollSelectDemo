//
//  SQHeadScrollSelectView.h
//  ScrollSelectDemo
//
//  Created by zhanghaibin on 17/2/24.
//  Copyright © 2017年 zhanghaibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SQPagerTabViewDelegate;
@interface SQHeadScrollSelectView : UIView

@property (nonatomic, strong) UIScrollView* bodyScrollView;
@property (nonatomic,strong) UIView *containerView;
@property (nonatomic, weak) id<SQPagerTabViewDelegate> delegate;


@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic ,strong) UIColor *scrollBgColor;
@property (nonatomic ,assign) BOOL showBottomGrayLine; //默认为no
@property (nonatomic, copy) void(^selectBlock)(NSInteger selectIndex);


@end


@protocol SQPagerTabViewDelegate <NSObject>
@required
- (NSUInteger)numberOfPagers:(SQHeadScrollSelectView *)view;

- (UIView *)pagerViewOfPagers:(SQHeadScrollSelectView *)view indexOfPagers:(NSUInteger)number;
@optional

@end
