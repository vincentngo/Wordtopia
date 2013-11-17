//
//  WordCell.h
//  Wordtopia
//
//  Created by Vincent Ngo on 11/28/12.
//  Copyright (c) 2012 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *wordTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *wordContextLabel;
@property (strong, nonatomic) IBOutlet UILabel *wordsampleDefLabel;
@property (strong, nonatomic) IBOutlet UILabel *numDefLabel;
@property (strong, nonatomic) IBOutlet UILabel *numContextLabel;



@end
