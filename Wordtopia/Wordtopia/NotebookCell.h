//
//  NotebookCell.h
//  Wordtopia
//
//  Created by Vincent Ngo on 11/28/12.
//  Copyright (c) 2012 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotebookCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *notebookTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) IBOutlet UILabel *numWordsLabel;

@property (strong, nonatomic) IBOutlet UILabel *dateAddedLabel;


@property (strong, nonatomic) IBOutlet UILabel *numberOfWordsLabel;




@end
