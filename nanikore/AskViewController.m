//
//  AskViewController.m
//  nanikore
//
//  Created by 村上 晋太郎 on 2014/07/05.
//  Copyright (c) 2014年 nae-lab. All rights reserved.
//

#import "AskViewController.h"
#import "AppDelegate.h"
#import "QuestionKeys.h"

#define kSeeAnswerSegue @"seeAnswers"

@interface AskViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation AskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
//  _imgurl = @"https://dl.dropboxusercontent.com/u/6324118/toilet.png";
  
//  _webView.scalesPageToFit = YES;
  NSURLRequest *urlRequest =[NSURLRequest requestWithURL:[NSURL URLWithString:_imgurl]];
  [_webView loadRequest:urlRequest];
}

- (void)postQuestion {
  AZSocketIO * socketIO = [AppDelegate askSocketIO];
  
  NSError * error;
  
  [socketIO emit:@"ask" args:_question error:&error ackWithArgs:^(NSArray *data){
    NSLog(@"%@", data);
  }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (IBAction)button0Push:(id)sender {
  _text = @"What's This?";
  [self pushSeeAnswerView];
}

- (IBAction)button1Push:(id)sender {
  _text = @"How to user it?";
  [self pushSeeAnswerView];
}

- (IBAction)button2Push:(id)sender {
  _text = @"Which one?";
  [self pushSeeAnswerView];
}

- (IBAction)button3Push:(id)sender {
  _text = @"What are they doing?";
  [self pushSeeAnswerView];
}

- (void)pushSeeAnswerView {
  _question =
  @{kQuestionText: _text,
    kQuestionName: [AppDelegate username],
    kQuestionImgURL: _imgurl};
  
  [self postQuestion];
  [self performSegueWithIdentifier:kSeeAnswerSegue sender:self];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  SeeAnswerViewController * vc = segue.destinationViewController;
}

@end
