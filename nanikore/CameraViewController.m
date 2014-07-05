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
  UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
  
  // デリゲートを設定
  self.delegate = self;
  
  // 画像の取得先をカメラに設定
  self.sourceType = UIImagePickerControllerSourceTypeCamera;
  
  // 画像取得後に編集するかどうか（デフォルトはNO）
  self.allowsEditing = YES;
}


//// 画像が選択された時に呼ばれるデリゲートメソッド
//- (void)imagePickerController:(UIImagePickerController *)picker
//        didFinishPickingImage:(UIImage *)image
//                  editingInfo:(NSDictionary *)editingInfo
//{
//    // モーダルビューを閉じる
//    [self dismissViewControllerAnimated:YES completion:nil];
//    
//    // Ask画面に遷移
//    [self.prevViewController pushAskViewController];
//    
//    // 画像をアップロード
//    // Get the selected image.
//    
//    // Convert the image to JPEG data.
//    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
//    NSLog(@"%d", [imageData length]);
//    self.imageData = imageData;
//    [self processDelegateUpload:imageData];
//    
//    //  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Get the selected image.
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Convert the image to JPEG data.
    NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
    self.imageData = imageData;
    [self upload];

}

// 画像の選択がキャンセルされた時に呼ばれるデリゲートメソッド
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  // モーダルビューを閉じる
  [self dismissViewControllerAnimated:YES completion:nil];
  
  // キャンセルされたときの処理を記述・・・
}

#pragma mark - AmazonServiceRequestDelegate

- (NSData*)generateFormDataFromPostDictionary:(NSDictionary*)dict
{
    id boundary = BOUNDARY;
    NSArray* keys = [dict allKeys];
    NSMutableData* result = [NSMutableData data];
	
    for (int i = 0; i < [keys count]; i++)
    {
        id value = [dict valueForKey: [keys objectAtIndex:i]];
        [result appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		
		if ([value isKindOfClass:[NSData class]])
		{
			// handle image data
			NSString *formstring = [NSString stringWithFormat:IMAGE_CONTENT, [keys objectAtIndex:i]];
			[result appendData: DATA(formstring)];
			[result appendData:value];
		}
		
		NSString *formstring = @"\r\n";
        [result appendData:DATA(formstring)];
    }
	
	NSString *formstring =[NSString stringWithFormat:@"--%@--\r\n", boundary];
    [result appendData:DATA(formstring)];
    return result;
}


- (void) cleanup: (NSString *) output
{
	self.imageData = nil;
    //    NSLog(@"******** %@", output);
}

// NSOperationQueueによる非同期化を見据えてmainにしています。
- (void) upload
{

    if (!self.imageData) {
		NOTIFY_AND_LEAVE(@"Please set image before uploading.");
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString* MultiPartContentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BOUNDARY];
    
	NSMutableDictionary* post_dict = [[NSMutableDictionary alloc] init];
	[post_dict setObject:@"testimage" forKey:@"filename"];
    [post_dict setObject:self.imageData forKey:@"data[User][image]"];
	
	NSData *postData = [self generateFormDataFromPostDictionary:post_dict];
	
    NSString *baseurl = @"http://nani-colle.com/upload";
    NSURL *url = [NSURL URLWithString:baseurl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    if (!urlRequest) NOTIFY_AND_LEAVE(@"Error creating the URL Request");
	
    [urlRequest setHTTPMethod: @"POST"];
  	[urlRequest setValue:MultiPartContentType forHTTPHeaderField: @"Content-Type"];
    [urlRequest setHTTPBody:postData];
	
    NSError *error;
    NSURLResponse *response;
	NSData* result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    //NSLog(@"***** result =%@", result);
    
    if (!result)
	{
		[self cleanup:[NSString stringWithFormat:@"upload error: %@", [error localizedDescription]]];
		return;
	}
	
	// Return results
    NSString *returnURL = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    NSLog(@"***** outstring =%@", returnURL);
	[self cleanup: returnURL];
    
    // しんちゃんへ: ここの returnURL にアップロード済みのURLが入っている

    [self showAlertMessage:@"The image was successfully uploaded." withTitle:@"Upload Completed"];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


- (void)processDelegateUpload:(NSData *)imageData
{
  // Upload image data.  Remember to set the content type.
  NSDate * date = [NSDate date];
 
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]]; // Localeの指定
    [df setDateFormat:@"yyyyMMdd-HHmmss"];
    // 日付(NSDate) => 文字列(NSString)に変換
    NSDate *now = [NSDate date];
    NSString *strNow = [df stringFromDate:now];
    // Upload image data.  Remember to set the content type.
    NSString* fileName = [NSString stringWithFormat:@"%@-%@.jpg", strNow, [[UIDevice currentDevice] name]];
    NSLog(@"%@", fileName);
    NSLog(@"%d", [self.imageData length]);

  S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:fileName
                                                           inBucket:[Constants pictureBucket]];
  por.contentType = @"image/jpeg";
  por.data = self.imageData;

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
