//
//  CountDownViewController.m
//  nanikore
//
//  Created by 村上 晋太郎 on 2014/07/06.
//  Copyright (c) 2014年 nae-lab. All rights reserved.
//

#import "CountDownViewController.h"
#import "AnswerViewController.h"

@interface CountDownViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property int count;
@end

@implementation CountDownViewController

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
  _count = 3;
  _label.text = [NSString stringWithFormat:@"%d", _count];
  [self performSelector:@selector(countDown) withObject:nil afterDelay:1.0];
}

- (void)countDown {
  _count--;
  _label.text = [NSString stringWithFormat:@"%d", _count];
  if (_count >= 1) {
    [self performSelector:@selector(countDown) withObject:nil afterDelay:1.0];
  } else {
    [self performSegueWithIdentifier:@"answer" sender:self];
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  AnswerViewController * vc = [segue destinationViewController];
  vc.question = self.question;
  vc.image = self.image;
}

@end
