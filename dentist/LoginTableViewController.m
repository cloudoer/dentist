//
//  LoginTableViewController.m
//  dentist
//
//  Created by xiaoyuan wang on 4/8/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "LoginTableViewController.h"
#import "AppDelegate.h"

@interface LoginTableViewController ()
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
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kXMPPLoginSuccess object:nil];
}

- (void)xmppLoginSuccess:(NSNotification *)aNotification
{
    XMPPvCardTempModule *vCardModule = [self appDelegate].xmppvCardTempModule;
    XMPPvCardTemp *vCardTemp = [vCardModule vCardTempForJID:[self appDelegate].xmppStream.myJID.bareJID shouldFetch:YES];
    
    [LoginFacade loginSuccessWithXMPPvCardTemp:vCardTemp];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (IBAction)loginButtonPressed:(UIButton *)sender {
    NSString *jidStr = self.jidTextField.text;
    NSString *pwdStr = self.pwdTextField.text;
    
    [self setField:jidStr forKey:kXMPPjoyJID];
    [self setField:pwdStr forKey:kXMPPjoyPassword];
    
    [[self appDelegate] connect];
//    if ()
//    {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }else {
//        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"登录失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [av show];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
