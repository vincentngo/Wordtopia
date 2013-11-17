//
//  WordOfTheDayViewController.m
//  Wordtopia
//
//  Created by Vincent Ngo on 11/20/12.
//  Copyright (c) 2012 Vincent Ngo. All rights reserved.
//

#import "WordOfTheDayViewController.h"
#import "TFHpple.h"
#import "WordDefinition.h"
#import "AppDelegate.h"
#import "WordParser.h"
#import "WordCell.h"
#import "AddWordToNoteBookViewController.h"
#import "WordDetailViewController.h"

@interface WordOfTheDayViewController ()

@end

@implementation WordOfTheDayViewController



- (void)viewDidLoad
{
    
    
    
    //Getting the current date today.
    NSDate *aDate = [NSDate date];
    NSDate *aDay = [NSDate date];
    
    NSDateFormatter* format = [[NSDateFormatter alloc]init];
    NSDateFormatter* format2 = [[NSDateFormatter alloc]init];
    NSDateFormatter* format3 = [[NSDateFormatter alloc]init];
    
    [format setDateFormat:@"/yyyy/M/dd/"];
    [format2 setDateFormat:@"dd"];
    
    
    
    
    NSString *day = [format2 stringFromDate: aDay];
    int dayConvertToInt = day.intValue;
    NSLog(@"day is %d", day.intValue);
    self.currentDate = [format stringFromDate:aDate];
    
    if (dayConvertToInt > 0 && dayConvertToInt != 1){
        if (dayConvertToInt > 10){
            [format3 setDateFormat:[NSString stringWithFormat:@"/yyyy/M/%d/",dayConvertToInt - 1]];
        }else{
               [format3 setDateFormat:[NSString stringWithFormat:@"/yyyy/M/0%d/",dayConvertToInt - 1]]; 
            }
        self.prevDate = [format3 stringFromDate:aDate];
    }
    
    NSLog(@"The prev date is: %@", self.prevDate);
    NSLog(@"The current date today is: %@", self.currentDate);
    
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"woodbg.png"]];
        
    self.parse = [[WordParser alloc]init];
    
    // [self.parse parseSound:@"michael"];
    //[self.parse parsePronouciationInformation:@"michael"];

  //  [self.parse parseAllDefinitionsForWord:@"sequacious" : @"sequacious"];
   // [self.parse parseAllExampleForWord:@"attack" :1];
