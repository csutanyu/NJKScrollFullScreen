//
//  NJKScrollFullScreenDelegate.h
//  QQLiveBroadcast
//
//  Created by arvintan on 2016/10/27.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKScrollFullScreen.h"

@interface NJKScrollFullScreenDelegate : NSObject <NJKScrollFullscreenDelegate>
@property (strong, nonatomic) NJKScrollFullScreen *scrollProxy;

- (instancetype)initWithViewController:(UIViewController *)viewController;

@end
