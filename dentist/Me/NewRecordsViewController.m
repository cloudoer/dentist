//
//  NewRecordsViewController.m
//  dentist
//
//  Created by zhoulong on 14-4-25.
//  Copyright (c) 2014年 1010.am. All rights reserved.
//

#import "NewRecordsViewController.h"

@interface NewRecordsViewController ()<UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITextField *recordsName;
@property (weak, nonatomic) IBOutlet UITextField *age;

@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
@property (weak, nonatomic) IBOutlet UIButton *femalBtn;

@property (weak, nonatomic) IBOutlet UITextView *recordsDes;

@property (weak, nonatomic) IBOutlet UIScrollView *photoScrollView;


- (IBAction)switchSex:(UIButton *)sender;

@end

@implementation NewRecordsViewController

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

    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, .001)];
    
    [self.maleBtn setImage:[UIImage imageNamed:@"individual_publish_circle_h"] forState:UIControlStateSelected];
    [self.maleBtn setImage:[UIImage imageNamed:@"individual_publish_circle"] forState:UIControlStateNormal];
    [self.femalBtn setImage:[UIImage imageNamed:@"individual_publish_circle_h"] forState:UIControlStateSelected];
    [self.femalBtn setImage:[UIImage imageNamed:@"individual_publish_circle"] forState:UIControlStateNormal];
    
    self.maleBtn.selected = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 



#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//
//    // Return the number of rows in the section.
//    return 0;
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/



/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (IBAction)switchSex:(UIButton *)sender {
    if (sender.tag) {
        //femal
        self.femalBtn.selected = YES;
        self.maleBtn.selected = NO;
    } else {
        //male
        self.maleBtn.selected = YES;
        self.femalBtn.selected = NO;
    }
}

- (IBAction)postToServer:(UIBarButtonItem *)sender {
}

#pragma mark -
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.recordsName) {
        [self.age becomeFirstResponder];
    } else if (textField == self.age) {
        [self.age resignFirstResponder];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; {

    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
@end
