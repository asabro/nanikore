//
//  OtherAnswerListViewController.h
//  nanikore
//
//  Created by 村上 晋太郎 on 2014/07/05.
//  Copyright (c) 2014年 nae-lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherAnswerListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property UIImage * image;
@property NSString * text;
@property NSDictionary * answer;
@end
