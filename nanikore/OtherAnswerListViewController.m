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

@interface OtherAnswerListViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
  }
  return cell;
}
@end
