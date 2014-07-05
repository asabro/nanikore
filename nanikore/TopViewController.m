//
//  ViewController.m
//  nanikore
//
//  Created by Ryohei Fushimi on 7/5/14.
//  Copyright (c) 2014 nae-lab. All rights reserved.
//

#import "TopViewController.h"
#import "CameraViewController.h"
#import "AskViewController.h"
#import "AppDelegate.h"

#define kCameraSegue @"camera"
#define kAskSegue @"ask"

@interface TopViewController ()
            
@end

@implementation TopViewController
            
- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  [self.navigationController setNavigationBarHidden:YES animated:NO];
  AppDelegate * appDelegate;
  [appDelegate initAskSocketIO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:kCameraSegue]) {
    CameraViewController * vc = segue.destinationViewController;
    vc.prevViewController = self;
  } else if ([segue.identifier isEqualToString:kAskSegue]) {
    AskViewController * vc = segue.destinationViewController;
    vc.imgurl = self.imgurl;
  }
}

- (void) pushAskViewController {
  [self performSegueWithIdentifier:kAskSegue sender:self];
}

@end
