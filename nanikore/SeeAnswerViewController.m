//
//  SeeAnswerViewController.m
//  nanikore
//
//  Created by 村上 晋太郎 on 2014/07/05.
//  Copyright (c) 2014年 nae-lab. All rights reserved.
//

#import "SeeAnswerViewController.h"
#import "AppDelegate.h"

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
  // データ受け取りの準備
  AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
  appDelegate.seeAnswerViewController = self;
  
}

- (void) setupTable {
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
