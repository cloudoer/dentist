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
#import "RoomInfo.h"
#import "RoomChatTableViewController.h"

@interface RoomTableViewController ()

@end

@implementation RoomTableViewController
{
    NSMutableArray *roomArray;
    RoomInfo *theRoom;
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
    
    if (![LoginFacade isLogged]) {
        [self performSegueWithIdentifier:@"Room2Login" sender:self];
    }else {
        [[self appDelegate] connect];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchRoomListPage:0];
}



- (void)fetchRoomListPage:(int)page
{
    
    
    XMPPJID *myJID = [self appDelegate].xmppStream.myJID;
    NSString *getPath = [NSString stringWithFormat:@"%@&page=%d&uid=%@", URL_PATH_ROOM_LIST, page, myJID.user];
    NSLog(@"%@", getPath);
    
    [Network httpGetPath:getPath success:^(NSDictionary *response) {
        if ([Network statusOKInResponse:response]) {
            if (page == 0) {
                roomArray = [[NSMutableArray alloc] initWithCapacity:20];
            }
            for (NSDictionary *oneDict in response[@"data"]) {
                [roomArray addObject:[RoomInfo roomInfoFromDictionary:oneDict]];
            }
            
            [self.tableView reloadData];
        }
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
    if (roomArray == nil) {
        return 0;
    }
    // Return the number of rows in the section.
    return roomArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoomListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomListCell" forIndexPath:indexPath];
    
    RoomInfo *oneInfo = roomArray[indexPath.row];
    cell.theTitleLabel.text = oneInfo.naturalName;
    cell.contentLabel.text = oneInfo.description;
    cell.dateLabel.text = oneInfo.creationDate;
    cell.favoriateImageView.hidden = !oneInfo.isCollection;
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    theRoom = roomArray[indexPath.row];
    [self performSegueWithIdentifier:@"Room2RoomChat" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Room2RoomChat"]) {
        RoomChatTableViewController *controller = segue.destinationViewController;
        controller.oneRoom = theRoom;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}

@end
