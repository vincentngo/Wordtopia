//
//  SearchWordViewController.h
//  Wordtopia
//
//  Created by Vincent Ngo on 12/15/12.
//  Copyright (c) 2012 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordParser.h"

@interface SearchWordViewController : UITableViewController <UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
- (IBAction)searchButton:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *wordEnteredField;

//Helper NSObject class with methods to parse words from XML.
@property (nonatomic, strong) WordParser *parse;

//The list of suggested words, if the search fails
@property (nonatomic, strong) NSMutableArray *suggestedWordList;


//TableView to reload Data
@property (strong, nonatomic) IBOutlet UITableView *searchTableView;
// This method is invoked when the user taps Done on the keyboard
//- (IBAction)keyboardDone:(id)sender;

//Selectedword in the search cell
@property (strong, nonatomic) NSString *selectedWordString;

//selectedWord dictionary
@property (strong, nonatomic) NSMutableDictionary *selectedWord;


- (IBAction)keyboardDone:(id)sender;

@end
