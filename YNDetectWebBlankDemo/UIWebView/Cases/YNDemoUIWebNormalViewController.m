//
//  YNDemoUIWebNormalViewController.m
//  YNDetectWebBlankDemo
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "YNDemoUIWebNormalViewController.h"
#import "YNDemoServerConfig.h"

@interface YNDemoUIWebNormalViewController ()

@end

@implementation YNDemoUIWebNormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWithURLString:[NSString stringWithFormat:@"%@/normal", [YNDemoServerConfig sharedInstance].serverURL]];
}

@end
