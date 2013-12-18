//
//  AHViewController.m
//  AutoHBD
//
//  Created by Kimberly Hsiao on 12/17/13.
//  Copyright (c) 2013 hsiao. All rights reserved.
//

#import "AHLoginViewController.h"
#import "AHHomeViewController.h"
#import "AHAppDelegate.h"

@interface AHLoginViewController () <FBLoginViewDelegate>

@property (weak, nonatomic) IBOutlet FBLoginView *connectWithFacebookButton;

@end

@implementation AHLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _connectWithFacebookButton.readPermissions = @[@"basic_info", @"friends_birthday"];
    _connectWithFacebookButton.delegate = self;
}


#pragma mark - FBLoginViewDelegate

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    AHHomeViewController *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AHHomeViewController"];
    AHAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = homeVC;

    
//    self.profilePictureView.profileID = user.id;
//    self.nameLabel.text = user.name;
}

@end
