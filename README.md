# ScrollSelectDemo
页面滑动切换tab    
     调用很简单:    
    _AllViewArray返回view集合,可以是webview,tableview和自定义view.
    items 返回切换tab集合. 
 
    _headSelectView = [[SQHeadScrollSelectView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 44)];
    _headSelectView.items = @[ @"推荐", @"免费试听", @"活动中心"];
    _headSelectView.containerView = self.view;
    _headSelectView.delegate = self;
    _headSelectView.selectBlock = ^(NSInteger selectIndex) {
    };
    - (NSUInteger)numberOfPagers:(SQHeadScrollSelectView*)view
    {
      return [_AllViewArray count];
    }

      - (UIView*)pagerViewOfPagers:(SQHeadScrollSelectView*)view indexOfPagers:(NSUInteger)number
    {
    return _AllViewArray[number];
    }


![mp4](https://github.com/Oracimaru/ScrollSelectDemo/blob/master/ScrollSelectDemo/QQ20170226-132837%402x.png)
![mp4](https://github.com/Oracimaru/ScrollSelectDemo/blob/master/ScrollSelectDemo/QQ20170226-140806%402x.png)
![mp4](https://github.com/Oracimaru/ScrollSelectDemo/blob/master/ScrollSelectDemo/QQ20170226-140821%402x.png)
