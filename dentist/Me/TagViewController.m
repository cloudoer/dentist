//
//  TagViewController.m
//  dentist
//
//  Created by zhoulong on 14-4-25.
//  Copyright (c) 2014年 1010.am. All rights reserved.
//

#import "TagViewController.h"
#import "NSUtil.h"
#import "AFNetworking.h"

#define RELATIVE_URL_TAG_LIST  @"index.php?r=app/tags/index"

#define TAG_MAX_COUNT 3

@interface TagViewController ()


@property (nonatomic, strong) NSMutableArray *tags;

@end

@implementation TagViewController

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

    if (!self.selecteds) {        
        self.selecteds = [NSMutableArray array];
    }
    
    [self getTagList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tag_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if ([self.selecteds containsObject:indexPath])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (self.tags.count)
        cell.textLabel.text = self.tags[indexPath.row][@"name"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.selecteds removeObject:indexPath];
    } else {
        if (self.selecteds.count >= TAG_MAX_COUNT) {
            [NSUtil alertNotice:@"提示" withMSG:@"最多只能选3个标签" cancleButtonTitle:@"确定" otherButtonTitle:nil];
            return;
        }
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selecteds addObject:indexPath];
    }
    
}

- (IBAction)selectedDone:(UIBarButtonItem *)sender {
    if (!self.selectedTags) {
        self.selectedTags = [NSMutableArray arrayWithCapacity:self.selecteds.count];
    } else
        [self.selectedTags removeAllObjects];

    for (NSIndexPath *tem in self.selecteds) {
        [self.selectedTags addObject:self.tags[tem.row]];
    }
    self.block(self.selectedTags, self.selecteds);
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getSelectedTags:(GetSelectedTags)block {
    self.block = block;
}

#pragma mark - 
- (void)getTagList {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[BASE_URL stringByAppendingPathComponent:RELATIVE_URL_TAG_LIST] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        if (![dic[@"status"] intValue]) {
            self.tags = dic[@"data"];
            [self.tableView reloadData];
        } 

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@ - > Error: %@", RELATIVE_URL_TAG_LIST, error);
    }];
}
@end
