//
//  RegOneTableViewController.m
//  dentist
//
//  Created by xiaoyuan wang on 4/29/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "RegOneTableViewController.h"
#import "RegTwoTableViewController.h"
#import "NSUtil.h"

#define TOTAL_TIME  300

@interface RegOneTableViewController () <UITextFieldDelegate>
{
    NSTimer *sendTimer;
    int timeDes;
}

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *captchTextField;
@property (weak, nonatomic) IBOutlet UITextField *passTextField;
@property (weak, nonatomic) IBOutlet UITextField *regPwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

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
    self.tableView.tableFooterView = [UIView new];
    timeDes = TOTAL_TIME;
}


- (IBAction)nextStep:(UIBarButtonItem *)sender {
   
//    [self performSegueWithIdentifier:@"RegOne2Two" sender:self];
//    return;
    NSString *msg ;
    if (![self regPhoneNO]) {
        msg = @"请检查手机号";
    } else if (![self regCaptch]) {
        msg = @"请输入验证码";
    } else if (![self regPwd]) {
        msg = @"两次密码不一致";
    }
   
    if (msg) {
        [NSUtil alertNotice:@"错误提示" withMSG:msg cancleButtonTitle:@"确定" otherButtonTitle:nil];
        return;
    }
    
    NSDictionary *params = @{@"username": self.phoneTextField.text,
                             @"captcha": self.captchTextField.text};
    [Network httpPostPath:URL_PATH_VERIFY_CAPTCHA parameters:params success:^(NSDictionary *responseObject) {
        if ([Network statusOKInResponse:responseObject]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"RegOne2Two" sender:self];
                [sendTimer invalidate];
            });
           
        } else {
            [NSUtil alertNotice:@"错误提示" withMSG:responseObject[@"data"][@"info"] cancleButtonTitle:@"确定" otherButtonTitle:nil];
        }
        
    } failure:^(NSError *error) {
        [NSUtil alertNotice:@"错误提示" withMSG:@"请求异常,请稍后重试" cancleButtonTitle:@"确定" otherButtonTitle:nil];
    }];
    
    
}


- (IBAction)smsButtonPressed:(UIButton *)sender {
    
    NSString *phoneStr = self.phoneTextField.text;
    
    if (!phoneStr.length) {
        [NSUtil alertNotice:@"错误提示" withMSG:@"请输入手机号" cancleButtonTitle:@"确定" otherButtonTitle:nil];
        return;
    }
    
    NSString *getPath = [NSString stringWithFormat:@"%@&username=%@", URL_PATH_REG_CAPTCHA, phoneStr];
    [Network httpGetPath:getPath success:^(NSDictionary *response) {
        if ([Network statusOKInResponse:response]) {
            [Tools showAlertViewWithText:@"短信已发出"];
            sender.enabled = NO;
            sendTimer = [NSTimer scheduledTimerWithTimeInterval:1. target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        }else {
            [Tools showAlertViewWithText:@"重复手机号,请换个手机号"];
        }
    } failure:^(NSError *error) {
        [Tools showAlertViewWithText:@"出错"];
    }];
}

- (void)countDown {
    timeDes--;
    if (timeDes == 0) {
        self.sendBtn.enabled = YES;
        [self.sendBtn setTitle:@"重发验证码" forState:UIControlStateNormal];
        timeDes = TOTAL_TIME;
    } else
        [self.sendBtn setTitle:[NSString stringWithFormat:@"重发验证码(%d)", timeDes] forState:UIControlStateNormal];
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

#pragma mark - reg form data
- (BOOL)regPhoneNO {
    NSString *phoneNO = self.phoneTextField.text;
    NSString *regex   = @"^[1][3-8]+\\d{9}";
    NSPredicate *prd  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([prd evaluateWithObject:phoneNO] && [phoneNO length] == 11) {
        return YES;
    }
    return NO;
}

- (BOOL)regPwd {
    NSString *pwd   = self.passTextField.text;
    NSString *rePwd = self.regPwdTextField.text;
    if ([NSUtil trimSpace:pwd].length && [NSUtil trimSpace:rePwd].length && [pwd isEqualToString:rePwd]) {
        return YES;
    }
    return NO;
}

- (BOOL)regCaptch {
    return self.captchTextField.text.length;
}

#pragma mark -
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.phoneTextField) {
        [self.captchTextField becomeFirstResponder];
    } else if (textField == self.captchTextField) {
        [self.passTextField becomeFirstResponder];
    } else if (textField == self.passTextField) {
        [self.regPwdTextField becomeFirstResponder];
    } else if (textField == self.regPwdTextField) {
        [self.regPwdTextField resignFirstResponder];
    }
    return YES;
}
@end
