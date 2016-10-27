//
//  NJKScrollFullscreen.h
//
//  Copyright (c) 2014 Satoshi Asano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <libkern/OSAtomic.h>

typedef NS_ENUM(NSInteger, ScrollToHideComponent) {
  ScrollToHideComponentNavigationBar = 1 << 0,
  ScrollToHideComponentTabBar = 1 << 2,
  ScrollToHideComponentToolBar = 1 << 3,
  ScrollToHideComponentAll = ScrollToHideComponentNavigationBar | ScrollToHideComponentTabBar | ScrollToHideComponentToolBar
};

FOUNDATION_EXTERN inline BOOL BitTextScrollToHideComponent(ScrollToHideComponent component, ScrollToHideComponent testComponent);

@protocol NJKScrollFullscreenDelegate;

@interface NJKScrollFullScreen : NSObject<UIScrollViewDelegate, UITableViewDelegate, UIWebViewDelegate>

@property (nonatomic, weak) id<NJKScrollFullscreenDelegate> delegate;

@property (nonatomic) CGFloat upThresholdY; // up distance until fire. default 0 px.
@property (nonatomic) CGFloat downThresholdY; // down distance until fire. default 200 px.
@property (nonatomic) ScrollToHideComponent hideComponent;

- (instancetype)initWithForwardTarget:(id<UIScrollViewDelegate>)forwardTarget;

// Must set the delegate first, then init with this method
- (instancetype)initWithScrollView:(UIScrollView *)scrollView;

- (void)reset;

@end

@protocol NJKScrollFullscreenDelegate <NSObject>
- (void)scrollFullScreen:(NJKScrollFullScreen *)fullScreenProxy scrollViewDidScrollUp:(CGFloat)deltaY;
- (void)scrollFullScreen:(NJKScrollFullScreen *)fullScreenProxy scrollViewDidScrollDown:(CGFloat)deltaY;
- (void)scrollFullScreenScrollViewDidEndDraggingScrollUp:(NJKScrollFullScreen *)fullScreenProxy;
- (void)scrollFullScreenScrollViewDidEndDraggingScrollDown:(NJKScrollFullScreen *)fullScreenProxy;
- (void)scrollFullScreenScrollViewDidReset:(NJKScrollFullScreen *)fullScreenProxy;
@end
