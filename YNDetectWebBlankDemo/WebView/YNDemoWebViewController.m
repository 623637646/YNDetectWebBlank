//
//  YNDemoWebViewController.m
//  YNDetectWebBlankDemo
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "YNDemoWebViewController.h"
#import "YNDemoWebNormalViewController.h"
#import "YNDemoWebBlankViewController.h"
#import "YNDemoWebTimeOutViewController.h"
#import "YNDemoWebBlankWhenBackViewController.h"
#import "YNDemoWebCoveredViewController.h"
#import "YNDemoWebHasSubviewsViewController.h"
#import "YNDemoWebComplexViewController.h"
#import "YNDemoBaseWebViewController.h"

@interface YNDemoWebViewController ()

@property (nonatomic, assign) YNDemoWebViewControllerType type;

@end

@implementation YNDemoWebViewController

- (instancetype)initWithType:(YNDemoWebViewControllerType)type
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.type = type;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithType:YNDemoWebViewControllerTypeWK];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithType:YNDemoWebViewControllerTypeWK];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataSource = @[
                        [YNDemoListDataSourceItem itemWithTitle:@"Normal" obj:YNDemoWebNormalViewController.class],
                        [YNDemoListDataSourceItem itemWithTitle:@"Blank" obj:YNDemoWebBlankViewController.class],
                        [YNDemoListDataSourceItem itemWithTitle:@"TimeOut" obj:YNDemoWebTimeOutViewController.class],
                        [YNDemoListDataSourceItem itemWithTitle:@"Blank when back" obj:YNDemoWebBlankWhenBackViewController.class],
                        [YNDemoListDataSourceItem itemWithTitle:@"Blank when Covered by other views" obj:YNDemoWebCoveredViewController.class],
                        [YNDemoListDataSourceItem itemWithTitle:@"Blank when has subviews" obj:YNDemoWebHasSubviewsViewController.class],
                        [YNDemoListDataSourceItem itemWithTitle:@"A complex page" obj:YNDemoWebComplexViewController.class]
                        ];
}

- (void)didSelectItem:(YNDemoListDataSourceItem *)item
{
    switch (self.type) {
        case YNDemoWebViewControllerTypeWK:{
            UIViewController *vc = [(YNDemoBaseWebViewController*)[item.obj alloc] initWithType:YNDemoBaseWebViewTypeWK];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case YNDemoWebViewControllerTypeUI:{
            UIViewController *vc = [(YNDemoBaseWebViewController*)[item.obj alloc] initWithType:YNDemoBaseWebViewTypeUI];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}

@end
