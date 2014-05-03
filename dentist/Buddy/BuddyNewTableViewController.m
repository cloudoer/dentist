//
//  BuddyNewTableViewController.m
//  dentist
//
//  Created by xiaoyuan wang on 5/3/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "BuddyNewTableViewController.h"
#import "BuddyRequest.h"
#import "BuddyNewCell.h"
#import "AppDelegate.h"

@interface BuddyNewTableViewController ()

@end

@implementation BuddyNewTableViewController
{
    NSMutableArray *requests;
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
    
    requests = [[NSMutableArray alloc] initWithCapacity:20];
    
    [self fetchTheBuddyRequest];
}

- (void)fetchTheBuddyRequest
{
    NSArray *cdBuddyRequests = [[BuddyManager sharedBuddyManager] buddyRequestsArray];
    if (cdBuddyRequests == nil || cdBuddyRequests.count == 0) {
        
    }else {
        int cnt = 0;
        for (BuddyRequest *oneRequest in cdBuddyRequests) {
            if (oneRequest.fromMe.boolValue == NO) {
                cnt++;
            }
        }
        
        int ind = 0;
        for (BuddyRequest *oneRequest in cdBuddyRequests) {
            if (oneRequest.fromMe.boolValue == NO) {
                ind++;
                [Network httpGetPath:URL_PATH_USER_INFO(oneRequest.user) success:^(NSDictionary *response) {
                    if ([Network statusOKInResponse:response]) {
                        
                        Userinfo *oneUser = [Userinfo userinfoFromHttpget:response[@"data"]];
                        [requests addObject:oneUser];
                        
                        if (ind == cnt) {
                            [self.tableView reloadData];
                        }
                    }
                        
                } failure:^(NSError *error) {
                    
                }];
            }
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requests.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuddyNewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuddyNewCell" forIndexPath:indexPath];
    
    Userinfo *oneUser = requests[indexPath.row];
    cell.avatarImageView.image = [Tools imageFromBase64Str:oneUser.photo];
    cell.nameLabel.text = oneUser.realname;
    cell.phoneLabel.text = oneUser.phone;
    cell.acceptButton.tag = indexPath.row;
    
    return cell;
}


- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


- (IBAction)acceptedTheBuddyRequest:(UIButton *)sender {
    Userinfo *oneUser = requests[sender.tag];
    NSString *jidStr = [NSString stringWithFormat:@"%@@%@", oneUser.phone, XMPP_DOMAIN];
    XMPPJID *jid = [XMPPJID jidWithString:jidStr];
    [[self appDelegate].xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
    
    [[BuddyManager sharedBuddyManager] buddyRequestAddedFromMe:YES Friend:oneUser.phone success:YES];
    
    sender.enabled = NO;
    
    [Tools showAlertViewWithText:@"请求已接受!"];
}

@end
