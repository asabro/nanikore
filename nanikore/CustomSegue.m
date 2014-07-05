//
//  CustomSegue.m
//  nanikore
//
//  Created by 村上 晋太郎 on 2014/07/06.
//  Copyright (c) 2014年 nae-lab. All rights reserved.
//

#import "CustomSegue.h"

@implementation CustomSegue
- (void)perform {
  UIViewController *sourceViewController = (UIViewController *)self.sourceViewController;
  UIViewController *destinationViewController = (UIViewController *)self.destinationViewController;
  
  [UIView transitionWithView:sourceViewController.navigationController.view
                    duration:0
                     options:UIViewAnimationOptionTransitionNone
                  animations:^{
                    [sourceViewController.navigationController pushViewController:destinationViewController animated:NO];
                  }
                  completion:nil];
}

@end
