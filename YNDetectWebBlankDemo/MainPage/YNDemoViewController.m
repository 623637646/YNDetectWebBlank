//
//  YNDemoViewController.m
//  YNExposureDemo
//
//  Created by Wang Ya on 24/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "YNDemoViewController.h"
#import "YNDemoWebViewController.h"
#import "YNDemoServerConfig.h"
#import "NSString+YNDemo.h"

@interface YNDemoViewController()<UITextFieldDelegate>
@property (nonatomic, weak) UIButton *IPButton;

// alert
@property (nonatomic, weak) UITextField *alertTextField;
@property (nonatomic, weak) UIAlertAction *alertConfirmAction;
@end

@implementation YNDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"YNDetectWebBlank Demo";
    self.dataSource = @[
                        [YNDemoListDataSourceItem itemWithTitle:@"UIWebView Demos" obj:({
                            YNDemoWebViewController *vc = [[YNDemoWebViewController alloc] initWithType:YNDemoWebViewControllerTypeUI];
                            vc;
                        })],
                        [YNDemoListDataSourceItem itemWithTitle:@"WKWebView Demos" obj:({
                            YNDemoWebViewController *vc = [[YNDemoWebViewController alloc] initWithType:YNDemoWebViewControllerTypeWK];
                            vc;
                        })],
                        ];
    [self setUpIPButton];
}

- (void)setUpIPButton
{
    if (!self.IPButton) {
        UIButton *IPButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44)];
        [IPButton setBackgroundColor:[UIColor whiteColor]];
        [IPButton addTarget:self action:@selector(didTapIPButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:IPButton];
        self.IPButton = IPButton;
    }
    NSString *IP = [YNDemoServerConfig sharedInstance].IP;
    [self.IPButton setTitleColor:IP ? [UIColor greenColor] : [UIColor redColor] forState:UIControlStateNormal];
    [self.IPButton setTitle:IP ? [NSString stringWithFormat:@"Server IP:%@", IP] : @"Unknown server IP" forState:UIControlStateNormal];
}

#pragma mark - Actions

- (void)didTapIPButton
{
    [self updateIP];
}

- (void)didSelectItem:(YNDemoListDataSourceItem *)item
{
    NSString *IP = [YNDemoServerConfig sharedInstance].IP;
    if (!IP) {
        [self updateIP];
        return;
    }
    [self.navigationController pushViewController:item.obj animated:YES];
}

#pragma mark - utilities

- (void)updateIP
{
    NSString *IP = [YNDemoServerConfig sharedInstance].IP;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Config Server IP" message:IP ? [NSString stringWithFormat:@"Original IP is:%@", IP] : @"Please input server IP" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) wself = self;
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        __strong typeof(self) self = wself;
        self.alertTextField = textField;
        textField.delegate = self;
        textField.text = IP;
    }];
    [alert addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        action;
    })];
    [alert addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            __strong typeof(self) self = wself;
            NSString *input = self.alertTextField.text;
            [YNDemoServerConfig sharedInstance].IP = input;
            [self setUpIPButton];
        }];
        action.enabled = [self.alertTextField.text yndemo_isValidIPAddress];
        self.alertConfirmAction = action;
        action;
    })];
    [alert addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            __strong typeof(self) self = wself;
            [YNDemoServerConfig sharedInstance].IP = nil;
            [self setUpIPButton];
        }];
        action;
    })];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.alertConfirmAction.enabled = [newString yndemo_isValidIPAddress];
    return YES;
}


@end
