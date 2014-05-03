//
//  BuddyNewCell.m
//  dentist
//
//  Created by xiaoyuan wang on 5/3/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "BuddyNewCell.h"

@implementation BuddyNewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
