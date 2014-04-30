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
    
    [Network httpGetPath:URL_PATH_USER_INFO(textField.text) success:^(NSDictionary *response) {
        
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
