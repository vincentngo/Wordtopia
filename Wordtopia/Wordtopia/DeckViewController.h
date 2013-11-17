//
//  DeckViewController.h
//  Wordtopia
//
//  Created by Vincent Ngo on 12/15/12.
//  Copyright (c) 2012 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlipViewController.h"

@protocol DeckViewControllerDelegate; 


@interface DeckViewController : UIViewController <FlipViewControllerDelegate>

@property (nonatomic, strong) id <DeckViewControllerDelegate> delegate;

@property (nonatomic, strong) NSMutableDictionary *wordDict;
@property (nonatomic, strong) NSMutableArray *listOfWords;


@property (strong, nonatomic) IBOutlet UILabel *wordLabel;
@property (nonatomic, strong)NSString *word;

- (IBAction)backToTabView:(id)sender;
- (IBAction)flipToBack:(id)sender;

@end


@protocol DeckViewControllerDelegate
- (void)deckViewControllerDidFinish:(DeckViewController *)controller;
@end