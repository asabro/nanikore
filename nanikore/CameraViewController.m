//
//  CameraViewController.m
//  nanikore
//
//  Created by 村上 晋太郎 on 2014/07/05.
//  Copyright (c) 2014年 nae-lab. All rights reserved.
//

#import "CameraViewController.h"

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
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
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
  self.allowsEditing = NO;
}

// 画像が選択された時に呼ばれるデリゲートメソッド
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
  // モーダルビューを閉じる
  [self dismissViewControllerAnimated:YES completion:nil];
  
//  // 渡されてきた画像をフォトアルバムに保存
//  UIImageWriteToSavedPhotosAlbum(image, self, @selector(targetImage:didFinishSavingWithError:contextInfo:), NULL);
}

// 画像の選択がキャンセルされた時に呼ばれるデリゲートメソッド
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  // モーダルビューを閉じる
  [self dismissViewControllerAnimated:YES completion:nil];
  
  // キャンセルされたときの処理を記述・・・
}

// 画像の保存完了時に呼ばれるメソッド
- (void)targetImage:(UIImage *)image
didFinishSavingWithError:(NSError *)error
        contextInfo:(void *)context
{
  if (error) {
    // 保存失敗時の処理
  } else {
    // 保存成功時の処理
  }
}

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
