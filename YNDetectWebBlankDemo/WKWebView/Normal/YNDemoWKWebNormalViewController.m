//
//  YNDemoWKWebNormalViewController.m
//  YNDetectWebBlankDemo
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "YNDemoWKWebNormalViewController.h"
#import <WebKit/WebKit.h>

@interface YNDemoWKWebNormalViewController ()

@end

@implementation YNDemoWKWebNormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWithURLString:@"https://www.google.com"];
}

@end
