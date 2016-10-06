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
    
    self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:60.0];
}

- (IBAction)addReminder:(UIButton *)sender
{
    localNote = [[UILocalNotification alloc] init];
//    localNote.fireDate             = [NSDate dateWithTimeIntervalSinceNow:8.0];
//    localNote.timeZone = [NSTimeZone localTimeZone];
    localNote.fireDate = self.datePicker.date;
    NSLog(@"%@", localNote.fireDate);
    localNote.alertBody = @"Hypnotize Me!";
//    localNote.alertTitle = @"test";
//    NSLog(@"timezone:%@", [NSTimeZone localTimeZone]);
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
    }else {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }

    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
}
@end
