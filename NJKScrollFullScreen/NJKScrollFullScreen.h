//
//  NJKScrollFullscreen.h
//
//  Copyright (c) 2014 Satoshi Asano. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NJKScrollFullscreenDelegate;

@interface NJKScrollFullScreen : NSObject<UIScrollViewDelegate, UITableViewDelegate, UIWebViewDelegate>

@property (nonatomic, weak) id<NJKScrollFullscreenDelegate> delegate;

@property (nonatomic) CGFloat upThresholdY; // up distance until fire. default 0 px.
@property (nonatomic) CGFloat downThresholdY; // down distance until fire. default 200 px.

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
@end
