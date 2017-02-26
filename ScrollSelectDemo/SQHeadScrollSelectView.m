//
//  SQHeadScrollSelectView.m
//  ScrollSelectDemo
//
//  Created by zhanghaibin on 17/2/24.
//  Copyright © 2017年 zhanghaibin. All rights reserved.
//

#import "SQHeadScrollSelectView.h"
#import "UIView+frameAdjust.h"

@interface UIColor (RandomColor)
+ (UIColor*)randomColor;
@end

@implementation UIColor (RandomColor)

+ (UIColor*)randomColor
{
    CGFloat hue = (arc4random() % 256 / 256.0); //0.0 to 1.0
    CGFloat saturation = (arc4random() % 128 / 256.0) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = (arc4random() % 128 / 256.0) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
@end

@interface NSObject (add)

@end
@implementation NSObject (add)

+ (CGSize)getCGSizeWithString:(NSString*)aString textFont:(UIFont*)aTextFont
{
    CGSize size = CGSizeZero;
    size = [aString sizeWithAttributes:@{ NSFontAttributeName : aTextFont }];
    CGFloat w = ceilf(size.width);
    CGFloat h = size.height;
    size = CGSizeMake(w, h);
    return size;
}
@end

@interface SQHeadScrollSelectView () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray* viewsArray;

@end

@implementation SQHeadScrollSelectView {
    NSMutableArray* buttonArray;
    UIView* buttomLineView;
    UIScrollView* scrollView;
    BOOL _isBuildUI;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        buttonArray = [NSMutableArray array];
        self.selectIndex = 0;
        
        buttomLineView = [[UIView alloc] init];
        buttomLineView.backgroundColor = [UIColor colorWithRed:220.0 / 255.0 green:220.0 / 255.0 blue:220.0 / 255.0 alpha:1.0];
        _showBottomGrayLine = NO;
        [self addSubview:buttomLineView];
        
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        self.backgroundColor = RGB(238, 238, 238);
    }
    return self;
}
- (void)layoutSubviews
{
    [self setup];
    [self setupContentView];
}
- (void)setupContentView
{
    NSUInteger number = [self.delegate numberOfPagers:self];
    if (number > 0) {
        [self.viewsArray removeAllObjects];
        [self.bodyScrollView removeAllSubviews];
        for (int i = 0; i < number; i++) {
            //ScrollView部分
            UIView* view = [self.delegate pagerViewOfPagers:self indexOfPagers:i];
            view.backgroundColor = [UIColor randomColor];
            view.frame = CGRectMake(self.bodyScrollView.width * i, 0, self.bodyScrollView.width, self.bodyScrollView.height);
            [self.viewsArray addObject:view];
            [self.bodyScrollView addSubview:view];
        }
        self.bodyScrollView.contentSize = CGSizeMake(self.width * [self.viewsArray count], 50);
    }
}
- (void)setup
{
    scrollView.width = self.width;
    scrollView.height = self.height;
    
    UIColor* titleColor = RGB(51, 51, 51);
    UIColor* selectColor = RGB(80, 157, 236);
    if (self.items && self.items.count > 0) {
        [scrollView removeAllSubviews];
        [buttonArray removeAllObjects];
        
        CGFloat scrollContentRight = 0;
        for (int i = 0; i < self.items.count; i++) {
            NSString* title = self.items[i];
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            CGSize titleSZ = [NSObject getCGSizeWithString:title textFont:btn.titleLabel.font];
            CGFloat btnWidth = titleSZ.width + 30;
            if (i == 0) {
                btn.frame = CGRectMake(0, 0, btnWidth, self.height);
            }
            else {
                UIButton* lastBtn = buttonArray[i - 1];
                btn.frame = CGRectMake(lastBtn.right, 0, btnWidth, self.height);
            }
            [btn setTitleColor:titleColor forState:UIControlStateNormal];
            [btn setTitleColor:selectColor forState:UIControlStateSelected];
            [btn setTitle:title forState:UIControlStateNormal];
            //            if(i%2 == 1)
            //            btn.backgroundColor = [UIColor greenColor];
            //            else
            //                btn.backgroundColor = [UIColor grayColor];
            [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            [scrollView addSubview:btn];
            [buttonArray addObject:btn];
            if (i == self.selectIndex) {
                btn.selected = YES;
            }
            if (i == _items.count - 1) {
                scrollContentRight = btn.right + 10;
            }
        }
        
        scrollView.contentSize = CGSizeMake(scrollContentRight, self.height);
        if (scrollContentRight <= self.width) {
            scrollView.width = scrollContentRight;
            scrollView.centerX = self.width / 2.0;
        }
    }
    if (self.showBottomGrayLine) {
        buttomLineView.hidden = NO;
        buttomLineView.frame = CGRectMake(0, self.height - 0.5f, self.width, 0.5f);
    }
    else {
        buttomLineView.hidden = YES;
    }
}

- (void)buttonClick:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    UIButton* oldBtn = buttonArray[self.selectIndex];
    oldBtn.selected = NO;
    self.selectIndex = btn.tag;
    btn.selected = YES;
    if (self.selectBlock) {
        self.selectBlock(self.selectIndex);
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    if (_selectIndex == selectIndex) {
        return;
    }
    
    if (!buttonArray || buttonArray.count <= selectIndex) {
        _selectIndex = selectIndex;
        return;
    }
    
    UIButton* btn = buttonArray[selectIndex];
    UIButton* oldBtn = buttonArray[_selectIndex];
    oldBtn.selected = NO;
    btn.selected = YES;
    _selectIndex = selectIndex;
    
    [self updateBtnFrameWith:selectIndex];
    [UIView animateWithDuration:0.25 animations:^{
        _bodyScrollView.contentOffset = CGPointMake(self.width * selectIndex, 0);
        
    }];
}

- (void)updateBtnFrameWith:(NSInteger)index
{
    UIButton* btn = buttonArray[index];
    
    CGFloat contentOffsetX = scrollView.contentOffset.x;

    if (btn.left < scrollView.contentOffset.x) {
        if (index == 0) {
            
            contentOffsetX = btn.left;
        }
        else {
            UIButton* lastBtn = buttonArray[index - 1];
            
            contentOffsetX = btn.left - lastBtn.width / 2;
        }
    }
    
    if (btn.right > scrollView.contentOffset.x + self.width) {
        if (index == buttonArray.count - 1) {
            
            contentOffsetX = btn.right - self.width;
        }
        else {
            UIButton* nextBtn = buttonArray[index + 1];
            
            contentOffsetX = btn.right + nextBtn.width / 2 - self.width;
        }
    }
    
    [UIView animateWithDuration:0.25f animations:^{
        scrollView.contentOffset = CGPointMake(contentOffsetX, 0);
    }];
}

//- (UIColor *)scrollBgColor {
//    if (!_scrollBgColor) {
//        _scrollBgColor = [UIColor whiteColor];
//    }
//    return _scrollBgColor;
//}

- (void)setScrollBgColor:(UIColor*)scrollBgColor
{
    if (_scrollBgColor == scrollBgColor) {
        return;
    }
    _scrollBgColor = scrollBgColor;
    self.backgroundColor = _scrollBgColor;
}
#pragma mark - ScrollView Delegate

/*!
 * @brief 手释放后pager归位后的处理
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scroView
{
    if (scroView == self.bodyScrollView) {
        CGFloat contentOffsetX = self.bodyScrollView.contentOffset.x;
        NSInteger index = contentOffsetX / self.width;
        UIButton* newButton = buttonArray[index];
        [self buttonClick:newButton];
    }
}
/*!
 * @brief 自动停止
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView*)scroView
{
    if (scroView == self.bodyScrollView) {
        CGFloat contentOffsetX = self.bodyScrollView.contentOffset.x;
        NSInteger index = contentOffsetX / self.width;
        UIButton* newButton = buttonArray[index];
        [self buttonClick:newButton];
    }
}

/*!
 * @brief 滑动pager主体
 */
- (UIScrollView*)bodyScrollView
{
    if (!_bodyScrollView) {
        self.bodyScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.bottom, self.width, self.containerView.frame.size.height - self.bottom)];
        _bodyScrollView.delegate = self;
        _bodyScrollView.pagingEnabled = YES;
        _bodyScrollView.userInteractionEnabled = YES;
        _bodyScrollView.bounces = NO;
        _bodyScrollView.showsHorizontalScrollIndicator = NO;
        _bodyScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        [self.containerView addSubview:_bodyScrollView];
    }
    return _bodyScrollView;
}
- (NSMutableArray*)viewsArray
{
    if (!_viewsArray) {
        self.viewsArray = [[NSMutableArray alloc] init];
    }
    return _viewsArray;
}

@end
