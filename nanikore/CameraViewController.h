//
//  CameraViewController.h
//  nanikore
//
//  Created by 村上 晋太郎 on 2014/07/05.
//  Copyright (c) 2014年 nae-lab. All rights reserved.
//
//  ====================
//  CameraViewController
//  ====================
//
//  写真撮影をするView
//

#import <UIKit/UIKit.h>
#import "TopViewController.h"
#import <AWSS3/AWSS3.h>

@interface CameraViewController : UIImagePickerController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, AmazonServiceRequestDelegate>
@property (nonatomic, strong) TopViewController * prevViewController;
@end
