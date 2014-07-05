//
//  PictViewController.m
//  nanikore
//
//  Created by 村上 晋太郎 on 2014/07/06.
//  Copyright (c) 2014年 nae-lab. All rights reserved.
//

#import "PictViewController.h"

@interface PictViewController ()
@property UIImageView * canvas;
@property CGPoint touchPoint;
@end

@implementation PictViewController

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
  
  _canvas = [[UIImageView alloc] init];
  _canvas.backgroundColor = [UIColor whiteColor];
  _canvas.frame = self.view.frame;
  [self.view insertSubview:_canvas atIndex:0];
  
}

- (IBAction)backButtonPush:(id)sender {
  [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)eraseButtonPush:(id)sender {
  [self erase];
}

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
  UITouch *touch = [touches anyObject];
  _touchPoint = [touch locationInView:_canvas];
}

- (void)touchesMoved:(NSSet *)touches
           withEvent:(UIEvent *)event
{
  UITouch *touch = [touches anyObject];
  CGPoint currentPoint = [touch locationInView:_canvas];
  
  UIGraphicsBeginImageContext(_canvas.frame.size);
  [_canvas.image drawInRect:
   CGRectMake(0, 0, _canvas.frame.size.width, _canvas.frame.size.height)];
  
  CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
  
  CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 10.0);
  
  CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
  
  CGContextMoveToPoint(UIGraphicsGetCurrentContext(), _touchPoint.x, _touchPoint.y);
  
  CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
  
  CGContextStrokePath(UIGraphicsGetCurrentContext());
  
  _canvas.image = UIGraphicsGetImageFromCurrentImageContext();
  
  UIGraphicsEndImageContext();
  
  _touchPoint = currentPoint;
}

- (void)erase
{
  
  UIGraphicsBeginImageContext(_canvas.frame.size);
  [_canvas.image drawInRect:
   CGRectMake(0, 0, _canvas.frame.size.width, _canvas.frame.size.height)];
  
  CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), 1.0f, 1.0f, 1.0f, 1.0f);
  
  CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, _canvas.frame.size.width, _canvas.frame.size.height));
  
  _canvas.image = UIGraphicsGetImageFromCurrentImageContext();
  
  UIGraphicsEndImageContext();
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
