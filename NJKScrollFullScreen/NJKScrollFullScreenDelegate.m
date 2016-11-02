//
//  QQLNJKScrollFullScreenDelegate.m
//  QQLiveBroadcast
//
//  Created by arvintan on 2016/10/27.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "NJKScrollFullScreenDelegate.h"
#import "UIViewController+NJKFullScreenSupport.h"

@interface NJKScrollFullScreenDelegate()

@property (weak, nonatomic) UIViewController *viewController;

@end

@implementation NJKScrollFullScreenDelegate

- (instancetype)initWithViewController:(UIViewController *)viewController {
  if (self = [super init]) {
    self.viewController = viewController;
  }
  
  return self;
}

#pragma mark -
#pragma mark NJKScrollFullScreenDelegate

- (void)scrollFullScreen:(NJKScrollFullScreen *)proxy scrollViewDidScrollUp:(CGFloat)deltaY {
  if (self.userInteractive) {
    if (proxy.hideComponent & ScrollToHideComponentNavigationBar) {
      [self.viewController moveNavigationBar:deltaY animated:YES];
    }
    if (proxy.hideComponent & ScrollToHideComponentTabBar) {
      [self.viewController moveTabBar:-deltaY animated:YES];
    }
    if (proxy.hideComponent & ScrollToHideComponentToolBar) {
      [self.viewController moveToolbar:-deltaY animated:YES];
    }
  }
}

- (void)scrollFullScreen:(NJKScrollFullScreen *)proxy scrollViewDidScrollDown:(CGFloat)deltaY {
  if (self.userInteractive) {
    if (proxy.hideComponent & ScrollToHideComponentNavigationBar) {
      [self.viewController moveNavigationBar:deltaY animated:YES];
    }
    if (proxy.hideComponent & ScrollToHideComponentTabBar) {
      [self.viewController moveToolbar:-deltaY animated:YES];
    }
    if (proxy.hideComponent & ScrollToHideComponentToolBar) {
      [self.viewController moveTabBar:-deltaY animated:YES];
    }
  }
}

- (void)scrollFullScreenScrollViewDidEndDraggingScrollUp:(NJKScrollFullScreen *)proxy {
  if (proxy.hideComponent & ScrollToHideComponentNavigationBar) {
    [self.viewController hideNavigationBar:YES];
  }
  if (proxy.hideComponent & ScrollToHideComponentTabBar) {
    [self.viewController hideTabBar:YES];
  }
  if (proxy.hideComponent & ScrollToHideComponentToolBar) {
    [self.viewController hideToolbar:YES];
  }
}

- (void)scrollFullScreenScrollViewDidEndDraggingScrollDown:(NJKScrollFullScreen *)proxy {
  if (proxy.hideComponent & ScrollToHideComponentNavigationBar) {
    [self.viewController showNavigationBar:YES];
  }
  if (proxy.hideComponent & ScrollToHideComponentTabBar) {
    [self.viewController showTabBar:YES];
  }
  if (proxy.hideComponent & ScrollToHideComponentToolBar) {
    [self.viewController showToolbar:YES];
  }
}

- (void)scrollFullScreenScrollViewDidReset:(NJKScrollFullScreen *)proxy {
  if (proxy.hideComponent & ScrollToHideComponentNavigationBar) {
    [self.viewController showNavigationBar:NO];
  }
  if (proxy.hideComponent & ScrollToHideComponentTabBar) {
    [self.viewController showTabBar:NO];
  }
  if (proxy.hideComponent & ScrollToHideComponentToolBar) {
    [self.viewController showToolbar:NO];
  }
}

@end
