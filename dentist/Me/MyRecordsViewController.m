//
//  MyRecordsViewController.m
//  dentist
//
//  Created by zhoulong on 14-4-25.
//  Copyright (c) 2014年 1010.am. All rights reserved.
//

#import "MyRecordsViewController.h"
#import "RecordDetailViewController.h"

@interface MyRecordsViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation MyRecordsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[BaseURLString stringByAppendingPathComponent:RELATIVE_URL_MY_RECORDS(@(1))]]]];
    [MBProgressHUD showHUDAddedTo:self.webView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    return cell;
}



/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([[request URL].relativeString hasPrefix:@"http://tijian8.cn/yayibao/index.php?r=app/cases/view"]) {
        UIStoryboard *storyBoard                 = [UIStoryboard storyboardWithName:@"Me" bundle:[NSBundle mainBundle]];
        RecordDetailViewController *recordDetail = [storyBoard instantiateViewControllerWithIdentifier:@"recordDetail"];
        recordDetail.request                     = request;
        [self.navigationController pushViewController:recordDetail animated:YES];
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

@end
