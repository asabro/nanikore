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
#import "QuestionListViewController.h"

typedef enum {
    GrandCentralDispatch,
    Delegate,
    BackgroundThread
} UploadType;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
// data
@property (strong, nonatomic) NSString * username;
+ (NSString *)username;
@property (strong, nonatomic) NSMutableArray * questions;
+ (NSMutableArray *)questions;

// web api
@property (strong, nonatomic) AZSocketIO * askSocketIO;
@property (strong, nonatomic) AZSocketIO * answerSocketIO;
@property (nonatomic) UploadType uploadType;
@property (nonatomic, retain) AmazonS3Client *s3;

+(AZSocketIO *) askSocketIO;
+(AZSocketIO *) answerSocketIO;
+(AmazonS3Client *) s3;

- (void)initAskSocketIO;
- (void)initAnswerSocketIO;
@end

