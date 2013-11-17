//
//  AddWordToNoteBookViewController.m
//  Wordtopia
//
//  Created by Vincent Ngo on 11/29/12.
//  Copyright (c) 2012 Vincent Ngo. All rights reserved.
//

#import "AddWordToNoteBookViewController.h"
#import "NotebookCell.h"
#import "AppDelegate.h"

@interface AddWordToNoteBookViewController ()

@end

@implementation AddWordToNoteBookViewController



- (void)viewDidLoad
{
    
    // Instantiate a Add button to invoke the save: method when tapped
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                   target:self action:@selector(save:)];
    
    
    
    // Set up the add custom button on the right of the navigation bar
    self.navigationItem.rightBarButtonItem = addButton;
    
    
    //Initializing the array for storing boolean objects to keep track of the checks for each cell
    self.listCellCheckbox = [[NSMutableArray alloc] init];

    //Obtain an object reference to the App Delegate object
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //data structure created in the App Delegate class
    self.notebookDict = appDelegate.notebookDict;
    
    self.listOfNotebooks = (NSMutableArray *)[[self.notebookDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    int numOfNotes = [self.listOfNotebooks count];
    
    //Needs to know how many notebook there are, so we can populate the right amount of boolean objects to the array.
    [self populatelistCheckBoxBool:numOfNotes];
     
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark - Custom Add Buton's action method

// Adds the word to the notebooks selected.
- (void)save:(id)sender
{

    
    for (int i = 0; i < [self.listCellCheckbox count]; i++){
        
        if ([self.listCellCheckbox objectAtIndex:i] != [NSNumber numberWithBool:NO]){
        NSString *notebook = [self.listOfNotebooks objectAtIndex:i];    NSLog(@"notebook is %@", notebook);
        
        //Grabs the particular notebook
        self.notebookDictToData = [self.notebookDict objectForKey:notebook];
        
        self.notebookDictToAllWordsDict = [self.notebookDictToData objectForKey:@"all the words"];
        
        [self.notebookDictToAllWordsDict setValue:self.wordselectedToAdd forKey:self.wordKey];
            
           // [self.notebookDictToData setValue:self.notebookDictToAllWordsDict forKey:@"all the words"];
            
           // [self.notebookDict setValue:self.notebookDictToData forKey:notebook];
            
        }
        
    }
    
        NSString *messageToDisplay = @"The word has been added to your selected notebooks";
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Alert" message:messageToDisplay delegate:self
                              cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        
        [alert show];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
        
}





#pragma mark - UITableViewDataSource Protocol Methods


//One section only...
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

//performs a check to see how many rows are in a section and returns the value. In this case self.listOfNotebooks is the number of notebooks within one section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listOfNotebooks count];
}

-(NotebookCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUInteger rowNumber = [indexPath row];
    
    NSString *noteBook = [self.listOfNotebooks objectAtIndex:rowNumber];
    
    //Gets the particular notebook dictionary
    self.notebookDictToData = [self.notebookDict objectForKey:noteBook];
    
    NotebookCell *cell = (NotebookCell *)[tableView dequeueReusableCellWithIdentifier:@"NotebookCellType"];
    
    cell.notebookTitleLabel.text = noteBook;
    
    //Everytime the tableview is reloaded, it will check against the checkBox array to see if the user clicked the check mark or not.
    if ([self.listCellCheckbox objectAtIndex:rowNumber] == [NSNumber numberWithBool:YES]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

//Populates the checkbox array, to keep track of which cell is checked and which is not check. Array stores Boolean Objects from NS Number.
//Default values for a listCellCheckBox will be object boolean of NO.
-(void)populatelistCheckBoxBool:(int)numOfNotes{
    
    for (int i = 0; i < numOfNotes; i++){
        
        [self.listCellCheckbox addObject:[NSNumber numberWithBool:NO]];
    }
    
}

#pragma mark UITableViewDelegate Protocol Methods
//Tapping a cell, will perform a toggle for check marks. If cell is checked and user taps the cell then checked icon is disabled, else vice versa..

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUInteger rowNumber = [indexPath row];

    if ([self.listCellCheckbox objectAtIndex:rowNumber] == [NSNumber numberWithBool:NO]){
        
        [self.listCellCheckbox replaceObjectAtIndex:rowNumber withObject:[NSNumber numberWithBool:YES]];
        
    }else{
        
        [self.listCellCheckbox replaceObjectAtIndex:rowNumber withObject:[NSNumber numberWithBool:NO]];
        
    }
    
    [self.wordTableView reloadData];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
