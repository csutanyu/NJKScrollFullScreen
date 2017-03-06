//
//  NJKScrollFullscreen.m
//
//  Copyright (c) 2014 Satoshi Asano. All rights reserved.
//

#import "NJKScrollFullScreen.h"

inline BOOL BitTextScrollToHideComponent(ScrollToHideComponent component, ScrollToHideComponent testComponent) {
  return component & testComponent;
}

typedef NS_ENUM(NSInteger, NJKScrollDirection) {
    NJKScrollDirectionNone,
    NJKScrollDirectionUp,
    NJKScrollDirectionDown,
};

NJKScrollDirection detectScrollDirection(currentOffsetY, previousOffsetY)
{
    return currentOffsetY > previousOffsetY ? NJKScrollDirectionUp   :
           currentOffsetY < previousOffsetY ? NJKScrollDirectionDown :
                                              NJKScrollDirectionNone;
}

@interface NJKScrollFullScreen ()
@property (nonatomic) NJKScrollDirection previousScrollDirection;
@property (nonatomic) CGFloat previousOffsetY;
@property (nonatomic) CGFloat accumulatedY;
@property (nonatomic, weak) id<UIScrollViewDelegate> forwardTarget;
@end

@implementation NJKScrollFullScreen

- (id)initWithForwardTarget:(id)forwardTarget
{
    self = [super init];
    if (self) {
        [self reset];
        _downThresholdY = 200.0;
        _upThresholdY = 0.0;
        _forwardTarget = forwardTarget;
    }
    return self;
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView {
    NSCParameterAssert(scrollView.delegate != nil);
    if (self = [super init]) {
        _downThresholdY = 200.0;
        _upThresholdY = 0.0;
        _forwardTarget = scrollView.delegate;
        scrollView.delegate = self;
    }
    return self;
}

- (void)reset
{
    _previousOffsetY = 0.0;
    _accumulatedY = 0.0;
    _previousScrollDirection = NJKScrollDirectionNone;
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollFullScreenScrollViewDidReset:)]) {
      [self.delegate scrollFullScreenScrollViewDidReset:self];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([_forwardTarget respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [_forwardTarget scrollViewDidScroll:scrollView];
    }
    if (scrollView.contentSize.height + scrollView.contentInset.top + scrollView.contentInset.bottom < scrollView.frame.size.height + scrollView.contentInset.top + 20) { // 内容太小不足以在往下滑动的过程中将导航全部隐藏
        return;
    }
    if (scrollView.contentOffset.y - (-scrollView.contentInset.top) + scrollView.frame.size.height >= scrollView.contentSize.height + scrollView.contentInset.top + scrollView.contentInset.bottom) { // 向下滑动超过内容加inset则忽略
        return;
    }
    
    CGFloat currentOffsetY = scrollView.contentOffset.y;

    NJKScrollDirection currentScrollDirection = detectScrollDirection(currentOffsetY, _previousOffsetY);
    CGFloat topBoundary = -scrollView.contentInset.top;
    CGFloat bottomBoundary = scrollView.contentSize.height + scrollView.contentInset.bottom;

    BOOL isOverTopBoundary = currentOffsetY <= topBoundary;
    BOOL isOverBottomBoundary = currentOffsetY >= bottomBoundary;

    BOOL isBouncing = (isOverTopBoundary && currentScrollDirection != NJKScrollDirectionDown) || (isOverBottomBoundary && currentScrollDirection != NJKScrollDirectionUp);
    if (isBouncing) {
        return;
    }

    CGFloat deltaY = _previousOffsetY - currentOffsetY;
    _accumulatedY += deltaY;

    switch (currentScrollDirection) {
        case NJKScrollDirectionUp:
        {
            BOOL isOverThreshold = _accumulatedY < -_upThresholdY;

            if (isOverThreshold || isOverBottomBoundary)  {
                if ([_delegate respondsToSelector:@selector(scrollFullScreen:scrollViewDidScrollUp:)]) {
                    [_delegate scrollFullScreen:self scrollViewDidScrollUp:deltaY];
                }
            }
        }
            break;
        case NJKScrollDirectionDown:
        {
            BOOL isOverThreshold = _accumulatedY > _downThresholdY;

            if (isOverThreshold || isOverTopBoundary) {
                if ([_delegate respondsToSelector:@selector(scrollFullScreen:scrollViewDidScrollDown:)]) {
                    [_delegate scrollFullScreen:self scrollViewDidScrollDown:deltaY];
                }
            }
        }
            break;
        case NJKScrollDirectionNone:
            break;
    }

    // reset acuumulated y when move opposite direction
    if (!isOverTopBoundary && !isOverBottomBoundary && _previousScrollDirection != currentScrollDirection) {
        _accumulatedY = 0;
    }

    _previousScrollDirection = currentScrollDirection;
    _previousOffsetY = currentOffsetY;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([_forwardTarget respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [_forwardTarget scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }

    CGFloat currentOffsetY = scrollView.contentOffset.y;

    CGFloat topBoundary = -scrollView.contentInset.top;
    CGFloat bottomBoundary = scrollView.contentSize.height + scrollView.contentInset.bottom;

    if (!decelerate && scrollView.contentOffset.y < 0) {
        if ([_delegate respondsToSelector:@selector(showAll:animated:)]) {
            _previousOffsetY = 0.0;
            _accumulatedY = 0.0;
            _previousScrollDirection = NJKScrollDirectionNone;
            [_delegate showAll:self animated:YES];
            return;
        }
    }
    
    switch (_previousScrollDirection) {
        case NJKScrollDirectionUp:
        {
            BOOL isOverThreshold = _accumulatedY < -_upThresholdY;
            BOOL isOverBottomBoundary = currentOffsetY >= bottomBoundary;

            if (!decelerate || isOverThreshold || isOverBottomBoundary) {
                if ([_delegate respondsToSelector:@selector(scrollFullScreenScrollViewDidEndDraggingScrollUp:)]) {
                    [_delegate scrollFullScreenScrollViewDidEndDraggingScrollUp:self];
                }
            }
            break;
        }
        case NJKScrollDirectionDown:
        {
            
            BOOL isOverThreshold = _accumulatedY > _downThresholdY;
            BOOL isOverTopBoundary = currentOffsetY <= topBoundary;

            if (!decelerate || isOverThreshold || isOverTopBoundary) {
                if ([_delegate respondsToSelector:@selector(scrollFullScreenScrollViewDidEndDraggingScrollDown:)]) {
                    [_delegate scrollFullScreenScrollViewDidEndDraggingScrollDown:self];
                }
            }
            break;
        }
        case NJKScrollDirectionNone:
        {
            if ([_delegate respondsToSelector:@selector(scrollFullScreenScrollViewDidEndDraggingScrollNoneDirection:)]) {
                [_delegate scrollFullScreenScrollViewDidEndDraggingScrollNoneDirection:self];
            }
        }
            break;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([_forwardTarget respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [_forwardTarget scrollViewDidEndDecelerating:scrollView];
    }
    
    if (scrollView.contentOffset.y < 0) {
        if ([_delegate respondsToSelector:@selector(showAll:animated:)]) {
            _previousOffsetY = 0.0;
            _accumulatedY = 0.0;
            _previousScrollDirection = NJKScrollDirectionNone;
            [_delegate showAll:self animated:YES];
            return;
        }
    }
    switch (_previousScrollDirection) {
        case NJKScrollDirectionUp:
        {
            if ([_delegate respondsToSelector:@selector(scrollFullScreenScrollViewDidEndDraggingScrollUp:)]) {
                [_delegate scrollFullScreenScrollViewDidEndDraggingScrollUp:self];
            }
            break;
        }
        case NJKScrollDirectionDown:
        {
            if ([_delegate respondsToSelector:@selector(scrollFullScreenScrollViewDidEndDraggingScrollDown:)]) {
                [_delegate scrollFullScreenScrollViewDidEndDraggingScrollDown:self];
            }
            break;
        }
        case NJKScrollDirectionNone:
        {
            if ([_delegate respondsToSelector:@selector(scrollFullScreenScrollViewDidEndDraggingScrollNoneDirection:)]) {
                [_delegate scrollFullScreenScrollViewDidEndDraggingScrollNoneDirection:self];
            }
        }
            break;
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    BOOL ret = YES;
    if ([_forwardTarget respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
        ret = [_forwardTarget scrollViewShouldScrollToTop:scrollView];
    }
    if ([_delegate respondsToSelector:@selector(scrollFullScreenScrollViewDidEndDraggingScrollDown:)]) {
        [_delegate scrollFullScreenScrollViewDidEndDraggingScrollDown:self];
    }
    return ret;
}

#pragma mark -
#pragma mark Method Forwarding

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    if(!signature) {
        if([_forwardTarget respondsToSelector:selector]) {
            return [(id)_forwardTarget methodSignatureForSelector:selector];
        }
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation*)invocation
{
    if ([_forwardTarget respondsToSelector:[invocation selector]]) {
        [invocation invokeWithTarget:_forwardTarget];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    BOOL ret = [super respondsToSelector:aSelector];
    if (!ret) {
        ret = [_forwardTarget respondsToSelector:aSelector];
    }
    return ret;
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol
{
    BOOL ret = [super conformsToProtocol:aProtocol];
    if (!ret) {
        ret = [_forwardTarget conformsToProtocol:aProtocol];
    }
    return ret;
}

@end
