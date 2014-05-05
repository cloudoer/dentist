//
//  RegThreeTableViewController.m
//  dentist
//
//  Created by zhoulong on 14-4-30.
//  Copyright (c) 2014年 1010.am. All rights reserved.
//

#import "RegThreeTableViewController.h"
#import "UIActionSheetBlock.h"
#import "UIImage+Cut.h"
#import "GTMBase64.h"

@interface RegThreeTableViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
        NSString *imageDataBase64Str;
}

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

- (IBAction)skipThisStep:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    self.certificateImageView.image = [chosenImage clipImageWithScaleWithsize:CGSizeMake(400, 400)];
	
    NSDictionary *dic = @{@"username": self.username,
                          @"identify": imageDataBase64Str,
                          @"identify_ext": @"png"};
    [Network httpPostPath:URL_PATH_UPDATE_USER_INFO parameters:dic success:^(NSDictionary *responseObject) {
        if ([Network statusOKInResponse:responseObject]) {
            [Tools showAlertViewWithText:@"上传成功"];
             [self dismissViewControllerAnimated:YES completion:NULL];
        } else
            [Tools showAlertViewWithText:[Network statusErrorDes:responseObject]];
    } failure:^(NSError *error) {
        [Tools showAlertViewWithText:@"网络异常,稍后重试"];
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
