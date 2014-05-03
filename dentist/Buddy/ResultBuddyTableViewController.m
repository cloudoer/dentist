//
//  ResultBuddyTableViewController.m
//  dentist
//
//  Created by xiaoyuan wang on 4/28/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "AppDelegate.h"
#import "ResultBuddyTableViewController.h"

@interface ResultBuddyTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *realnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobTitleLabel;


@end

@implementation ResultBuddyTableViewController

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
    
    Userinfo *userinfo  = self.searchUser;
    
    self.avatarImageView.image = [Tools imageFromBase64Str:userinfo.photo];
    self.realnameLabel.text = userinfo.realname;
    self.phoneLabel.text = userinfo.phone;
    if (userinfo.gender == GENDER_MALE) {
        self.genderImageView.image = [UIImage imageNamed:@"gender_male.png"];
    }
    self.unitLabel.text = userinfo.brand;
    self.jobTitleLabel.text = userinfo.jobTitle;
}


- (IBAction)addBuddy:(UIButton *)sender {
    
    NSString *jidStr = [NSString stringWithFormat:@"%@@%@", self.searchUser.phone, XMPP_DOMAIN];
    XMPPJID *jid = [XMPPJID jidWithString:jidStr];
    
    [[self appDelegate].xmppRoster addUser:jid withNickname:self.searchUser.phone];
    [[BuddyManager sharedBuddyManager] buddyRequestAddedFromMe:YES Friend:self.searchUser.phone success:NO];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
