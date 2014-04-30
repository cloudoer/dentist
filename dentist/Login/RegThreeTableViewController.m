//
//  RegThreeTableViewController.m
//  dentist
//
//  Created by zhoulong on 14-4-30.
//  Copyright (c) 2014年 1010.am. All rights reserved.
//

#import "RegThreeTableViewController.h"

@interface RegThreeTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *certificateImageView;

@end

@implementation RegThreeTableViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */
- (IBAction)uploadCertificateImage:(UIButton *)sender {
    
}

- (IBAction)skipThisStep:(UIBarButtonItem *)sender {
    
}


@end
