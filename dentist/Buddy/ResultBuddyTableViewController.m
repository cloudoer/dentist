//
//  ResultBuddyTableViewController.m
//  dentist
//
//  Created by xiaoyuan wang on 4/28/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "ResultBuddyTableViewController.h"

@interface ResultBuddyTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *realnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *sendOrAddButton;


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

- (IBAction)sendMsgOrAddFriends:(UIButton *)sender {
    
    // check if already friends with each other.
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
