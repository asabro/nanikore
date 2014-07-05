//
//  SeeAnswerCell.h
//  nanikore
//
//  Created by 村上 晋太郎 on 2014/07/05.
//  Copyright (c) 2014年 nae-lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeeAnswerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *label;
+ (CGFloat)rowHeight;
@end
