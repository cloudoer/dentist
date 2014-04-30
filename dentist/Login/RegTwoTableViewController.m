//
//  RegTwoTableViewController.m
//  dentist
//
//  Created by xiaoyuan wang on 4/29/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "RegTwoTableViewController.h"
#import "UIActionSheetBlock.h"
#import "GTMBase64.h"
#import "UIImage+Cut.h"

@interface RegTwoTableViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *realnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *jobTitleTextField;

@property (weak, nonatomic) IBOutlet UITextField *clinicTextField;
@property (weak, nonatomic) IBOutlet UIImageView *avator;
@property (weak, nonatomic) IBOutlet UITextView *goodatTextView;
@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
@property (weak, nonatomic) IBOutlet UIButton *femalBtn;



- (IBAction)switchSex:(UIButton *)sender;



@end

@implementation RegTwoTableViewController

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
    
    self.tableView.tableFooterView = [UIView new];
    
    [self.maleBtn setImage:[UIImage imageNamed:@"individual_publish_circle_h"] forState:UIControlStateSelected];
    [self.maleBtn setImage:[UIImage imageNamed:@"individual_publish_circle"] forState:UIControlStateNormal];
    [self.femalBtn setImage:[UIImage imageNamed:@"individual_publish_circle_h"] forState:UIControlStateSelected];
    [self.femalBtn setImage:[UIImage imageNamed:@"individual_publish_circle"] forState:UIControlStateNormal];
    
    self.maleBtn.selected = YES;

    [self addAvatorGesturer];
}

- (void)addAvatorGesturer {
    [self.avator addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadAvator:)]];
}

- (void)uploadAvator:(UITapGestureRecognizer *)sender {
    UIActionSheetBlock *action = [[UIActionSheetBlock alloc] initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册" block:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            //photo
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate                 = self;
            picker.sourceType               = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.allowsEditing            = YES;
            [self presentViewController:picker animated:YES completion:NULL];
        } else if (buttonIndex == 0) {
            //camera
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate                 = self;
            picker.sourceType               = UIImagePickerControllerSourceTypeCamera;
            picker.allowsEditing            = YES;
            [self presentViewController:picker animated:YES completion:NULL];
        }
    }];
    [action showInView:self.view];
}

- (IBAction)nextBtnPressed:(UIBarButtonItem *)sender {
    
}

- (IBAction)finishButtonPressed:(UIButton *)sender {
    
    NSString *realname = self.realnameTextField.text;
    NSString *gender = @"1"; // 1 male
    NSString *clinic = self.clinicTextField.text;
    NSString *jobTitle = self.jobTitleTextField.text;
    
    NSDictionary *parameters =
  @{
    @"username" : self.phone,
    @"password" : self.password,
    @"captcha" : self.captcha,
    @"realname" : realname,
    @"sex" : gender,
    @"job_title_id" : jobTitle,
    @"clinic_id" : clinic
    };
    
    
    [Network httpPostPath:URL_PATH_REG_DONE parameters:parameters success:^(NSDictionary *responseObject) {
        if ([Network statusOKInResponse:responseObject]) {
            [Tools showAlertViewWithText:@"注册成功"];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)switchSex:(UIButton *)sender {
    if (sender.tag == 2) {
        //femal
        self.femalBtn.selected = YES;
        self.maleBtn.selected = NO;
    } else {
        //male
        self.maleBtn.selected = YES;
        self.femalBtn.selected = NO;
    }

}

#pragma mark - 

#pragma mark - Image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage   = info[UIImagePickerControllerEditedImage];

    CGFloat compression    = 0.9f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize        = 250*1024;
    
    NSData *imageData = UIImageJPEGRepresentation(chosenImage, compression);
    
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(chosenImage, compression);
    }
    
    
    NSString *imageDataBase64Str = [[NSString alloc] initWithData:[GTMBase64 encodeData:imageData] encoding:NSUTF8StringEncoding];
    
    self.avator.image = [chosenImage clipImageWithScaleWithsize:CGSizeMake(120, 120)];
	
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
