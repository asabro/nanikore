//
//  SeeAnswerViewController.m
//  nanikore
//
//  Created by 村上 晋太郎 on 2014/07/05.
//  Copyright (c) 2014年 nae-lab. All rights reserved.
//

#import "SeeAnswerViewController.h"
#import "AppDelegate.h"

#import "AnswerKeys.h"

@interface SeeAnswerViewController ()
@end

@implementation SeeAnswerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
  _answers = [NSMutableArray array];
//  NSArray * answers =
//  @[
//    @{kAnswerText: @"といれ",
//      kAnswerQID: @"123",
//      kAnswerName: @"murakami"},
//    @{kAnswerText: @"といれだよ",
//      kAnswerQID: @"123",
//      kAnswerName: @"murakami"},
//    @{kAnswerText: @"といれっと",
//      kAnswerQID: @"123",
//      kAnswerName: @"murakami"},
//    @{kAnswerText: @"といれ〜",
//      kAnswerQID: @"123",
//      kAnswerName: @"murakami"},
//    @{kAnswerText: @"といれtれ",
//      kAnswerQID: @"123",
//      kAnswerName: @"murakami"},
//    ];
//  _answers = [answers mutableCopy];
  // データ受け取りの準備
  AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
  appDelegate.seeAnswerViewController = self;
  
  _tableView.dataSource = self;
}

- (void) setupTable {
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return _answers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  NSString *cellIdentifier = @"Cell";
  UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }
  
  NSDictionary * answer = _answers[indexPath.row];
  cell.textLabel.text = answer[kAnswerText];
  return cell;
}


@end
