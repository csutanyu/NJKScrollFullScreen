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

- (instancetype)initWithViewController:(UIViewController *)viewController hideStatusBar:(BOOL)hideStatusBar{
  if (self = [super init]) {
    _viewController = viewController;
    _hideStatusBar = hideStatusBar;
    _viewController.hideStatusBar = _hideStatusBar;
  }
  
  return self;
}

- (void)setHideStatusBar:(BOOL)hideStatusBar {
  _hideStatusBar = hideStatusBar;
  _viewController.hideStatusBar = _hideStatusBar;
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
  CGRect frame = self.viewController.navigationController.navigationBar.frame;
  if (frame.origin.y < frame.size.height/2) {
    [self hideAll:proxy animated:YES];
  } else {
    [self showAll:proxy animated:YES];
  }
}

- (void)scrollFullScreenScrollViewDidEndDraggingScrollDown:(NJKScrollFullScreen *)proxy {
  CGRect frame = self.viewController.navigationController.navigationBar.frame;
  if (frame.origin.y < -frame.size.height/2) {
    [self hideAll:proxy animated:YES];
  } else {
    [self showAll:proxy animated:YES];
  }
}

- (void)scrollFullScreenScrollViewDidEndDraggingScrollNoneDirection:(NJKScrollFullScreen *)proxy {
  CGRect frame = self.viewController.navigationController.navigationBar.frame;
  if (frame.origin.y < -frame.size.height/2) {
    [self hideAll:proxy animated:YES];
  } else {
    [self showAll:proxy animated:YES];
  }
}

- (void)showAll:(NJKScrollFullScreen *)proxy animated:(BOOL)animated {
  if (proxy.hideComponent & ScrollToHideComponentNavigationBar) {
    [self.viewController showNavigationBar:animated];
  }
  if (proxy.hideComponent & ScrollToHideComponentTabBar) {
    [self.viewController showTabBar:animated];
  }
  if (proxy.hideComponent & ScrollToHideComponentToolBar) {
    [self.viewController showToolbar:animated];
  }
}

- (void)hideAll:(NJKScrollFullScreen *)proxy animated:(BOOL)animated {
  if (proxy.hideComponent & ScrollToHideComponentNavigationBar) {
    [self.viewController hideNavigationBar:animated];
  }
  if (proxy.hideComponent & ScrollToHideComponentTabBar) {
    [self.viewController hideTabBar:animated];
  }
  if (proxy.hideComponent & ScrollToHideComponentToolBar) {
    [self.viewController hideToolbar:animated];
  }
}

- (void)scrollFullScreenScrollViewDidReset:(NJKScrollFullScreen *)proxy {
  [self showAll:proxy animated:NO];
}

@end
