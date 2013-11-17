//
//  CardViewController.h
//  Wordtopia
//
//  Created by Vincent Ngo on 12/14/12.
//  Copyright (c) 2012 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagerViewController.h"

@interface CardViewController : PagerViewController //UIViewController

@property (nonatomic, strong) NSMutableDictionary *wordDict;
@property (nonatomic, strong) NSMutableArray *listOfWords;

@property (nonatomic, strong)id delegate;
@end
