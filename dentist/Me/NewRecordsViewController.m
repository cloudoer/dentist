//
//  NewRecordsViewController.m
//  dentist
//
//  Created by zhoulong on 14-4-25.
//  Copyright (c) 2014年 1010.am. All rights reserved.
//

#import "NewRecordsViewController.h"
#import "PhotoesView.h"
#import "ELCImagePickerController.h"
#import "TagViewController.h"
#import "NSUtil.h"
#import "GTMBase64.h"

@interface NewRecordsViewController ()<UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ELCImagePickerControllerDelegate>
{
    int status;
}

@property (strong, nonatomic) NSMutableArray *tags;
@property (strong, nonatomic) NSMutableArray *selectedIndex;
@property (strong, nonatomic) NSMutableString *tagParma;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITextField *recordsName;
@property (weak, nonatomic) IBOutlet UITextField *age;

@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
@property (weak, nonatomic) IBOutlet UIButton *femalBtn;

@property (weak, nonatomic) IBOutlet UITextView *recordsDes;

@property (weak, nonatomic) IBOutlet PhotoesView *photoView;


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
    self.tags = [NSMutableArray arrayWithCapacity:3];

    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, .001)];
    
    [self.maleBtn setImage:[UIImage imageNamed:@"individual_publish_circle_h"] forState:UIControlStateSelected];
    [self.maleBtn setImage:[UIImage imageNamed:@"individual_publish_circle"] forState:UIControlStateNormal];
    [self.femalBtn setImage:[UIImage imageNamed:@"individual_publish_circle_h"] forState:UIControlStateSelected];
    [self.femalBtn setImage:[UIImage imageNamed:@"individual_publish_circle"] forState:UIControlStateNormal];
    
    self.maleBtn.selected = YES;
    
    
    PhotoesView *photoV = [[PhotoesView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), 84)];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    [cell addSubview:photoV];
    self.photoView = photoV;
    [self.photoView selectPhotes:^(NSInteger buttonIndex) {
        if (!buttonIndex)
            [self otherPhotoBtnPressed];
        else if (buttonIndex == 1)
            [self otherCameraBtnPressed];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark - other btn click
- (void)otherPhotoBtnPressed {
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
//    elcPicker.maximumImagesCount = 4;
    elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
	elcPicker.imagePickerDelegate = self;
    
    [self presentViewController:elcPicker animated:YES completion:nil];
    
}

- (void)otherCameraBtnPressed {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate                 = self;
    picker.sourceType               = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}


#pragma mark - Table view data source


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
   
    if (!status) {
        
        status = 1;
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        
        NSString *msg;
        if (![NSUtil trimSpace:self.recordsName.text].length) {
            msg = @"病历名称不能为空";
            status = 0;
        } else if (![NSUtil trimSpace:self.age.text].length) {
            msg = @"年龄不能为空";
            status = 0;
        } else if (![NSUtil trimSpace:self.recordsDes.text].length) {
            msg = @"病历描述不能为空";
            status = 0;
        } else if (!cell.textLabel.text.length) {
            msg = @"标签不能为空";
            status = 0;
        }
        
        if (msg) {
            [NSUtil alertNotice:@"错误提示" withMSG:msg cancleButtonTitle:@"确定" otherButtonTitle:nil];
            return;
        }
        
        
        NSDictionary *params = @{@"uid": @"1",
                                 @"title": self.recordsName.text,
                                 @"content": self.recordsDes.text,
                                 @"imagenum": @(self.photoView.images.count),
                                 @"imageext": @"png",
                                 @"sex": self.maleBtn.selected ? @(1) : @(0),
                                 @"age": self.age.text,
                                 @"tags": self.tagParma
                                 };
        NSMutableDictionary *dics = [NSMutableDictionary dictionaryWithDictionary:params];
        if (self.photoView.images.count) {
            for (int i = 0; i < self.photoView.images.count; i++) {
                NSData *imageData = UIImageJPEGRepresentation(_photoView.images[i], .1);
                NSString *imageDataBase64Str = [[NSString alloc] initWithData:[GTMBase64 encodeData:imageData] encoding:NSUTF8StringEncoding];
                [dics setObject:imageDataBase64Str forKey:[NSString stringWithFormat:@"image%d", i]];
            }
        }
        
        [Network httpPostPath:RELATIVE_URL_RECORDS_SUBMIT parameters:dics success:^(NSDictionary *responseObject) {
            if (![responseObject[@"status"] intValue]) {
                [NSUtil alertNotice:@"提示" withMSG:@"提交成功" cancleButtonTitle:@"确定" otherButtonTitle:nil];
            } else
                [NSUtil alertNotice:@"提示" withMSG:responseObject[@"data"][@"info"] cancleButtonTitle:@"确定" otherButtonTitle:nil];
        } failure:^(NSError *error) {
            NSLog(@"%@ -> %@", RELATIVE_URL_RECORDS_SUBMIT, error);
            [NSUtil alertNotice:@"提示" withMSG:@"提交失败" cancleButtonTitle:@"确定" otherButtonTitle:nil];
        }];
    } else
        [NSUtil alertNotice:@"提示" withMSG:@"病历不能重复提交" cancleButtonTitle:@"确定" otherButtonTitle:nil];
    
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

#pragma UIImagePicker Delegate

#pragma mark - Image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSArray *images = @[image];
    [self.photoView addPhotoes:images];
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
	
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
	for (NSDictionary *dict in info) {
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        [images addObject:image];
		
	}
    
    [self.photoView addPhotoes:images];
	
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"tags"]) {
        TagViewController *tagVC = segue.destinationViewController;
        tagVC.selectedTags = self.tags;
        tagVC.selecteds    = self.selectedIndex;
        [tagVC getSelectedTags:^(NSMutableArray *array, NSMutableArray *selectedIndex) {
            self.tags          = array;
            self.selectedIndex = selectedIndex;
            NSMutableString *str = [NSMutableString string];
            self.tagParma        = [NSMutableString string];

            for (int i = 0; i < array.count; i++) {
                if (i) {
                    [str appendFormat:@",%@" ,array[i][@"name"]];
                    [_tagParma appendFormat:@",%@", array[i][@"id"]];
                }
                else {
                    [str appendFormat:@"%@" ,array[i][@"name"]];
                   [_tagParma appendFormat:@"%@", array[i][@"id"]];
                }
            }
        
            UITableViewCell *cell    = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
            cell.textLabel.text      = str;
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.alpha     = 1.;
        }];
    }
}

@end
