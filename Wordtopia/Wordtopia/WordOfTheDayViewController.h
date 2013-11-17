//
//  WordOfTheDayViewController.h
//  Wordtopia
//
//  Created by Vincent Ngo on 11/20/12.
//  Copyright (c) 2012 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordParser.h"

@interface WordOfTheDayViewController : UITableViewController

//The current date today
@property (nonatomic, strong) NSString *currentDate;
@property (nonatomic, strong) NSString *prevDate;
@property (nonatomic, strong) NSArray *merriamNodes;


//This is a mutablearray that will store all NSString words
@property (nonatomic, strong)NSMutableArray *wordOfDayList;

@property (nonatomic, strong) NSMutableDictionary *wordOfDayDict;

@property (nonatomic, strong) NSMutableDictionary *aWordDict;

@property (nonatomic, strong) NSMutableDictionary *selectedWord;
@property (nonatomic, strong) NSString *selectedWordString;

//Helper NSObject class with methods to parse words from XML.
@property (nonatomic, strong) WordParser *parse;


//UITableView Data

//The current word that is selected from the wordOfDayDict
@property (nonatomic, strong) NSMutableDictionary *wordDict;

//Similar to wordDict, but to keep organized, selectedWordDictToAdd will be passed to the
//AddWordTONotebookViewcontroller
@property (nonatomic, strong) NSMutableDictionary *selectedWordDictToAdd;
@property (nonatomic, strong) NSString *wordToAddKey;



@property (nonatomic, strong) NSMutableDictionary *wordDictToInfoDict;

//All the keys contained in wordOfDayDict
@property (nonatomic, strong) NSMutableArray *listOfWords;

//A particular set of definitions for a word. 
@property (nonatomic, strong) NSMutableArray *listOfDef;


//Custom action button for adding a particular word
- (IBAction)showWordInformationButton:(id)sender;


@end
