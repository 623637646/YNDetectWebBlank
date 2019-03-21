//
//  YNDemoWKWebBlankViewController.m
//  YNDetectWebBlankDemo
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "YNDemoWKWebBlankViewController.h"
#import "YNDemoServerConfig.h"

@implementation YNDemoWKWebBlankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWithURLString:[NSString stringWithFormat:@"%@/blank", [YNDemoServerConfig sharedInstance].serverURL]];
}

@end
