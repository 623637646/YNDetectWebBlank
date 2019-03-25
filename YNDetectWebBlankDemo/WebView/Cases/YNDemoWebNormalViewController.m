//
//  YNDemoWebNormalViewController.m
//  YNDetectWebBlankDemo
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "YNDemoWebNormalViewController.h"
#import <WebKit/WebKit.h>
#import "YNDemoServerConfig.h"

@interface YNDemoWebNormalViewController ()

@end

@implementation YNDemoWebNormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWithURLString:[NSString stringWithFormat:@"%@/normal", [YNDemoServerConfig sharedInstance].serverURL]];
}

@end
