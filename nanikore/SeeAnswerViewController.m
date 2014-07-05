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

#import "SeeAnswerCell.h"

@interface SeeAnswerViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *arigatoButton;
@property BOOL selectEnabled;
@property int  selectCounter;
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
  
  _imageView.image = _image;
  
  _answers = [NSMutableArray array];
  // データ受け取りの準備
  AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
  appDelegate.seeAnswerViewController = self;
  
  [self setupTable];
  
  [self performSelector:@selector(enableSelecting) withObject:nil afterDelay:5.0];
}

- (void) setupTable {
  UINib *nib = [UINib nibWithNibName:NSStringFromClass([SeeAnswerCell class])
                              bundle:nil];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"Cell"];
  
  _tableView.dataSource = self;
  _tableView.delegate = self;
}

- (void) enableSelecting {
  _selectEnabled = YES;
  _backgroundImageView.image = [UIImage imageNamed:@"Q_selectA.png"];
}

- (void) showArigatoButton {
  _arigatoButton.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)arigatoButtonPush:(id)sender {
  [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return _answers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellIdentifier = @"Cell";
  SeeAnswerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
  NSDictionary * answer = _answers[indexPath.row];
  cell.mainLabel.text = answer[kAnswerText];
  cell.nameLabel.text = answer[kAnswerName];
  return cell;
}

#pragma mark - tableviewdelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [SeeAnswerCell rowHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (!_selectEnabled) return;
  SeeAnswerCell * cell = (SeeAnswerCell *)[tableView cellForRowAtIndexPath:indexPath];
  
  if (!cell.gold.hidden || !cell.silver.hidden) return;
  
  if (_selectCounter == 0) {
    cell.gold.hidden = NO;
  } else if (_selectCounter == 1) {
    cell.silver.hidden = NO;
  }
  
  _selectCounter++;
  if ((_selectCounter >= 2) || (_selectCounter >= _answers.count)) {
    [self showArigatoButton];
  }
}

@end
