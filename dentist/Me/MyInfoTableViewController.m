//
//  MyInfoTableViewController.m
//  dentist
//
//  Created by xiaoyuan wang on 4/30/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "MyInfoTableViewController.h"

@interface MyInfoTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *realnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobTitleLabel;

@end

@implementation MyInfoTableViewController

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
    
    Userinfo *userinfo  = [LoginFacade sharedUserinfo];
    
    self.avatarImageView.image = [Tools imageFromBase64Str:userinfo.photo];
    self.realnameLabel.text = userinfo.realname;
    self.phoneLabel.text = userinfo.phone;
    if (userinfo.gender == GENDER_MALE) {
        self.genderImageView.image = [UIImage imageNamed:@"gender_male.png"];
    }
    self.unitLabel.text = userinfo.brand;
    self.jobTitleLabel.text = userinfo.jobTitle;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exitLogin:(UIButton *)sender {
    
    [LoginFacade removeUserinfo];
    [LoginFacade presentLoginViewControllerFrom:self];
}

@end
