
//
//  RecordDetailViewController.m
//  dentist
//
//  Created by zhoulong on 14-4-28.
//  Copyright (c) 2014年 1010.am. All rights reserved.
//

#import "RecordDetailViewController.h"

@interface RecordDetailViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation RecordDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.webView loadRequest:self.request];
    [MBProgressHUD showHUDAddedTo:self.webView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideAllHUDsForView:self.webView animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.webView animated:YES];
    [NSUtil alertNotice:@"提示" withMSG:@"数据请求失败,请稍后重试" cancleButtonTitle:@"确定" otherButtonTitle:nil];
}
@end
