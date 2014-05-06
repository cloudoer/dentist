//
//  IndustryViewController.m
//  dentist
//
//  Created by xiaoyuan wang on 4/24/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "IndustryViewController.h"
#import "IndustryDetailViewController.h"

@interface IndustryViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSURLRequest *request;

@end

@implementation IndustryViewController

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
    DEFAULT_NAVIGATION_BAR_TINT_COLOR
    DEFAULT_NAVIGATION_TINT_COLOR
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[BaseURLString stringByAppendingPathComponent:RELATIVE_URL_NEWS_INDEX(@(1))]]]];
    [MBProgressHUD showHUDAddedTo:self.webView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebView delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    if ([request.URL.relativeString hasPrefix:@"http://tijian8.cn/yayibao/index.php?r=app/news/list"]) {
        self.request = request;
        [self performSegueWithIdentifier:@"news2detail" sender:nil];
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideAllHUDsForView:self.webView animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.webView animated:YES];
    [NSUtil alertNotice:@"提示" withMSG:@"数据请求失败,请稍后重试" cancleButtonTitle:@"确定" otherButtonTitle:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"news2detail"]) {
        IndustryDetailViewController *detail = segue.destinationViewController;
        detail.request = self.request;
    }
}


@end
