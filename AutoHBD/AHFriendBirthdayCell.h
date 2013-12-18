//
//  AHFriendBirthdayCell.h
//  AutoHBD
//
//  Created by Kimberly Hsiao on 12/17/13.
//  Copyright (c) 2013 hsiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AHFriendBirthdayCell : UITableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)cellHeight;

@property (nonatomic, strong) NSDictionary *friend;

@end
