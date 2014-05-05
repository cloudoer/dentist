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
#import "ClinicPickView.h"
#import "RegThreeTableViewController.h"

@interface RegTwoTableViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate>
{
    NSMutableArray *clinics;
    NSMutableArray *jobTitles;
    ClinicPickView *pickView;
    NSString *imageDataBase64Str;
}

@property (strong, nonatomic) NSString *clinicId;
@property (strong, nonatomic) NSString *jobTitleId;

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
    
    clinics   = [NSMutableArray array];
    jobTitles = [NSMutableArray array];
    pickView = [ClinicPickView mainView];
    
    pickView.frame = CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, 206);
    self.clinicTextField.inputView = pickView;
    [self.view addSubview:pickView];
    [pickView pickerViewDidSeleted:^(NSDictionary *dic, BOOL close, NSString *key) {
        if (close) {
            [self.clinicTextField resignFirstResponder];
            [self.jobTitleTextField resignFirstResponder];
        }
        if ([key isEqualToString:@"name"]) {
            self.clinicTextField.text = dic[key];
            self.clinicId             = dic[@"id"];
        } else {
            self.jobTitleTextField.text = dic[key];
            self.jobTitleId             = dic[@"id"];
        }
        

    }];

    self.jobTitleTextField.inputView = pickView;
    
    self.tableView.tableFooterView = [UIView new];
    
    [self.maleBtn setImage:[UIImage imageNamed:@"individual_publish_circle_h"] forState:UIControlStateSelected];
    [self.maleBtn setImage:[UIImage imageNamed:@"individual_publish_circle"] forState:UIControlStateNormal];
    [self.femalBtn setImage:[UIImage imageNamed:@"individual_publish_circle_h"] forState:UIControlStateSelected];
    [self.femalBtn setImage:[UIImage imageNamed:@"individual_publish_circle"] forState:UIControlStateNormal];
    
    self.maleBtn.selected = YES;

    [self addAvatorGesturer];
    
    [self fetchClinicList];
    
    [self fetchJobTitleList];
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
    
    NSString *msg;
    if (![NSUtil trimSpace:self.realnameTextField.text].length) {
        msg = @"真实姓名不能为空";
    } else if (!self.jobTitleId) {
        msg = @"职称不能为空";
    } else if (!self.clinicId) {
        msg = @"诊所不能为空";
    } else if ([self.goodatTextView.text isEqualToString:@"您所擅长的"] || ![NSUtil trimSpace:self.goodatTextView.text].length) {
        msg = @"您所擅长的不能为空";
    }
    
    if (msg) {
        [NSUtil alertNotice:@"错误提示" withMSG:msg cancleButtonTitle:@"确定" otherButtonTitle:nil];
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"username" : self.phone,
                                 @"password" : self.password,
                                 @"captcha" : self.captcha,
                                 @"realname" : self.realnameTextField.text,
                                 @"sex" : self.maleBtn.selected ? @(1) : @(2),
                                 @"job_title_id" : self.jobTitleId,
                                 @"clinic_id" : self.clinicId,
                                 @"photo": imageDataBase64Str,
                                 @"photo_ext": @"png",
                                 @"description": self.goodatTextView.text
                                  };
    
    
    [Network httpPostPath:URL_PATH_REG_DONE parameters:parameters success:^(NSDictionary *responseObject) {
        if ([Network statusOKInResponse:responseObject]) {
            [Tools showAlertViewWithText:@"注册成功"];
            [self performSegueWithIdentifier:@"RegTwo2Three" sender:nil];
        } else
            [Tools showAlertViewWithText:[Network statusErrorDes:responseObject]];
    } failure:^(NSError *error) {
            [Tools showAlertViewWithText:@"链接异常"];
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
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.clinicTextField) {
        pickView.datas = clinics;
        pickView.key   = @"name";
        if (![pickView isShowing]) {
            [pickView showInView];            
        }

    } else if (textField == self.jobTitleTextField) {
        pickView.datas = jobTitles;
        pickView.key   = @"title";
        if (![pickView isShowing]) {
            [pickView showInView];
        }

    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.realnameTextField) {
        [textField resignFirstResponder];
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
    
    
    imageDataBase64Str = [[NSString alloc] initWithData:[GTMBase64 encodeData:imageData] encoding:NSUTF8StringEncoding];
    
    self.avator.image = [chosenImage clipImageWithScaleWithsize:CGSizeMake(120, 120)];
	
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)fetchClinicList {
    [Network httpGetPath:URL_PATH_CLINIC_LIST success:^(NSDictionary *response) {
        if ([Network statusOKInResponse:response]) {//name
            clinics = response[@"data"];
        } else {
            [NSUtil alertNotice:@"错误提示" withMSG:[Network statusErrorDes:response] cancleButtonTitle:@"确定" otherButtonTitle:nil];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@ ->error: %@",URL_PATH_CLINIC_LIST, error);
    }];
}

- (void)fetchJobTitleList {
    [Network httpGetPath:URL_PATH_JOBTITLE_LIST success:^(NSDictionary *response) {
        if ([Network statusOKInResponse:response]) {//title
            jobTitles = response[@"data"];
        } else {
            [NSUtil alertNotice:@"错误提示" withMSG:[Network statusErrorDes:response] cancleButtonTitle:@"确定" otherButtonTitle:nil];
        }

    } failure:^(NSError *error) {
        NSLog(@"%@ ->error: %@",URL_PATH_JOBTITLE_LIST, error);
    }];
}

- (IBAction)outsideTapped:(UITapGestureRecognizer *)sender {
    [self.realnameTextField resignFirstResponder];
    [self.clinicTextField resignFirstResponder];
    [self.jobTitleTextField resignFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"RegTwo2Three"]) {
        RegThreeTableViewController *controller = segue.destinationViewController;
        controller.username = self.phone;
    }

}

@end
