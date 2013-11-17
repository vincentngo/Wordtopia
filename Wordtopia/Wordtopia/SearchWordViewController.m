//
//  SearchWordViewController.m
//  Wordtopia
//
//  Created by Vincent Ngo on 12/15/12.
//  Copyright (c) 2012 Vincent Ngo. All rights reserved.
//

#import "SearchWordViewController.h"
#import "WordEntryCell.h"
#import "WordDetailViewController.h"

@interface SearchWordViewController ()

@end

@implementation SearchWordViewController

- (void)viewDidLoad
{
    
     self.parse = [[WordParser alloc]init];
    
    UIImage *toolbarImage = [UIImage imageNamed:@"tool-bar.png"];
    [self.toolBar setBackgroundImage:toolbarImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    self.suggestedWordList = [[NSMutableArray alloc]init];
    
   // [self.parse getSuggestedWords:@"wow man"];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}



#pragma mark - UITableViewDataSource Protocol Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.suggestedWordList count];
}

-(WordEntryCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUInteger rowNumber = [indexPath row];
    
    NSString *word = [self.suggestedWordList objectAtIndex:rowNumber];
    
       WordEntryCell *cell = (WordEntryCell *)[tableView dequeueReusableCellWithIdentifier:@"SuggestCellType"];
    
    cell.wordSuggestedLabel.text = word;
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSUInteger rowNumber = [indexPath row];
    
    NSString *word = [self.suggestedWordList objectAtIndex:rowNumber];
    
    //The buildWord method, is a method that i made that gathers all the data
    //related to the particular word, and puts it in an NSMutableDictionary format
    //to be inserted in to the WordDetaiLViewController
    NSMutableDictionary *wordDict = [self.parse buildWord:word]
    ;
    
    self.selectedWordString = word;
    self.selectedWord = wordDict;
    
    [self performSegueWithIdentifier:@"ShowDetailView" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}




//Updates the contents of the tableview, based on every stroke of the user. (This part is so awesome)
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.suggestedWordList = [self.parse getSuggestedWords:newString];
    
    [self.searchTableView reloadData];
    
    return YES;
}



#pragma mark - Preparing for Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if([[segue identifier] isEqualToString:@"ShowDetailView"]){
        
        WordDetailViewController *wordDetailViewController = [segue destinationViewController];
        wordDetailViewController.selectedWord = self.selectedWord;
        wordDetailViewController.selectedWordString = self.selectedWordString;
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)keyboardDone:(id)sender {
    self.suggestedWordList = [self.parse getSuggestedWords:self.wordEnteredField.text];
    
    [self.searchTableView reloadData];
     [sender resignFirstResponder];  // Deactivate the keyboard
}
- (IBAction)searchButton:(id)sender {
    
    self.suggestedWordList = [self.parse getSuggestedWords:self.wordEnteredField.text];
    
    [self.wordEnteredField resignFirstResponder];
    
    [self.searchTableView reloadData];
}
@end
