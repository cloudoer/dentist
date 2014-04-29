//
//  RegOneTableViewController.m
//  dentist
//
//  Created by xiaoyuan wang on 4/29/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "RegOneTableViewController.h"
#import "RegTwoTableViewController.h"

@interface RegOneTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *captchTextField;
@property (weak, nonatomic) IBOutlet UITextField *passTextField;

@end

@implementation RegOneTableViewController

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

- (IBAction)nextStepButtonPressed:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"RegOne2Two" sender:self];
    
}



- (IBAction)smsButtonPressed:(UIButton *)sender {
    NSString *phoneStr = self.phoneTextField.text;
    
    if (phoneStr == nil || phoneStr.length <= 0) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"请输入手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    
    NSString *getPath = [NSString stringWithFormat:@"%@&username=%@", URL_PATH_REG_CAPTCHA, phoneStr];
    [Network httpGetPath:getPath success:^(NSDictionary *response) {
        if ([Network statusOKInResponse:response]) {
            [Tools showAlertViewWithText:@"短信已发出"];
        }else {
            [Tools showAlertViewWithText:@"出错"];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"RegOne2Two"]) {
        RegTwoTableViewController *controller = segue.destinationViewController;
        
        controller.phone = self.phoneTextField.text;
        controller.captcha = self.captchTextField.text;
        controller.password = self.passTextField.text;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
