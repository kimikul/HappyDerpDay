//
//  AHHomeViewController.m
//  AutoHBD
//
//  Created by Kimberly Hsiao on 12/17/13.
//  Copyright (c) 2013 hsiao. All rights reserved.
//

#import "AHHomeViewController.h"
#import "AHFriendBirthdayCell.h"

@interface AHHomeViewController ()
@property (nonatomic, strong) NSArray *friendsWithBirthdaysToday;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation AHHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchFriendsBirthdays];
    [self setupDateLabel];
    [self setupTable];
}

- (void)setupDateLabel {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM d"];
    
    NSDate *today = [NSDate date];
    NSString *formattedDate = [dateFormatter stringFromDate:today];
    
    _dateLabel.text = formattedDate;
}

- (void)setupTable {
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:[AHFriendBirthdayCell reuseIdentifier] bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[AHFriendBirthdayCell reuseIdentifier]];
}

#pragma mark - network requests

- (void)fetchFriendsBirthdays {
    FBRequest *friendRequest = [FBRequest requestForGraphPath:@"me/friends?fields=name,picture,birthday"];
    [friendRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSMutableArray *friends = [[result objectForKey:@"data"] mutableCopy];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:TRUE];
        [friends sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        [self findBirthdaysTodayFromFriends:friends];
    }];
}

- (void)findBirthdaysTodayFromFriends:(NSArray*)friends {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd"];
    
    NSDate *today = [NSDate date];
    NSString *todayString = [dateFormatter stringFromDate:today];
    
    NSMutableArray *friendsWithBirthdaysToday = [NSMutableArray new];
    NSString *monthAndDayString = [NSString new];
    
    for (FBGraphObject<FBGraphUser> *friend in friends) {
        if (friend.birthday.length >= 5) {
            monthAndDayString = [friend.birthday substringToIndex:5];
            if ([monthAndDayString isEqualToString:todayString]) {
                [friendsWithBirthdaysToday addObject:friend];
                NSLog(@"%@:%@", [friend name],[friend birthday]);
            }
        }
    }
    
    _friendsWithBirthdaysToday = [friendsWithBirthdaysToday copy];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _friendsWithBirthdaysToday.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [AHFriendBirthdayCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AHFriendBirthdayCell *cell = [tableView dequeueReusableCellWithIdentifier:[AHFriendBirthdayCell reuseIdentifier] forIndexPath:indexPath];
    
    NSDictionary *friend = [_friendsWithBirthdaysToday objectAtIndex:indexPath.row];
    cell.friend = friend;
    
    return cell;
}

@end
