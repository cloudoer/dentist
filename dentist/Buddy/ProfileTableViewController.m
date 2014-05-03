//
//  ProfileTableViewController.m
//  dentist
//
//  Created by xiaoyuan wang on 4/30/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "AppDelegate.h"
#import "MsgDetailViewController.h"

@interface ProfileTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *realnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobTitleLabel;

@end

@implementation ProfileTableViewController

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
    
    self.avatarImageView.image = [Tools imageFromBase64Str:self.buddy.photoStr];
    self.realnameLabel.text = self.buddy.realname;
    self.phoneLabel.text = self.buddy.phone;
    if ([self.buddy.gender isEqualToString:@"男"]) {
        self.genderImageView.image = [UIImage imageNamed:@"gender_male.png"];
    }
    self.unitLabel.text = self.buddy.brand;
    self.jobTitleLabel.text = self.buddy.jobTitle;
    
}


- (IBAction)talkButtonPressed:(UIButton *)sender {
    NSLog(@"talkButtonPressed..");
    [self.navigationController popViewControllerAnimated:NO];
    
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UITabBarController *tabBarController = (UITabBarController *)appDelegate.window.rootViewController;
    tabBarController.selectedIndex = 0;
    
    NSString *barJIDStr = [NSString stringWithFormat:@"%@@%@", self.buddy.phone, XMPP_DOMAIN];
    [Tools setBareJIDStringFromBuddyClicked:barJIDStr];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
