//
//  AppDelegate.h
//  nanikore
//
//  Created by Ryohei Fushimi on 7/5/14.
//  Copyright (c) 2014 nae-lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AZSocketIO.h>
#import <AWSS3/AWSS3.h>

typedef enum {
    GrandCentralDispatch,
    Delegate,
    BackgroundThread
} UploadType;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) AZSocketIO * socketIO;
@property (nonatomic) UploadType uploadType;
@property (nonatomic, retain) AmazonS3Client *s3;

+(AZSocketIO *) socketIO;
+(AmazonS3Client *) s3;
@end

