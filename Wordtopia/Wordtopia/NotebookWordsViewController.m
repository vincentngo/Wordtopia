//
//  NotebookWordsViewController.m
//  Wordtopia
//
//  Created by Vincent Ngo on 11/29/12.
//  Copyright (c) 2012 Vincent Ngo. All rights reserved.
//

#import "NotebookWordsViewController.h"
#import "WordCell.h"
#import "WordDetailViewController.h"
#import "CardViewController.h"
#import "DeckViewController.h"

@interface NotebookWordsViewController ()

@end

@implementation NotebookWordsViewController



- (void)viewDidLoad
{
    
    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                 // initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  //target:self action:@selector(showFlashCard:)];
    
   /* UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIButtonTypeCustom
                                  target:self action:@selector(showFlashCard:)];
    addButton.image = [UIImage imageNamed:@"flashcardIcon.png"];*/
    
    
    
    // Set up the add custom button on the right of the navigation bar
    //self.navigationItem.rightBarButtonItem = addButton;
    
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"woodbg.png"]];
    self.listOfWords = (NSMutableArray *)[[self.wordDict allKeys] sortedArrayUsingSelector:@selector(compare:)];

    NSLog(@"size of list is: %d", [self.listOfWords count]);
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)showFlashCard:(id)sender{
    
    self.listOfWords = (NSMutableArray *)[[self.wordDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    

    
    
    //self.selectedNotebook = []
    
    
    if([self.listOfWords count] != 0){
    CardViewController *controller = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:NULL] instantiateViewControllerWithIdentifier:@"deck"];
    
    controller.delegate = self;
    controller.listOfWords = self.listOfWords;
    controller.wordDict = self.wordDict;
   // controller.listOfWords = self.listOfWords;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:controller animated:YES completion:nil];
     //[self performSegueWithIdentifier:@"ShowFlashCard" sender:self];
    }else{
        
        NSString *messageToDisplay = @"You have no words in this notebook, please add some!";
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Alert" message:messageToDisplay delegate:self
                              cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        
        [alert show];
        
    
    }
    
    
}
#pragma mark - UITableViewDataSource Protocol Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"self.wordDict size is %d",[self.wordDict count]);
    return [self.wordDict count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(WordCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUInteger sectionNumber = [indexPath section];
    
    NSString *word = [ self.listOfWords objectAtIndex:sectionNumber];
    
    //Gets a word from the wordDict
    self.aWordDict = [self.wordDict objectForKey:word];
    
    //gets the word's information, containing the definitions, and examples
    //self.wordDictToInfoDict = [self.aWordDict objectForKey:word];
    
    //gets the number of context
    NSNumber *numcontext = [self.aWordDict objectForKey:@"number of context"];
    int numberOfContext = numcontext.intValue;
    
    if (numberOfContext > 0)
    {
        NSString *wordMoreThanone = [NSString stringWithFormat:@"%@[%d]",word,1];
        //Gets a word from the wordDict
        self.wordDictToInfoDict = [self.aWordDict objectForKey:wordMoreThanone];
    }else{
        //Gets a word from the wordDict
        self.wordDictToInfoDict = [self.aWordDict objectForKey:word];
    }
    
    //gets the array of definitions
    self.listOfDef = [self.wordDictToInfoDict objectForKey:@"definitions"];
    NSString *wordType = [self.wordDictToInfoDict objectForKey:@"type"];
    
    WordCell *cell = (WordCell *)[tableView dequeueReusableCellWithIdentifier:@"WordCellType"];
    
    cell.wordTitleLabel.text = word;
    cell.wordContextLabel.text = wordType;
    cell.wordsampleDefLabel.text = [self.listOfDef objectAtIndex:0];
    
    cell.wordsampleDefLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.wordsampleDefLabel.numberOfLines = 4;
    
    cell.numContextLabel.text = [NSString stringWithFormat:@"%d",numberOfContext];
    cell.numDefLabel.text = [NSString stringWithFormat:@"%d",[self.listOfDef count]];


    
    //Gets the word's dictionary information (that contains def, examples)
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)wordInformationTapped:(id)sender {
    
    //This method basically gets the section clicked. 
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    
    NSUInteger sectionNumber = [indexPath section];
    
    NSString *word = [ self.listOfWords objectAtIndex:sectionNumber];
    
    //Gets a word from the wordDict
    self.aWordDict = [self.wordDict objectForKey:word];
    
    self.selectedWord = self.aWordDict;
    
    self.selectedWordString = word;
    
    
        NSLog(@"section selected is %d", [indexPath section]);
    
    
        [self performSegueWithIdentifier:@"ShowWordInformation" sender:self];
}


#pragma mark -Deck View Controller Delegate
-(void)deckViewControllerDidFinish:(DeckViewController *)controller{
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Preparing for Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if([[segue identifier] isEqualToString:@"ShowWordInformation"]){
        
        WordDetailViewController *wordDetailViewController = [segue destinationViewController];
        wordDetailViewController.selectedWord = self.selectedWord;
        wordDetailViewController.selectedWordString = self.selectedWordString;
        
    }else if ([[segue identifier] isEqualToString:@"ShowFlashCard"]){
        NSLog(@"working");
        
        //CardViewController *cardViewController = [segue destinationViewController];
        
        //cardViewController.wordDict = self.wordDict;
        //cardViewController.listOfWords = self.listOfWords;
        
        
        //cardViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        //[self presentViewController:cardViewController animated:YES completion:nil];
        
    }
    
    
}

@end
