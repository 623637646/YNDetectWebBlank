//
//  YNDemoWebTimeOutViewController.m
//  YNDetectWebBlankDemo
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "YNDemoWebTimeOutViewController.h"
#import "YNDemoServerConfig.h"

@implementation YNDemoWebTimeOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWithURLString:[NSString stringWithFormat:@"%@/timeOut", [YNDemoServerConfig sharedInstance].serverURL]];
}

@end
