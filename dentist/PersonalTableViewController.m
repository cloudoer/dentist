//
//  PersonalTableViewController.m
//  dentist
//
//  Created by xiaoyuan wang on 4/10/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "PersonalTableViewController.h"
#import "AppDelegate.h"
#import "XMPPvCardTemp.h"
#import "UIImageView+WebCache.h"

@interface PersonalTableViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *realnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *orgNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialtyLabel;

@end

@implementation PersonalTableViewController

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
    Userinfo *userinfo = [LoginFacade sharedUserinfo];
    
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:userinfo.avatar_url] placeholderImage:[UIImage imageNamed:@"tab_me.png"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Userinfo *userinfo = [LoginFacade sharedUserinfo];
    
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:userinfo.avatar_url] placeholderImage:[UIImage imageNamed:@"tab_me.png"]];
    self.realnameLabel.text = userinfo.realname;
    self.genderLabel.text = userinfo.sex;
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@", userinfo.province, userinfo.city, userinfo.area];
    self.orgNameLabel.text = userinfo.orgName;
    self.jobTitleLabel.text = userinfo.title;
    self.specialtyLabel.text = userinfo.expert;
    
}

- (IBAction)avatarChangButtonPressed:(UIButton *)sender {
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册获取", nil];
    [as showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraDevice=UIImagePickerControllerCameraDeviceFront;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }else if (buttonIndex == 1) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.avatarImageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
