//
//  AddBuddyTableViewController.m
//  dentist
//
//  Created by xiaoyuan wang on 4/28/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "AddBuddyTableViewController.h"
#import "Buddy.h"
#import "ResultBuddyTableViewController.h"

@interface AddBuddyTableViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@end

@implementation AddBuddyTableViewController
{
    Userinfo *searchedUser;
}

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


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    NSString *phoneNum = textField.text;
    
    Userinfo *userinfo = [LoginFacade sharedUserinfo];
    if ([phoneNum isEqualToString:userinfo.phone]) {
        [Tools showAlertViewWithText:@"不能添加自己为好友!"];
        return YES;
    }
    
    if ([[BuddyManager sharedBuddyManager] buddyWithPhoneNum:phoneNum]) {
        [Tools showAlertViewWithText:@"该用户已经是你的好友!"];
        return YES;
    }
    
    [Network httpGetPath:URL_PATH_USER_INFO(phoneNum) success:^(NSDictionary *response) {
        
        if ([Network statusOKInResponse:response]) {
            
            NSDictionary *oneBuddy = response[@"data"];
            
            searchedUser = [Userinfo userinfoFromHttpget:oneBuddy];
            
            [self performSegueWithIdentifier:@"search2result" sender:self];
        }else {
            [Tools showAlertViewWithText:@"搜索用户不存在!"];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
    
    
    return YES;
}
- (IBAction)findByPhone:(id)sender {
    [self.phoneTextField resignFirstResponder];
    
    NSString *phoneNum = self.phoneTextField.text;
    
    Userinfo *userinfo = [LoginFacade sharedUserinfo];
    if ([phoneNum isEqualToString:userinfo.phone]) {
        [Tools showAlertViewWithText:@"不能添加自己为好友!"];
        return;
    }
    
    if ([[BuddyManager sharedBuddyManager] buddyWithPhoneNum:phoneNum]) {
        [Tools showAlertViewWithText:@"该用户已经是你的好友!"];
        return;
    }
    
    [Network httpGetPath:URL_PATH_USER_INFO(phoneNum) success:^(NSDictionary *response) {
        
        if ([Network statusOKInResponse:response]) {
            
            NSDictionary *oneBuddy = response[@"data"];
            
            searchedUser = [Userinfo userinfoFromHttpget:oneBuddy];
            
            [self performSegueWithIdentifier:@"search2result" sender:self];
        }else {
            [Tools showAlertViewWithText:@"搜索用户不存在!"];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"search2result"]) {
        ResultBuddyTableViewController *controller = segue.destinationViewController;
        controller.searchUser = searchedUser;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
