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

#define TEST_SERVER_IP @"49.212.129.143"
#define TEST_SERVER_PORT @"5000"

@interface AppDelegate ()

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // init socket IO
  [self initAskSocketIO];
  [self initAnswerSocketIO];
  _username = @"hogetarou";
  
  _questions = [NSMutableArray array];
  
  [self initAnswerSocketIO];
  
  // init s3
  [self initS3];
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

// ------------
//    data
// ------------
+ (NSString *)username {
  AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
  return delegate.username;
}

+ (NSMutableArray *)questions {
  AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
  return delegate.questions;
}

+ (NSMutableArray *)answers {
  AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
  return delegate.answers;
}

// ============

- (void)initAskSocketIO {
  __block AppDelegate * __self__ = self;
  // init socketIO
  _askSocketIO = [[AZSocketIO alloc] initWithHost:TEST_SERVER_IP andPort:TEST_SERVER_PORT secure:NO withNamespace:@"/ask"];
  
  // メッセージを受信した時に実行されるBlocks
  [self.askSocketIO setMessageRecievedBlock:^(id data) {
    NSLog(@"data: %@", data);
  }];
  
  // イベントを受信したときに実行されるBlocks
  [self.askSocketIO setEventRecievedBlock:^(NSString *eventName, id data) {
    NSLog(@"eventName: %@, data: %@", eventName, data);
    // 解答の受信
    if ([eventName isEqualToString:@"answer"]) {
      if (__self__.seeAnswerViewController) {
        [__self__.seeAnswerViewController.answers addObject:data[0]];
        [__self__.seeAnswerViewController.tableView reloadData];
      }
    }
  }];
  
  // エラーを受信したときに実行されるBlocks
  [self.askSocketIO setErrorBlock:^(NSError *error) {
    NSLog(@"error: %@", error);
  }];
  
  // 切断されたときに実行されるBlocks
  [self.askSocketIO setDisconnectedBlock:^{
    NSLog(@"Disconnected!");
  }];
  
  [self.askSocketIO connectWithSuccess:^{
    NSLog(@"Success connecting!");
  } andFailure:^(NSError *error) {
    NSLog(@"Failure connecting. error: %@", error);
  }];
}

#define kEventNameQuestion @"question"

- (void)initAnswerSocketIO {
  // init socketIO
  _answerSocketIO = [[AZSocketIO alloc] initWithHost:TEST_SERVER_IP andPort:TEST_SERVER_PORT secure:NO withNamespace:@"/answer"];
  
  __block AppDelegate * __self__ = self;
  
  // メッセージを受信した時に実行されるBlocks
  [self.answerSocketIO setMessageRecievedBlock:^(id data) {
    NSLog(@"data: %@", data);
  }];
  
  // イベントを受信したときに実行されるBlocks
  [self.answerSocketIO setEventRecievedBlock:^(NSString *eventName, id data) {
    NSLog(@"eventName: %@, data: %@", eventName, data);
    if ([eventName isEqualToString:kEventNameQuestion]){
//      [__self__.questions arrayByAddingObjectsFromArray:data[0]];
      __self__.questions = data[0];
//      NSLog(@"class : %@", NSStringFromClass([data[0][0] class]));
    }
    if ([eventName isEqualToString:@"answers"]) {
      __self__.answers = [(NSArray *) data[0] mutableCopy];
    }
    if ([eventName isEqualToString:@"answer"]) {
      
      [__self__.answers addObject:data[0]];
    }
    NSLog(@"loaded questions: %@", __self__.questions);
  }];
  
  // エラーを受信したときに実行されるBlocks
  [self.answerSocketIO setErrorBlock:^(NSError *error) {
    NSLog(@"error: %@", error);
  }];
  
  // 切断されたときに実行されるBlocks
  [self.answerSocketIO setDisconnectedBlock:^{
    NSLog(@"Disconnected!");
  }];
  
  [self.answerSocketIO connectWithSuccess:^{
    NSLog(@"Success connecting!");
  } andFailure:^(NSError *error) {
    NSLog(@"Failure connecting. error: %@", error);
  }];
}

+ (AZSocketIO *)askSocketIO {
  AppDelegate * delegate = [UIApplication sharedApplication].delegate;
  return delegate.askSocketIO;
}

+ (AZSocketIO *)answerSocketIO {
  AppDelegate * delegate = [UIApplication sharedApplication].delegate;
  return delegate.answerSocketIO;
}

- (void)initS3 {
      [AmazonErrorHandler shouldNotThrowExceptions];
      
      self.s3 = [[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
      self.s3.endpoint = [AmazonEndpoints s3Endpoint:AP_NORTHEAST_1];

    

}

+ (AmazonS3Client *)s3 {
  AppDelegate * delegate = [UIApplication sharedApplication].delegate;
  return delegate.s3;
}

@end
