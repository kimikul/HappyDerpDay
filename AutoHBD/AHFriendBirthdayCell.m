//
//  AHFriendBirthdayCell.m
//  AutoHBD
//
//  Created by Kimberly Hsiao on 12/17/13.
//  Copyright (c) 2013 hsiao. All rights reserved.
//

#import "AHFriendBirthdayCell.h"

@interface AHFriendBirthdayCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePicImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@end

@implementation AHFriendBirthdayCell

+ (NSString*)reuseIdentifier {
    return @"AHFriendBirthdayCell";
}

+ (CGFloat)cellHeight {
    return 66;
}

- (void)setFriend:(NSDictionary *)friend {
    _friend = friend;
    
    _nameLabel.text = [friend objectForKey:@"name"];
    _ageLabel.text = [self computeAgeLabel];
    _profilePicImageView.image = [self loadProfilePic];
}

- (NSString*)computeAgeLabel {
    NSString *ageLabel = @"";
    
    // get current year
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy";
    NSString *yearString = [dateFormatter stringFromDate:[NSDate date]];
    NSInteger currentYear = [yearString integerValue];
    
    // get birth year
    NSString *birthday = [_friend objectForKey:@"birthday"];
    if (birthday.length == 10) {
        birthday = [birthday substringFromIndex:6];
        NSInteger birthYear = [birthday integerValue];
        NSInteger age = currentYear - birthYear;
        ageLabel = [NSString stringWithFormat:@"%d years old",age];
    }
    
    return ageLabel;
}

- (UIImage*)loadProfilePic {
    NSString *picURL = [_friend valueForKeyPath:@"picture.data.url"];
    UIImage *profPic = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picURL]]];
    return profPic;
}

@end
