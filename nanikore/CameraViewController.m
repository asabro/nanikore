//
//  CameraViewController.m
//  nanikore
//
//  Created by 村上 晋太郎 on 2014/07/05.
//  Copyright (c) 2014年 nae-lab. All rights reserved.
//

#import "CameraViewController.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor blackColor];
  [self setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  [self showUIImagePicker];
}

- (void)showUIImagePicker
{
  // カメラが使用可能かどうか判定する
  if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    return;
  }
  
  // UIImagePickerControllerのインスタンスを生成
  //  UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
  
  // デリゲートを設定
  self.delegate = self;
  
  // 画像の取得先をカメラに設定
  self.sourceType = UIImagePickerControllerSourceTypeCamera;
  
  // 画像取得後に編集するかどうか（デフォルトはNO）
  self.allowsEditing = YES;
}

// 画像が選択された時に呼ばれるデリゲートメソッド
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
  // モーダルビューを閉じる
  [self dismissViewControllerAnimated:YES completion:nil];
  
  // Ask画面に遷移
  [self.prevViewController pushAskViewController];
  
  // 画像をアップロード
  // Get the selected image.
  
  // Convert the image to JPEG data.
  NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
  
  [self processDelegateUpload:imageData];
  
//  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

// 画像の選択がキャンセルされた時に呼ばれるデリゲートメソッド
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  // モーダルビューを閉じる
  [self dismissViewControllerAnimated:YES completion:nil];
  
  // キャンセルされたときの処理を記述・・・
}

#pragma mark - AmazonServiceRequestDelegate

- (void)processDelegateUpload:(NSData *)imageData
{
  // Upload image data.  Remember to set the content type.
  NSDate * date = [NSDate date];
  
  S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:date.stringWithISO8061Format
                                                           inBucket:[Constants pictureBucket]];
  por.contentType = @"image/jpeg";
  por.data = imageData;
  por.delegate = self;
  
  // Put the image data into the specified s3 bucket and object.
  AmazonS3Client * s3 = [AppDelegate s3];
  [s3 putObject:por];
}

-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
  [self showAlertMessage:@"The image was successfully uploaded." withTitle:@"Upload Completed"];
  
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error
{
  NSLog(@"Error: %@", error);
  [self showAlertMessage:error.description withTitle:@"Upload Error"];
  
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)showAlertMessage:(NSString *)message withTitle:(NSString *)title
{
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                      message:message
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
  [alertView show];
}


#pragma mark -

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
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