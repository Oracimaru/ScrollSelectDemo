//
//  UIView+frameAdjust.h
//  fenbi
//
//  Created by Tang Qiao on 12-5-31.
//  Copyright (c) 2012年 Fenbi.com . All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGB(r, g, b)    [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@interface UIView (frameAdjust)

@property (nonatomic) CGFloat left;


@property (nonatomic) CGFloat top;


@property (nonatomic) CGFloat right;


@property (nonatomic) CGFloat bottom;

@property (nonatomic) CGFloat width;

@property (nonatomic) CGFloat height;


@property (nonatomic) CGFloat centerX;


@property (nonatomic) CGFloat centerY;


@property (nonatomic) CGSize size;
- (void)removeAllSubviews;

@end
