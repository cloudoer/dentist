//
//  RoomListCell.h
//  dentist
//
//  Created by xiaoyuan wang on 4/10/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *clinicLabel;
@property (weak, nonatomic) IBOutlet UILabel *theTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *commetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *favoriateImageView;
@property (weak, nonatomic) IBOutlet UIImageView *msgNewImageView;

@end
