//
//  RegTwoTableViewController.m
//  dentist
//
//  Created by xiaoyuan wang on 4/29/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "RegTwoTableViewController.h"

@interface RegTwoTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *realnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *jobTitleTextField;

@property (weak, nonatomic) IBOutlet UITextField *clinicTextField;

@end

@implementation RegTwoTableViewController

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
    
}
- (IBAction)finishButtonPressed:(UIButton *)sender {
    
    NSString *realname = self.realnameTextField.text;
    NSString *gender = @"1"; // 1 male
    NSString *clinic = self.clinicTextField.text;
    NSString *jobTitle = self.jobTitleTextField.text;
    
    NSDictionary *parameters =
  @{
    @"username" : self.phone,
    @"password" : self.password,
    @"captcha" : self.captcha,
    @"realname" : realname,
    @"sex" : gender,
    @"job_title_id" : jobTitle,
    @"clinic_id" : clinic
    };
    
    
    [Network httpPostPath:URL_PATH_REG_DONE parameters:parameters success:^(NSDictionary *responseObject) {
        if ([Network statusOKInResponse:responseObject]) {
            [Tools showAlertViewWithText:@"注册成功"];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
