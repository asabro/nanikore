//
//  SeeAnswerViewController.h
//  nanikore
//
//  Created by 村上 晋太郎 on 2014/07/05.
//  Copyright (c) 2014年 nae-lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeeAnswerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray * answers;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
