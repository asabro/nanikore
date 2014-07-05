//
//  AnswerFinishViewController.m
//  nanikore
//
//  Created by 村上 晋太郎 on 2014/07/05.
//  Copyright (c) 2014年 nae-lab. All rights reserved.
//

#import "AnswerFinishViewController.h"
#import "AnswerKeys.h"
#import "AppDelegate.h"

@interface AnswerFinishViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@end

@implementation AnswerFinishViewController

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
  _label1.text = _answer1[kAnswerText];
  _label2.text = _answer2[kAnswerText];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)nextButtonPush:(id)sender {
  [self anserNextQuestion];
}

- (void)anserNextQuestion {
  NSInteger count = 1;
  QuestionListViewController *vc = [self.navigationController.viewControllers objectAtIndex:count];
  [self.navigationController popToViewController:vc animated:YES];
}

- (IBAction)topButtonPush:(id)sender {
  [self returnToRootView];
}

- (void)returnToRootView {
  [self.navigationController popToRootViewControllerAnimated:YES];
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
