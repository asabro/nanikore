//
//  OtherAnswerListViewController.m
//  nanikore
//
//  Created by 村上 晋太郎 on 2014/07/05.
//  Copyright (c) 2014年 nae-lab. All rights reserved.
//

#import "OtherAnswerListViewController.h"
#import "OtherAnswerCell.h"
#import "AppDelegate.h"
#import "AnswerKeys.h"
#import "AnswerFinishViewController.h"

@interface OtherAnswerListViewController ()
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property NSTimer * timer;
@end

@implementation OtherAnswerListViewController

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
  _imageView.image = self.image;
  _label.text = self.text;
  _tableView.dataSource = self;
  _tableView.delegate = self;
  
  UINib *nib = [UINib nibWithNibName:NSStringFromClass([OtherAnswerCell class])
                              bundle:nil];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"Cell"];
  
  AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
  appDelegate.otherAnswerViewController = self;
  
  _countLabel.text = [NSString stringWithFormat:@"%02d", _timeLeft];
  _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(count) userInfo:nil repeats:YES];
}

- (void)count {
  _timeLeft--;
  _countLabel.text = [NSString stringWithFormat:@"%02d", _timeLeft];
  if (_timeLeft <= 0) {
    [self performSegueWithIdentifier:@"finish" sender:self];
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushFinishView {
  [self performSegueWithIdentifier:@"finish" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  [_timer invalidate];
  AnswerFinishViewController * vc = [segue destinationViewController];
  vc.answer1 = [AppDelegate answers][0];
  vc.answer2 = [AppDelegate answers][1];
}

#pragma mark - data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [AppDelegate answers].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellIdentifier = @"Cell";
  OtherAnswerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];

  NSDictionary * answer = [AppDelegate answers][indexPath.row];
  cell.mainLabel.text = answer[kAnswerText];
  cell.nameLabel.text = answer[kAnswerName];
  if ([answer[kAnswerName] isEqualToString:_answer[kAnswerName]]) {
    cell.frameImage.hidden = NO;
  } else {
    cell.frameImage.hidden = YES;
  }
  return cell;
}
@end
