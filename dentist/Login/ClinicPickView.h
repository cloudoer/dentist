//
//  ClinicPickView.h
//  dentist
//
//  Created by zhoulong on 14-4-30.
//  Copyright (c) 2014年 1010.am. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PickerViewDidSeleted) (NSDictionary *dic, BOOL close, NSString *key);

@interface ClinicPickView : UIView <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) NSArray *datas;
@property (copy, nonatomic) PickerViewDidSeleted block;
@property (strong, nonatomic) NSString *key;

- (IBAction)cancel:(UIBarButtonItem *)sender;

- (IBAction)selected:(UIBarButtonItem *)sender;

+ (ClinicPickView *)mainView;

- (BOOL)isShowing;
- (void)showInView;
- (void)pickerViewDidSeleted:(PickerViewDidSeleted)block;

@end
