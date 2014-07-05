//
//  AskListViewController.m
//  nanikore
//
//  Created by 村上 晋太郎 on 2014/07/05.
//  Copyright (c) 2014年 nae-lab. All rights reserved.
//

#import "QuestionListViewController.h"
#import "CountDownViewController.h"
#import "AppDelegate.h"
#import "QuestionKeys.h"

#define kAnswerSegue @"answer"

@interface QuestionListViewController ()
@property (weak, nonatomic) NSMutableArray * questions;
@end

@implementation QuestionListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  _questions = [AppDelegate questions];
}

- (IBAction)buttonPush:(id)sender{
  [self performSegueWithIdentifier:@"countDown" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  // データの受け渡し
  CountDownViewController * vc = [segue destinationViewController];
  
  NSUInteger index = 0;
  NSDictionary * question;
  question = _questions[index];
  vc.question = question;
  NSString *URLString = question[kQuestionImgURL];
	NSURL *url = [NSURL URLWithString:URLString];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *image = [[UIImage alloc] initWithData:data];
  vc.image = image;
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

@end
