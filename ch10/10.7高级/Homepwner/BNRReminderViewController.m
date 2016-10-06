//
//  BNRReminderViewController.m
//  HypnoNerd
//
//  Created by 洪龙通 on 2016/9/28.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "BNRReminderViewController.h"

@interface BNRReminderViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@end

@implementation BNRReminderViewController
{
    UILocalNotification *localNote;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self              = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.tabBarItem.title = @"Reminder";
        self.tabBarItem.image = [UIImage imageNamed:@"Reminder-TabBar"];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.datePicker.date = self.dateCreated;
    self.datePicker.minimumDate = [NSDate dateWithTimeInterval:60.0 sinceDate:self.dateCreated];
//    self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:60.0];
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.dateCreated = self.datePicker.date;
}

- (IBAction)addReminder:(UIButton *)sender
{
    localNote = [[UILocalNotification alloc] init];
    localNote.fireDate = self.datePicker.date;
    localNote.alertBody = @"Hypnotize Me!";
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
    }else {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }

    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
}
@end
