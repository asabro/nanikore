//
//  AskViewController.m
//  nanikore
//
//  Created by 村上 晋太郎 on 2014/07/05.
//  Copyright (c) 2014年 nae-lab. All rights reserved.
//

#import "AskViewController.h"
#import "AppDelegate.h"

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
  NSURLRequest *urlRequest =[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/6324118/toilet.png"]];
  [_webView loadRequest:urlRequest];
//  [self postAsk];
  
}

- (void)postAsk {
  AZSocketIO * socketIO = [AppDelegate askSocketIO];
  
  NSError * error;
  NSDictionary * ask = @{@"name": @"ryohei",
                         @"text": @"hello",
                         @"url": @"http://sample.jp"
                         };
  
  [socketIO emit:@"ask" args:ask error:&error ackWithArgs:^(NSArray *data){
    NSLog(@"%@", data);
    NSLog(@"hello");
  }];
  NSLog(@"%@", error);
  
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
