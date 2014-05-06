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

#define AV_TAG_DELETE_BUDDY 10234
#define AV_TAG_DELETE_DONE 23943

@interface ProfileTableViewController () <UIAlertViewDelegate>
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

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.buddy isKindOfClass:[Userinfo class]]) {
        Userinfo *userinfo = (Userinfo *)self.buddy;
        self.avatarImageView.image = [Tools imageFromBase64Str:userinfo.photo];
        
        if (userinfo.gender == 1) {
            self.genderImageView.image = [UIImage imageNamed:@"gender_male.png"];
        }
    } else {
        self.avatarImageView.image = [Tools imageFromBase64Str:self.buddy.photoStr];
        
        if ([self.buddy.gender isEqualToString:@"男"]) {
            self.genderImageView.image = [UIImage imageNamed:@"gender_male.png"];
        }
    }

    self.realnameLabel.text = self.buddy.realname;
    self.phoneLabel.text = self.buddy.phone;

    self.unitLabel.text = self.buddy.brand;
    self.jobTitleLabel.text = self.buddy.jobTitle;
    
    if (self.type == PROFILE_BACK_TYPE_NORMAL) {
        
    }else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}


- (IBAction)talkButtonPressed:(UIButton *)sender {
    NSLog(@"talkButtonPressed..");
    if (self.type == PROFILE_BACK_TYPE_NORMAL) {
        [self.navigationController popViewControllerAnimated:NO];
        
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        UITabBarController *tabBarController = (UITabBarController *)appDelegate.window.rootViewController;
        tabBarController.selectedIndex = 0;
        
        NSString *barJIDStr = [NSString stringWithFormat:@"%@@%@", self.buddy.phone, XMPP_DOMAIN];
        [Tools setBareJIDStringFromBuddyClicked:barJIDStr];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (IBAction)deleteBuddy:(UIBarButtonItem *)sender {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"确定删除好友?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    av.tag = AV_TAG_DELETE_BUDDY;
    [av show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == AV_TAG_DELETE_BUDDY && buttonIndex == 0) {
        NSString *jidStr = [NSString stringWithFormat:@"%@@%@", self.buddy.phone, XMPP_DOMAIN];
        XMPPJID *jid = [XMPPJID jidWithString:jidStr];
        [[self appDelegate].xmppRoster removeUser:jid];
        [[BuddyManager sharedBuddyManager] removeBuddy:self.buddy];
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"删除请求已发出." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        av.tag = AV_TAG_DELETE_DONE;
        [av show];
    }else if (alertView.tag == AV_TAG_DELETE_DONE) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
