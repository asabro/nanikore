//
//  AnswerViewController.m
//  nanikore
//
//  Created by 村上 晋太郎 on 2014/07/05.
//  Copyright (c) 2014年 nae-lab. All rights reserved.
//

#import "AppDelegate.h"
#import "AnswerViewController.h"
#import "QuestionKeys.h"
#import "AnswerKeys.h"
#import "OtherAnswerListViewController.h"

#define kOtherAnswerListSegue @"otherAnswerList"

@interface AnswerViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@end

@implementation AnswerViewController

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
  _textLabel.text = _question[kQuestionText];
  _imageView.image = _image;

    // listenTo を送る
    AZSocketIO * socketIO = [AppDelegate answerSocketIO];
    [socketIO emit:@"listenTo" args:_question[kQuestionID] error:nil ack:^{
    }];

    [_textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  NSString * text = _textField.text;
  
  NSDictionary * answer =
  @{
    kAnswerQID: _question[kQuestionID],
    kAnswerName: [AppDelegate username],
    kAnswerText: text
    };
  
  // send answer
  NSLog(@"%@", answer);
  
  AZSocketIO * socketIO = [AppDelegate answerSocketIO];
  [socketIO emit:@"answer" args:answer error:nil ack:^{
  }];
  
  OtherAnswerListViewController * vc = [segue destinationViewController];
  vc.answer = answer;
  vc.image = self.image;
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
