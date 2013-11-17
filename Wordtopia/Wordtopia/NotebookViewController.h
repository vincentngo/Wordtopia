//
//  NotebookViewController.h
//  Wordtopia
//
//  Created by Vincent Ngo on 11/29/12.
//  Copyright (c) 2012 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddNoteBookViewController.h"

@interface NotebookViewController : UITableViewController <AddNoteBookViewControllerDelegate>//<Adding some protocol from addNoteBook View>



//This "mutable" dictionary will contain all the notebooks from the plist app delegate
@property (nonatomic, strong) NSMutableDictionary *notebookDict;

//This will contain all the names of the notebookDict
@property (nonatomic, strong) NSMutableArray *listOfNotebooks;

//get a particular notebook
@property (nonatomic, strong) NSMutableDictionary *notebookDictToData;

//Gets a dictionary containing all the words within a notebook
@property (nonatomic, strong) NSMutableDictionary *notebookDictToAllWords;

//The current date today
@property (nonatomic, strong) NSString *currentDate;


//TableView to reload Data
@property (strong, nonatomic) IBOutlet UITableView *noteBookTableView;

@property (nonatomic, strong) NSDate *todayDate;

@end
