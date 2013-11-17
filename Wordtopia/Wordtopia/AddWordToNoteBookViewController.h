//
//  AddWordToNoteBookViewController.h
//  Wordtopia
//
//  Created by Vincent Ngo on 11/29/12.
//  Copyright (c) 2012 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddWordToNoteBookViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *wordTableView;

@property (nonatomic, strong) NSMutableArray *listCellCheckbox;


//The word to be added properties
@property (nonatomic, strong) NSMutableDictionary *wordselectedToAdd;
@property (nonatomic, strong) NSString *wordKey;


//This "mutable" dictionary will contain all the notebooks from the plist app delegate
@property (nonatomic, strong) NSMutableDictionary *notebookDict;

//This will contain all the names of the notebookDict
@property (nonatomic, strong) NSMutableArray *listOfNotebooks;

//get a particular notebook
@property (nonatomic, strong) NSMutableDictionary *notebookDictToData;

//get all the words dict in a particular notebook
@property (nonatomic, strong) NSMutableDictionary *notebookDictToAllWordsDict;






@end
