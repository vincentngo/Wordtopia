//
//  NotebookWordsViewController.h
//  Wordtopia
//
//  Created by Vincent Ngo on 11/29/12.
//  Copyright (c) 2012 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeckViewController.h"
@interface NotebookWordsViewController : UITableViewController <DeckViewControllerDelegate>

//
@property (nonatomic, strong) NSMutableDictionary *wordDict;

@property (nonatomic, strong) NSMutableDictionary *aWordDict;

@property (nonatomic, strong) NSMutableArray *listOfWords;

@property (nonatomic, strong) NSMutableDictionary *wordDictToInfoDict;

@property (nonatomic, strong) NSMutableArray *listOfDef;

@property (nonatomic, strong) NSMutableDictionary *selectedNoteBook;


@property (nonatomic, strong) NSMutableDictionary *selectedWord;
@property (nonatomic, strong) NSString *selectedWordString;

- (IBAction)wordInformationTapped:(id)sender;
- (IBAction)showFlashCard:(id)sender;

@end

