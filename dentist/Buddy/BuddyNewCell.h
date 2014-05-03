//
//  BuddyNewCell.h
//  dentist
//
//  Created by xiaoyuan wang on 5/3/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuddyNewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;

@end
