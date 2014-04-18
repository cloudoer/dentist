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
#import "UIImageView+WebCache.h"
#import "RoomChatViewController.h"

@interface RoomTableViewController ()

@end

@implementation RoomTableViewController
{
    NSMutableArray *roomArray;
    RoomInfo *theRoom;
    
    BOOL isLoading;
    int currentPage;
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
    
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshControlTriggered:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void)refreshControlTriggered:(UIRefreshControl *)sender
{
    [self fetchRoomListPage:0];
}


- (void)fetchRoomListPage:(int)page
{
    
    
    XMPPJID *myJID = [self appDelegate].xmppStream.myJID;
    NSString *getPath = [NSString stringWithFormat:@"%@&page=%d&uid=%@", URL_PATH_ROOM_LIST, page, myJID.user];
    NSLog(@"%@", getPath);
    
    [Network httpGetPath:getPath success:^(NSDictionary *response) {
        if ([Network statusOKInResponse:response]) {
            currentPage = page;
            if (page == 0) {
                roomArray = [[NSMutableArray alloc] initWithCapacity:20];
            }
            for (NSDictionary *oneDict in response[@"data"]) {
                [roomArray addObject:[RoomInfo roomInfoFromDictionary:oneDict]];
            }
            
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }
        isLoading = NO;
    } failure:^(NSError *error) {
        [self.refreshControl endRefreshing];
        isLoading = NO;
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
    cell.commetLabel.hidden = YES;
    
    XMPPvCardTemp *vCardTemp = [Tools xmppVCardTempFromVCardStr:oneInfo.vCardStr];
    Userinfo *curUser = [Userinfo userinfoFromXMPPvCardTemp:vCardTemp];
    // Configure the cell...
    
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:curUser.avatar_url] placeholderImage:[UIImage imageNamed:@"tab_me.png"]];
    
    cell.nameLabel.text = curUser.realname;
    if (curUser.orgName) cell.clinicLabel.text = [NSString stringWithFormat:@"(%@)", curUser.orgName];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    theRoom = roomArray[indexPath.row];
    [self performSegueWithIdentifier:@"Room2BubbleRoomChat" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Room2RoomChat"]) {
        RoomChatTableViewController *controller = segue.destinationViewController;
        controller.oneRoom = theRoom;
    }else if ([segue.identifier isEqualToString:@"Room2BubbleRoomChat"]) {
        RoomChatViewController *controller = segue.destinationViewController;
        controller.oneRoom = theRoom;
    }
}

- (void)loadingMoreRoom
{
    if (isLoading) return;
    
    isLoading = YES;
    [self fetchRoomListPage:currentPage + 1];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        if (scrollView.contentSize.height >= scrollView.frame.size.height && (scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height + 80){
            [self loadingMoreRoom];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}

@end
