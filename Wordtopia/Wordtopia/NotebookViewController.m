//
//  NotebookViewController.m
//  Wordtopia
//
//  Created by Vincent Ngo on 11/29/12.
//  Copyright (c) 2012 Vincent Ngo. All rights reserved.
//

#import "NotebookViewController.h"
#import "NotebookCell.h"
#import "AppDelegate.h"
#import "NotebookWordsViewController.h"
#import "AddNoteBookViewController.h"

@interface NotebookViewController ()

@end

@implementation NotebookViewController


- (void)viewDidLoad
{
    
    
    // Instantiate a Add button to invoke the save: method when tapped
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self action:@selector(addNoteBook:)];
    
    
    
    // Set up the add custom button on the right of the navigation bar
    self.navigationItem.rightBarButtonItem = addButton;
    
    
    //Getting the current date today.
    NSDate *aDate = [NSDate date];
    
    self.todayDate = aDate;
    
    NSDateFormatter* format = [[NSDateFormatter alloc]init];
    
    [format setDateFormat:@"EEE, MMM d, yyyy"];
    
    self.currentDate = [format stringFromDate:aDate];
    
    NSLog(@"The current date today is: %@", self.currentDate);
    
    self.title = @"Notebooks";
    
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"woodbg.png"]];

    //Obtain an object reference to the App Delegate object
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //data structure created in the App Delegate class
    self.notebookDict = appDelegate.notebookDict;
    
    
    NSLog(@"notebookDict size: %d", [self.notebookDict count]);
    
    //What if i want to organize them by the time of day?
    //
    //
    
    self.listOfNotebooks = (NSMutableArray *)[[self.notebookDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark - Add Notebook (+) button to Segue
- (void)addNoteBook:(id)sender{
    
   
    
    [self performSegueWithIdentifier:@"addNewNoteBookView" sender:self];
    
}



#pragma mark - UITableViewDataSource Protocol Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listOfNotebooks count];
}

-(NotebookCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUInteger rowNumber = [indexPath row];
    
    NSString *noteBook = [self.listOfNotebooks objectAtIndex:rowNumber];
    
    //Gets the particular notebook dictionary
    self.notebookDictToData = [self.notebookDict objectForKey:noteBook];
    
    //Grabs the list of words in the notebook
    self.notebookDictToAllWords = [self.notebookDictToData objectForKey:@"all the words"];
    
    //Formats the date that the word was added to: Day, Month num, year
    //                                             e.g. Thu, Dec 6, 2012
    //======================================================================
    NSDateFormatter* format = [[NSDateFormatter alloc]init];
    
    [format setDateFormat:@"EEE, MMM d, yyyy"];
    
    NSString *dateCreated = [format stringFromDate:[self.notebookDictToData objectForKey:@"Date Created"]];
    
    NSLog(@"date Created is %@", dateCreated);
    
    //======================================================================
    
    NotebookCell *cell = (NotebookCell *)[tableView dequeueReusableCellWithIdentifier:@"NotebookCellType"];
    
    cell.notebookTitleLabel.text = noteBook;
    cell.dateAddedLabel.text = dateCreated;
    cell.numberOfWordsLabel.text = [NSString stringWithFormat:@"%d",[self.notebookDictToAllWords count]];
    
    
    
    return cell;
}

#pragma mark UITableViewDelegate Protocol Methods

//Tapping a row (date) displays a new view with the points consumed.
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUInteger rowNumber = [indexPath row];
    
    //Gets the notebook that was selected
    NSString *selectedNotebook = [self.listOfNotebooks objectAtIndex:rowNumber];
    
    //grabs the notebookDictionary's data
    self.notebookDictToData = [self.notebookDict objectForKey:selectedNotebook];
    
    //Grabs the list of words in the notebook
    self.notebookDictToAllWords = [self.notebookDictToData objectForKey:@"all the words"];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:@"ShowWordsTableView" sender:self];

}


#pragma mark - Preparing for Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if([[segue identifier] isEqualToString:@"ShowWordsTableView"]){
        
        NotebookWordsViewController *notebookWordsViewController = [segue destinationViewController];
        notebookWordsViewController.wordDict = self.notebookDictToAllWords;
        
    }else if ([[segue identifier] isEqualToString:@"addNewNoteBookView"]){
        
        AddNoteBookViewController *addNoteBookViewController = [segue destinationViewController];
        addNoteBookViewController.delegate = self;
        
        //notebookWordsViewController.delegate = self;
    }
    

}


#pragma mark - AddNoteBook ViewController Delegate
- (void) addNoteBookController:(AddNoteBookViewController *)controller didFinishWithSave:(BOOL)save{
    
    
    NSMutableDictionary *newWordDict = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc]init];
    
    
    [newDict setValue:newWordDict forKey:@"all the words"];
    [newDict setValue:self.todayDate forKey:@"Date Created"];

    [self.notebookDict setValue:newDict forKey:controller.notebooknewName];
    
    
    self.listOfNotebooks = (NSMutableArray *)[[self.notebookDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    
    [self.noteBookTableView reloadData];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
