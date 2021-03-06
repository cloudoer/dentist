//
//  LoginTableViewController.m
//  dentist
//
//  Created by xiaoyuan wang on 4/8/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "LoginTableViewController.h"
#import "AppDelegate.h"
#import "NSUtil.h"

@interface LoginTableViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *jidTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;

@end

@implementation LoginTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xmppLoginSuccess:) name:kXMPPLoginSuccess object:nil];
    
    NSString *myJID = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPjoyJID];
	NSString *myPassword = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPjoyPassword];

    if (myJID)
        self.jidTextField.text = [myJID componentsSeparatedByString:@"@"][0];
    if (myPassword)
        self.pwdTextField.text = myPassword;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kXMPPLoginSuccess object:nil];
}

- (void)xmppLoginSuccess:(NSNotification *)aNotification
{

    NSLog(@"%@", URL_PATH_USER_INFO([self appDelegate].xmppStream.myJID.user));
    [Network httpGetPath:URL_PATH_USER_INFO([self appDelegate].xmppStream.myJID.user) success:^(NSDictionary *response) {
        if ([Network statusOKInResponse:response]) {
            
            [LoginFacade loginSuccessWithHttpgetPath:response[@"data"]];
            
        } else
            [Tools showAlertViewWithText:response[@"data"][@"info"]];
    } failure:^(NSError *error) {
        
    }];
    
    AppDelegate *appDelegate             = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UITabBarController *tabBarController = (UITabBarController *)appDelegate.window.rootViewController;
    tabBarController.selectedIndex       = 0;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DEFAULT_NAVIGATION_BAR_TINT_COLOR
    DEFAULT_NAVIGATION_TINT_COLOR
}

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)setField:(NSString *)value forKey:(NSString *)key
{
    if (value != nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.;
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    
    [[self appDelegate] disconnect];
    
    NSString *jidStr = [self.jidTextField.text stringByAppendingString:[NSString stringWithFormat:@"@%@", XMPP_DOMAIN]];
    NSString *pwdStr = self.pwdTextField.text;
    
    [self setField:jidStr forKey:kXMPPjoyJID];
    [self setField:pwdStr forKey:kXMPPjoyPassword];
    
    [[self appDelegate] connect];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