// [self.parse parseAllExampleForWord:@"placate" :  1];
    
    //Obtain an object reference to the App Delegate object
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //data structure created in the App Delegate class
    self.wordOfDayDict = appDelegate.wordOfDayDict;
    
    //Gathers all the keys for a dictionary and put's it in the array.
    self.listOfWords = (NSMutableArray *)[[self.wordOfDayDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    
    
    for (int i = 0; i < [self.listOfWords count]; i++){
        NSLog(@"%@", [self.listOfWords objectAtIndex:i] );
    }

    
    
    //UNCOMMENT FOR GATHERING LIST
    
    //Gather words of the day from Dictionary.com
   // [self GatherListOfWordOfTheDayFromWebsite];
    
    //Going to build every word in this list and store it in wordOfDayDict
    //[self AddWordDictToDict:self.wordOfDayList];
    
    
        
    
   
    
    NSLog(@"list of words is %d", [self.listOfWords count]);
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)AddWordDictToDict: (NSMutableArray *)wordList{
    
    for (int i = 0; i < [wordList count]; i++){
        
        NSString *word = [wordList objectAtIndex:i];
        NSMutableDictionary *awordDict = [self.parse buildWord:word];
        if (awordDict != nil){
            if (![self.listOfWords containsObject:word]){
        [self.wordOfDayDict setObject:awordDict forKey:word];
            }
        }
    }
    
    
}


#pragma mark - Gathering words

// Problem: How to check for the latest word of the day, by checking the month and date.


//This basically html parses the dictionary.com website for their archive list of words of the day. Basically taking the first 8 words and stores them in an array.
//This method will only be used once when the user first launches the app.
//-(NSMutableArray *)GatherListOfWordOfTheDayFromWebsite{
    -(void)GatherListOfWordOfTheDayFromWebsite{
        
    //Getting a NSURL reference to the URL.
        //NSURL *tutorialsUrl = [NSURL URLWithString:@"http://dictionary.reference.com/"];
        NSURL *tutorialsUrl = [NSURL URLWithString:@"http://www.merriam-webster.com/word/archive.php"];
        
         //NSURL *tutorialsUrl = [NSURL URLWithString:@"http://www.dictionaryapi.com/api/v1/references/collegiate/xml/red?key=f0997a42-837f-4508-bcce-c5f246cf6a8c"];
        
       
    NSData *tutorialsHtmlData = [NSData dataWithContentsOfURL:tutorialsUrl];
    
    //
    TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:tutorialsHtmlData];
    
        
       //NSString *tutorialsXpathQueryString = @"//div[@id='prev-words']/ul/li/a";
        //NSString *tutorialsXpathQueryString = @"//div[@class='page_content_box']/table/tr";
        
        //Test query
         NSString *tutorialsXpathQueryStringTest = [NSString stringWithFormat:@"//a[@href='/word-of-the-day%@']", self.currentDate];
        

   // NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
        
        self.merriamNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryStringTest];
       // NSLog(@"tutorialNodes array size is %d", [tutorialsNodes count]);
        NSLog(@"tutorialNodesTest = %d", [self.merriamNodes count]);
        
         NSLog(@"tutorialNodes element is %d", [[[self.merriamNodes objectAtIndex:0] children] count]);
        
        if ( [[[self.merriamNodes objectAtIndex:0] children] count] == 0){
            NSString *tutorialsXpathQueryStringPrev = [NSString stringWithFormat:@"//a[@href='/word-of-the-day%@']", self.prevDate];
            self.merriamNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryStringPrev];
            
            NSLog(@"tutorialNodesTest = %d", [self.merriamNodes count]);
            
        }
        NSLog(@"tutorialNodes element is %@", [self.merriamNodes objectAtIndex:0]);
        //NSLog(@"tutorialNodes element is %@", [[[[merriamNodes objectAtIndex:0] children]objectAtIndex:0] content]);
        
        // 4Creates an array that holds all worddefinition objects and loop over the obtained nodes.
        self.wordOfDayList = [[NSMutableArray alloc] initWithCapacity:0];
        
        
        if ([self.merriamNodes count] != 0){
          
            NSString* aWord = [[[[self.merriamNodes objectAtIndex:0] children]objectAtIndex:0] content];

                    
                    //NSLog(@"ddddd %@", [[[[[tutorialsNodes objectAtIndex:i] children] objectAtIndex:1] children] objectAtIndex:0]);
                    
                   // NSLog(@"ddddd %@", [[[tutorialsNodes objectAtIndex:i] children] objectAtIndex:1]);
                    
                    
                    //Checks to see if a word exist in the dictionary by checking the key, if the key returns nil means it doesn't.
                    if ([self.wordOfDayDict objectForKey:aWord] == nil){
                        
                        [self.wordOfDayList addObject: aWord];
                        //[self.wordOfDayList addObject:@"attack"];
                    
                        NSLog(@"The new word of the day is %@", aWord);
                    }
                
                
            
            
            
        }
        
        
        //CAN ADD uh.. TOOLBAR HERE TO CHANGE THE NUMBER OF WORDS YOU CAN GET....
        
       /* if([tutorialsNodes count] != 0){
        for (int z = startSearch; z < 5; z++){
           NSString* aWord = [[[[[[[[tutorialsNodes objectAtIndex:z] children] objectAtIndex:1] children] objectAtIndex:0]children]objectAtIndex:0]content];
            
            [self.wordOfDayList addObject: aWord];
        }
        }*/
        
        //Testing multiple uses of context
        //[self.wordOfDayList addObject:@"attack"];
        
        //Testing purpose to see if I am getting all the list of previous word of the days.
        
        for (int i = 0; i < [self.wordOfDayList count]; i ++){
            NSLog(@"%@", [self.wordOfDayList objectAtIndex:i]);
        }

}

#pragma mark - UITableViewDataSOurce Protocol Methods
/*
 We are implementing a Grouped table view style. In the storyboard file,
 select the Table View. Under the Attributes Inspector, set the Style attribute to Grouped.
 */

