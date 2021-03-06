//
//  UIWebView+YNDWBPrivate.h
//  YNDetectWebBlank
//
//  Created by Wang Ya on 27/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Aspects/Aspects.h>
#import "YNDetectWebBlankPrivateDefinition.h"

NS_ASSUME_NONNULL_BEGIN

@interface YNDWBUIWebViewDelegate : NSObject<UIWebViewDelegate>

@property (nonatomic, weak) UIWebView *webView;

@end

@interface UIWebView (YNDWBPrivate)

#pragma mark - project
@property (nonatomic, copy, nullable) YNDWBWebViewIsLoadingUpdateBlock yndwb_loadingStatusUpdatedBlock;
@property (nonatomic, assign) BOOL yndwb_alreadyRequested;

#pragma mark - private
@property (nonatomic, strong, nullable) YNDWBUIWebViewDelegate *yndwb_trueDelegate;
@property (nonatomic, weak, nullable) id<UIWebViewDelegate> yndwb_delegate;
@property (nonatomic, strong, nullable) id<AspectToken> yndwb_delegateToken;
@end

NS_ASSUME_NONNULL_END
