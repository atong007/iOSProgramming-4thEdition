//
//  BNRCoursesViewController.m
//  Nerdfeed
//
//  Created by 洪龙通 on 2016/10/5.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "BNRCoursesViewController.h"
#import "BNRWebViewController.h"

@interface BNRCoursesViewController ()<NSURLSessionDataDelegate>

// NSURLSession就像一个生产NSURLSessionTask对象的工厂
// 可以设置其生产出的NSURLSessionTask对象的通用属性（如请求头的内容）
@property (nonatomic, strong) NSURLSession *urlSession;
@property (nonatomic, copy) NSArray *courses;
@end

@implementation BNRCoursesViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
        self.navigationItem.title = @"BNR Courses";
        
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        _urlSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
        
        [self fetchFeed];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)fetchFeed
{
    NSString *requestString = @"https://bookapi.bignerdranch.com/private/courses.json";
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [self.urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        NSDictionary *jsonObject = [NSJSONSerialization
                                           JSONObjectWithData:data
                                           options:0
                                           error:NULL];
        self.courses = jsonObject[@"courses"];
//        NSLog(@"json:%@", self.courses);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    [dataTask resume];
}

#pragma mark - NSURLSessionData Delegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    NSURLCredential *cred =
    [NSURLCredential credentialWithUser:@"BigNerdRanch"
                               password:@"AchieveNerdvana"
                            persistence:NSURLCredentialPersistenceForSession];
    completionHandler(NSURLSessionAuthChallengeUseCredential, cred);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.courses.count;
}

/**
 *  tableView cell的设置
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.创建cell
    static NSString *reuseID = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseID];
    }
    
    //2.传递数据模型来设置cell属性
    NSDictionary *course = self.courses[indexPath.row];
    cell.textLabel.text = course[@"title"];
    NSArray *upcoming = course[@"upcoming"];
    if (upcoming) {
        cell.detailTextLabel.text = upcoming[0][@"end_date"];
    }
//    cell.detailTextLabel.text = course[@""]
    
    //3.返回cell
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *course = self.courses[indexPath.row];

    NSString *urlString = course[@"url"];
    NSURL *url = [NSURL URLWithString:urlString];
    self.webViewController.url = url;
    if (!self.splitViewController) {
        [self.navigationController pushViewController:self.webViewController animated:YES];
    }
}

@end
