//
//  ClinicPickView.m
//  dentist
//
//  Created by zhoulong on 14-4-30.
//  Copyright (c) 2014年 1010.am. All rights reserved.
//

#import "ClinicPickView.h"

@implementation ClinicPickView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (ClinicPickView *)mainView {
    return [[[NSBundle mainBundle] loadNibNamed:@"ClinicPickView" owner:self options:nil] lastObject];
}

- (IBAction)cancel:(UIBarButtonItem *)sender {

    if ([self isShowing]) {
        if (_datas) {
            self.block(_datas[[self.pickerView selectedRowInComponent:0]], YES, self.key);
        } else
            self.block(nil, YES, nil);
    }
    
    [UIView animateWithDuration:.4 animations:^{
        self.frame = CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, 206);
    }];
}

- (IBAction)selected:(UIBarButtonItem *)sender {
    if (_datas) {
       self.block(_datas[[self.pickerView selectedRowInComponent:0]], YES, self.key);
    } else
        self.block(nil, YES, nil);
    
    [UIView animateWithDuration:.4 animations:^{
        self.frame = CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, 206);
    }];
}

- (void)pickerViewDidSeleted:(PickerViewDidSeleted)block {
    self.block = block;
}

- (void)showInView{
   
    [UIView animateWithDuration:.4 animations:^{
        self.frame = CGRectMake(0, DEVICE_HEIGHT - HEIGHT(self), DEVICE_WIDTH, 206);
    }];
}

- (BOOL)isShowing {
    return Y(self) != DEVICE_HEIGHT;
}
#pragma mark - UIPickerView delegate and datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.datas.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (_datas.count) {
        self.block(_datas[row], NO, self.key);
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _datas[row][self.key];
}

#pragma mark - setter
- (void)setDatas:(NSArray *)datas {
    _datas = datas;
    [self.pickerView reloadAllComponents];
}

@end
