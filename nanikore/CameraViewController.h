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
@property (nonatomic, retain) TopViewController * prevViewController;
@property (nonatomic, retain) NSData* imageData;
@property (nonatomic, retain) NSURL* imageURL;

- (void) syncUpload:(NSData *) uploadImage;

@end

#define NOTIFY_AND_LEAVE(X) {[self cleanup:X]; return;}
#define DATA(X)	[X dataUsingEncoding:NSUTF8StringEncoding]

// Posting constants
#define IMAGE_CONTENT @"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\nContent-Type: image/jpeg\r\n\r\n"
#define BOUNDARY @"------------0x0x0x0x0x0x0x0x"
