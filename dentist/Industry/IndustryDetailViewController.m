//
//  IndustryDetailViewController.m
//  dentist
//
//  Created by zhoulong on 14-5-6.
//  Copyright (c) 2014年 1010.am. All rights reserved.
//

#import "IndustryDetailViewController.h"

@interface IndustryDetailViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation IndustryDetailViewController

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
	// Do any additional setup after loading the view.
    
     [MBProgressHUD showHUDAddedTo:self.webView animated:YES];
    [self.webView loadRequest:self.request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIToolbar action
- (IBAction)goback:(UIBarButtonItem *)sender {
    [self.webView goBack];
}

- (IBAction)goforawrd:(UIBarButtonItem *)sender {
    [self.webView goForward];
}

- (IBAction)gorefresh:(UIBarButtonItem *)sender {
    [self.webView reload];
}

#pragma mark - UIWebView delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideAllHUDsForView:self.webView animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.webView animated:YES];
    [NSUtil alertNotice:@"提示" withMSG:@"数据请求失败,请稍后重试" cancleButtonTitle:@"确定" otherButtonTitle:nil];
}

@end