// Each table view section corresponds to a country
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.listOfWords = (NSMutableArray *)[[self.wordOfDayDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSLog(@"size of listOfwords is: %d", [self.listOfWords count]);
    return [self.listOfWords count];
}

// There will be 1 row per word, to keep them spaced apart.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// Asks the data source to return a cell to insert in a particular table view location
- (WordCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger sectionNumber = [indexPath section];
    
    //Re update listOfwords, because new word of day added to wordOfDayDict.
    self.listOfWords = (NSMutableArray *)[[self.wordOfDayDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    NSString *word = [self.listOfWords objectAtIndex:sectionNumber];
    
    NSLog(@"word is : %@", word);
    
    //Gets the a particular word's dictionary
    self.wordDict = [self.wordOfDayDict objectForKey:word];
    
    NSNumber *numcontext = [self.wordDict objectForKey:@"number of context"];
    int numberOfContext = numcontext.intValue;
    //Gets the word's dictionary information (that contains def, examples)
    
    if (numberOfContext > 0)
    {
        NSString *wordMoreThanone = [NSString stringWithFormat:@"%@[%d]",word,1];
        self.wordDictToInfoDict = [self.wordDict objectForKey:wordMoreThanone];
    }else{
        self.wordDictToInfoDict = [self.wordDict objectForKey:word];
    }
    
    
    
    NSString *wordType = [self.wordDictToInfoDict objectForKey:@"type"];
    
    NSLog(@"wordType is %@", wordType);
    
    self.listOfDef = [self.wordDictToInfoDict objectForKey:@"definitions"];
    
    
    
    //Gets the date for a particular cell
    // NSString *date = [self.dates objectAtIndex:rowNumber];
    
    
    WordCell *cell = (WordCell *)[tableView dequeueReusableCellWithIdentifier:@"WordCellType"];
    
    cell.wordTitleLabel.text = word;
    cell.wordContextLabel.text = wordType;
    cell.wordsampleDefLabel.text = [self.listOfDef objectAtIndex:0];
    cell.numContextLabel.text = [NSString stringWithFormat:@"%d",numberOfContext];
    cell.numDefLabel.text = [NSString stringWithFormat:@"%d",[self.listOfDef count]];

    cell.wordsampleDefLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.wordsampleDefLabel.numberOfLines = 4;
    
    
    
        return cell;
}

#pragma mark UITableViewDelegate Protocol Methods

//Tapping a row (date) displays a new view with the points consumed.
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUInteger sectionNumber = [indexPath section];
    
    NSString *wordSelectedToAdd = [self.listOfWords objectAtIndex:sectionNumber];
    
    //Grabs a particular word from the root dictionary ( The word itself is also a dictionary)
    self.wordDict = [self.wordOfDayDict objectForKey:wordSelectedToAdd];
    
    self.selectedWordDictToAdd = self.wordDict;
    self.wordToAddKey = wordSelectedToAdd;
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    //Temporary here
    [self performSegueWithIdentifier:@"ShowNoteBookTableView" sender:self];
    
}

#pragma mark - Preparing for Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if([[segue identifier] isEqualToString:@"ShowNoteBookTableView"]){
        
        AddWordToNoteBookViewController *addWordToNoteBookViewController = [segue destinationViewController];
        
        addWordToNoteBookViewController.wordselectedToAdd = self.selectedWordDictToAdd;
        addWordToNoteBookViewController.wordKey = self.wordToAddKey;
        //notebookWordsViewController.delegate = self;
    }else if([[segue identifier] isEqualToString:@"ShowWordofDayInformation"]){
        
        WordDetailViewController *wordDetailViewController = [segue destinationViewController];
        wordDetailViewController.selectedWord = self.selectedWord;
        wordDetailViewController.selectedWordString = self.selectedWordString;
    }
}




//Adding in CellSelectedRowIndex something, to go to the notebookView



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (IBAction)showWordInformationButton:(id)sender {
    //This method basically gets the section clicked.
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    
    NSUInteger sectionNumber = [indexPath section];
    
    NSString *word = [ self.listOfWords objectAtIndex:sectionNumber];
    
    //Gets a word from the wordDict
    self.aWordDict = [self.wordOfDayDict objectForKey:word];
    
    self.selectedWord = self.aWordDict;
    
    self.selectedWordString = word;
    
    
    NSLog(@"section selected is %d", [indexPath section]);
    
    
    [self performSegueWithIdentifier:@"ShowWordofDayInformation" sender:self];
    
}
@end
