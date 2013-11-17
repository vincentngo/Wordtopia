//
//  WordCell.m
//  Wordtopia
//
//  Created by Vincent Ngo on 11/28/12.
//  Copyright (c) 2012 Vincent Ngo. All rights reserved.
//

#import "WordCell.h"

@implementation WordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addWordToNotebook:(id)sender {
}
@end
