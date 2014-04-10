//
//  RoomTableViewController.m
//  dentist
//
//  Created by xiaoyuan wang on 4/8/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "RoomTableViewController.h"
#import "AppDelegate.h"
#import "RoomListCell.h"

@interface RoomTableViewController ()

@end

@implementation RoomTableViewController
{
    
}

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self fetchRoomListPage:0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}



- (void)fetchRoomListPage:(int)page
{
    XMPPJID *myJID = [self appDelegate].xmppStream.myJID;
    NSString *getPath = [NSString stringWithFormat:@"%@&page=%d&uid=%@", URL_PATH_ROOM_LIST, page, myJID.user];
    NSLog(@"%@", getPath);
    
    [Network httpGetPath:getPath success:^(NSDictionary *response) {
        NSLog(@"-- %@", response);
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoomListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomListCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}

@end
