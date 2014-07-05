//
//  AppDelegate.m
//  nanikore
//
//  Created by Ryohei Fushimi on 7/5/14.
//  Copyright (c) 2014 nae-lab. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import <AWSRuntime/AWSRuntime.h>

#define SERVER_IP @""
#define SERVER_PORT @"2000"

@interface AppDelegate ()

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // init socketIO
  _socketIO = [[AZSocketIO alloc] initWithHost:SERVER_IP andPort:SERVER_PORT secure:NO];
  
  // init s3
  [self initS3];
  
  //  [self.socketIO connectWithSuccess:^{
  //    NSLog(@"Success connecting!");
  //    NSError * error;
  //    [self.socketIO emit:@"authenticate" args:@{@"username": @"ryohei"} error:&error ackWithArgs:^(NSArray *data){
  //      NSLog(@"%@", data);
  //      NSLog(@"hello");
  //    }];
  //    NSLog(@"%@", error);
  //  } andFailure:^(NSError *error) {
  //    NSLog(@"Failure connecting. error: %@", error);
  //  }];
  
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (AZSocketIO *)socketIO {
  AppDelegate * delegate = [UIApplication sharedApplication].delegate;
  return delegate.socketIO;
}

- (void)initS3 {
  
  if(![ACCESS_KEY_ID isEqualToString:@"CHANGE ME"]
     && self.s3 == nil)
  {
    // Initial the S3 Client.
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // This sample App is for demonstration purposes only.
    // It is not secure to embed your credentials into source code.
    // DO NOT EMBED YOUR CREDENTIALS IN PRODUCTION APPS.
    // We offer two solutions for getting credentials to your mobile App.
    // Please read the following article to learn about Token Vending Machine:
    // * http://aws.amazon.com/articles/Mobile/4611615499399490
    // Or consider using web identity federation:
    // * http://aws.amazon.com/articles/Mobile/4617974389850313
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    self.s3 = [[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
    self.s3.endpoint = [AmazonEndpoints s3Endpoint:US_WEST_2];
    
    // Create the picture bucket.
    S3CreateBucketRequest *createBucketRequest = [[S3CreateBucketRequest alloc] initWithName:[Constants pictureBucket] andRegion:[S3Region USWest2]];
    
    S3CreateBucketResponse *createBucketResponse = [self.s3 createBucket:createBucketRequest];
//    if(createBucketResponse.error != nil)
//    {
//      NSLog(@"Error: %@", createBucketResponse.error);
//    }
  }
}

@end
