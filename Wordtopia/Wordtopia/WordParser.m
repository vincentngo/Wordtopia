//
//  WordParser.m
//  Wordtopia
//
//  This class parses any word, from the Merriam word XML.
//
//  Created by Vincent Ngo on 11/27/12.
//  Copyright (c) 2012 Vincent Ngo. All rights reserved.
//

#import "WordParser.h"
#import "WordDefinition.h"
#import "TFHpple.h"

@implementation WordParser

- (void)viewDidLoad{
    
}

/*This method creates a dictionary for a single word, that contains 2 things.
 *  1. The number of context (Tells us how many ways the word can be used)
 *  2. Based on the number of context we can have n context for The word's information dictionary which contains 3 things
 - The type (e.g. noun, adjective, verb etc)
 - An array of definitions
 - An array of examples
 
 This method returns a mutable dictionary that can be added to a plist
 
 
 */
-(NSMutableDictionary *)buildWord: (NSString *) aWord{
    
    //Finds and sets all the information for the word.
    
    //Word Dictionary bundle, containing information on the word,
    NSMutableDictionary *wordDict = [[NSMutableDictionary alloc] init];
    
    int numberOfContext = [self checkWordMoreThanOneType:aWord];
    NSNumber *numContext = [NSNumber alloc];
    numContext = [NSNumber numberWithInt:numberOfContext];
    
    [wordDict setObject:numContext forKey:@"number of context"];
    
    NSString *wordSoundFileName = [self parseSound:aWord];
    NSString *wordPronuciation = [self parsePronouciationInformation:aWord];
    //Add sound to dictionary
    if (wordSoundFileName != nil){
        [wordDict setObject:wordSoundFileName forKey:@"soundFile"];
    }
    //Add pronouciation to dictionary
    if (wordPronuciation != nil){
        [wordDict setObject:wordPronuciation forKey:@"pronunciation"];
    }
    
    if (numberOfContext == 0){
        
        WordDefinition *word = [self setDataForWord:aWord :aWord: 1];
        
        NSMutableDictionary *wordInfo = [self bundleInDictionary: word];
        if (wordInfo != nil){
        [wordDict setObject:wordInfo forKey:aWord];
        }
        
        //NSLog(@"size of dict is: %d" ,[wordDict count]);
        //NSMutableDictionary *test = [wordDict valueForKey:aWord];
        
        //NSLog(@"size of test is : %d" ,[test count]);
        
    }else{
        
        for (int i = 1; i <= numberOfContext; i++){
            
            NSString *wordcontext = [NSString stringWithFormat:@"%@[%d]",aWord,i];
            WordDefinition *word = [self setDataForWord:aWord :wordcontext: i];
            NSMutableDictionary *wordInfo = [self bundleInDictionary:word];
            if (wordInfo != nil){
            [wordDict setObject:wordInfo forKey:wordcontext];
            }
        }

    }
    
    return wordDict;
    
}

//This just sets all the data for a particular word, and returns the WordDefinition Object. Basically like initalizing a WordDefinition.
-(WordDefinition *)setDataForWord: (NSString *)aWord : (NSString *)contextWordnum: (int) numContext{
    
    WordDefinition *theWord = [[WordDefinition alloc] init];
    
    theWord.numContext = [self checkWordMoreThanOneType:aWord];
    
    theWord.wordTitle = aWord;
    
    theWord.wordContextNum = contextWordnum;
    
    theWord.wordType = [self getWordType:aWord: contextWordnum];
    
    theWord.definitionList = [self parseAllDefinitionsForWord:aWord: contextWordnum];
    
    theWord.exampleList = [self parseAllExampleForWord:aWord: numContext];
    
    //theWord.wordPronuciation = [self parsePronouciationInformation:aWord];
    
    //theWord.wordSoundFileName = [self parseSound:aWord];
    
    return theWord;
}


//Sets the word type, e.g. noun, verb, adjective etc for a WordDefinition Class.
-(NSString *)getWordType: (NSString *) aWord: (NSString *)contextWordnum{
    
    NSString *wordWithQuery = nil;
    
    NSString *type = nil;
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.dictionaryapi.com/api/v1/references/collegiate/xml/%@?key=f0997a42-837f-4508-bcce-c5f246cf6a8c", aWord];
    
    NSURL *tutorialsUrl = [NSURL URLWithString:urlString];
    
    NSData *tutorialsHtmlData = [NSData dataWithContentsOfURL:tutorialsUrl];
    
    TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:tutorialsHtmlData];
    
    // [!] This so far deals with the case that the word only has one context.
    
    //This case only deals with word that is only used in one context
    wordWithQuery = [NSString stringWithFormat:@"//entry[@id='%@']/fl", contextWordnum];
    
    NSString *tutorialsXpathQueryString = wordWithQuery;
    //NSString *tutorialsXpathQueryString = @"//entry[@id='red[1]']/def/dt";
    
    NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
    
    for (TFHppleElement *element in tutorialsNodes) {
        
        
        NSLog(@"the context of word is: %@", [[element firstChild] content]);
        
        type = [[element firstChild] content];
        
    }
    
    return type;
    
}

/*
 * This method, bundles all the information of the word in to a Mutable Dictionary. This will be used to add in to the plist files.
 */
-(NSMutableDictionary *)bundleInDictionary: (WordDefinition *)aWord{
    
    NSMutableDictionary *wordInformation = [[NSMutableDictionary alloc] init];
    
    //Add wordType in dictionary
    if (aWord.wordType != nil){
    [wordInformation setObject:aWord.wordType forKey:@"type"];
    }
    
    //Add definitionlist in dictionary
    if (aWord.definitionList != nil){
    [wordInformation setObject:aWord.definitionList forKey:@"definitions"];
    }
    
    //Add exampleList in dictionary
    if (aWord.exampleList != nil){
    [wordInformation setObject:aWord.exampleList forKey:@"examples"];
    }
    
    return wordInformation;
}


#pragma mark - Parsing Word definitions and Examples

-(NSMutableArray *)parseAllDefinitionsForWord: (NSString *) word: (NSString *)contentWordnum{
    
    NSString *wordWithQuery = nil;
    //int numberOfContextForWord = [self checkWordMoreThanOneType:word.wordTitle];
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.dictionaryapi.com/api/v1/references/collegiate/xml/%@?key=f0997a42-837f-4508-bcce-c5f246cf6a8c", word];
    
    NSURL *tutorialsUrl = [NSURL URLWithString:urlString];
    
    NSData *tutorialsHtmlData = [NSData dataWithContentsOfURL:tutorialsUrl];
    
    TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:tutorialsHtmlData];
    
    // [!] This so far deals with the case that the word only has one context.
    
    //This case only deals with word that is only used in one context
    wordWithQuery = [NSString stringWithFormat:@"//entry[@id='%@']/def/dt | //entry[@id='%@']/def/dt/sx", contentWordnum,contentWordnum];
    
    NSString *tutorialsXpathQueryString = wordWithQuery;
    //NSString *tutorialsXpathQueryString = @"//entry[@id='red[1]']/def/dt";
    
    NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
    NSLog(@"tutorialNodes array size is %d", [tutorialsNodes count]);
    
    
    //NSLog(@"tutorial nOde element %@", [tutorialsNodes objectAtIndex:0]);
    if ([tutorialsNodes count] == 0){
        return nil;
    }
    
    // 4Creates an array that holds all worddefinition objects and loop over the obtained nodes.
    NSMutableArray *definitionList = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (TFHppleElement *element in tutorialsNodes) {
        
        
        NSLog(@"the definition is %@", [[element firstChild] content]);
        
        NSString *adefinition = [[element firstChild] content];
        
        if((adefinition != nil)){
            if (![adefinition isEqualToString:@":"]){
            [definitionList addObject:adefinition];
            }
        }
        
    }
    return definitionList;
}

//Since Merriam didn't provide an API to grab the Example, I had to do some html parsing on their website to grab the different examples.

-(NSMutableArray *) parseAllExampleForWord: (NSString *)aWord: (int)numContext{
    
    //int numberOfContextForWord = [self checkWordMoreThanOneType:word.wordTitle];
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.merriam-webster.com/dictionary/%@", aWord];
    
    NSURL *tutorialsUrl = [NSURL URLWithString:urlString];
    
    NSData *tutorialsHtmlData = [NSData dataWithContentsOfURL:tutorialsUrl];
    
    TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:tutorialsHtmlData];
    
    // [!] This so far deals with the case that the word only has one context.
    
    
    NSString *tutorialsXpathQueryString = @"//div[@class='example-sentences']";
    //| //div[@class='example-sentences']/li[@class='always-visible']/em";
    
    //NSString *tutorialsXpathQueryString = @"//entry[@id='red[1]']/def/dt";
    
    NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
    NSLog(@"tutorialNodes array size is %d", [tutorialsNodes count]);
    
    if ([tutorialsNodes count] == 0){
        return nil;
    }
    
    NSMutableArray *exampleList = [[NSMutableArray alloc] initWithCapacity:0];
    
    if ([tutorialsNodes count] != 0){
        
        
        for (int p = 0; p < [tutorialsNodes count]; p++){
        
        NSLog(@"tutorialNodes element is %@", [tutorialsNodes objectAtIndex:p]);
            
        }
    // 4Creates an array that holds all worddefinition objects and loop over the obtained nodes.
    
    /*for (int a = 0; a < [tutorialsNodes count]; a++){
     NSLog(@"%@",[tutorialsNodes objectAtIndex: a]);
     }*/
    
        if (numContext  < [tutorialsNodes count] + 1){
    
    //The index here tells you which context example is for. [Here is where you should change the variable, depending if its cool[1], or cool[2] or cool[3]
    
    NSArray *testing = [[tutorialsNodes objectAtIndex:numContext - 1] children];
    //NSLog(@"%@",[testing objectAtIndex:2]);
    
    //Jumps from Node KonaBody to list of /li nodes, and every example node is seperated by 2 other XML information. So we have to skip 2 times in the array to get the array example items.
            
    NSArray *testing2 = [[[[testing objectAtIndex:2] children]objectAtIndex:0] children];
           // NSLog(@"%@",[[[[testing objectAtIndex:2] children]objectAtIndex:0] content]);
    
    NSString *exampleWord = @"";
    
    for (int a = 0; a < [testing2 count]; a = a + 2){
        //NSLog(@"%@", [testing2 objectAtIndex:a]);
        
        
        NSArray *testing3 = [[testing2 objectAtIndex:a] children];
        
        NSLog(@"Word is %d", [testing3 count]);
        
        //NSLog(@"testing3 index 1 size is %d", [[[testing3 objectAtIndex: 1] children]count ]);
        
        for (int i = 0; i < [testing3 count]; i++){
            //TESTING
           // NSLog(@"%d", [[[testing3 objectAtIndex: 1] children]count ]);
            
            /*for (int l = 0; l < [testing3 count]; l++){
                if ([[[testing3 objectAtIndex:l]children]count] != 0){
                NSLog(@"%@",[[[[testing3 objectAtIndex:l]children]objectAtIndex:0]content]);
                }
            }*/
                  
                  
                  
                  ///---------------
            if (i != 1){
                //NSLog(@"%@", [[testing3 objectAtIndex:i]content]);
                if ([[testing3 objectAtIndex:i]content] == NULL){
                    continue;
                }
                exampleWord = [exampleWord stringByAppendingFormat:@"%@",[[testing3 objectAtIndex:i]content]];
                
                //if ([[[testing3 objectAtIndex:i]children]count] != 0){
                //exampleWord = [exampleWord stringByAppendingFormat:@"%@",[[[[testing3 objectAtIndex:i]children]objectAtIndex:0]content]];
                //}
            }else if([[[testing3 objectAtIndex: 1] children]count ] != 0){
                //NSLog(@"%@", [[[[testing3 objectAtIndex: 1] children] objectAtIndex:0]content]);
                exampleWord = [exampleWord stringByAppendingFormat:@"%@", [[[[testing3 objectAtIndex: 1] children] objectAtIndex:0]content]];
            }else{
                exampleWord = [exampleWord stringByAppendingFormat:@"%@",[[testing3 objectAtIndex:i]content]];
            }
        }
        
        [exampleList addObject: exampleWord];   //Add the combined nodes to form an example sentence.
        
            
            
        exampleWord = @"";                      //Reset the exampleWord for the next oen in the array.
        
        //NSLog(@"%@", exampleWord);
    }
    
        for (int z = 0; z < [exampleList count]; z++){
        
            NSLog(@"%@",[exampleList objectAtIndex: z]);
        
            }
    }
    }

    return exampleList;
    
}

#pragma mark - Pronouciation and Sound Waves

-(NSString *) parseSound: (NSString *) word{
    
    
    //Testing different cases of the wav URL sound directory.
    /*[self parseMerriamSoundURL:@"0123baby1moretime.wav"];
     [self parseMerriamSoundURL:@"123baby.wav"];
     [self parseMerriamSoundURL:@"ggboyboy.wav"];
     [self parseMerriamSoundURL:@"bixwax.wav"];
     [self parseMerriamSoundURL:@"apple.wav"];*/
    
    //[self parseMerriamSoundURL:@"a000001.wav"];
    
    NSString *wordWithQuery = nil;
    NSString *urlString = [NSString stringWithFormat:@"http://www.dictionaryapi.com/api/v1/references/collegiate/xml/%@?key=f0997a42-837f-4508-bcce-c5f246cf6a8c", word];
    
    NSURL *tutorialsUrl = [NSURL URLWithString:urlString];
    
    NSData *tutorialsHtmlData = [NSData dataWithContentsOfURL:tutorialsUrl];
    
    TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:tutorialsHtmlData];
    
    // [!] This so far deals with the case that the word only has one context.
    
    //This case only deals with word that is only used in one context
    wordWithQuery = @"//wav";
    
    NSString *tutorialsXpathQueryString = wordWithQuery;
    
    NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
    NSLog(@"tutorialNodes array size is %d", [tutorialsNodes count]);
    
    if ([tutorialsNodes count] != 0){
        
        NSLog(@"tutorial nOde element %@", [[[[tutorialsNodes objectAtIndex:0]children]objectAtIndex:0]content]);   //Test to see I got the right node information
        
        self.wavFileName = [[[[tutorialsNodes objectAtIndex:0]children]objectAtIndex:0]content];
        self.wavFileName = [self parseMerriamSoundURL:self.wavFileName];
        NSLog(@"wav file final is: %@", self.wavFileName);
        
    }
    
    return self.wavFileName;
    
}

-(NSString *) parsePronouciationInformation: (NSString *) word{
    
    NSString *wordWithQuery = nil;
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.dictionaryapi.com/api/v1/references/collegiate/xml/%@?key=f0997a42-837f-4508-bcce-c5f246cf6a8c", word];
    
    NSURL *tutorialsUrl = [NSURL URLWithString:urlString];
    
    NSData *tutorialsHtmlData = [NSData dataWithContentsOfURL:tutorialsUrl];
    
    TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:tutorialsHtmlData];
    
    // [!] This so far deals with the case that the word only has one context.
    
    //This case only deals with word that is only used in one context
    wordWithQuery = @"//pr";
    
    NSString *tutorialsXpathQueryString = wordWithQuery;
     
    NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
    NSLog(@"tutorialNodes array size is %d", [tutorialsNodes count]);
    
    if ([tutorialsNodes count] != 0){
        
        NSLog(@"tutorial nOde element %@", [[[[tutorialsNodes objectAtIndex:0]children]objectAtIndex:0]content]);   //Test to see I got the right node information
        
        self.pronouciationWord = [[[[tutorialsNodes objectAtIndex:0]children]objectAtIndex:0]content];
        NSLog(@"the correction pronouciation is: %@", self.pronouciationWord);
        
    }

    return self.pronouciationWord;
    
} 

-(NSString *) parseMerriamSoundURL:(NSString *)fileName{
    
    NSString *urlBase = @"http://media.merriam-webster.com/soundc11/";
    
    
    if ([fileName length] > 3){
        
        //Checks if the first 3 characters in the string is equal to bix, then set the subdirectory to be bix
        if ([[fileName substringWithRange:NSMakeRange(0, 3)] isEqualToString:@"bix"]){
            
            urlBase = [urlBase stringByAppendingString:[NSString stringWithFormat:@"bix/%@",fileName]];
            
            //Checks if the first 2 characters in the string is equal to gg, then set the sub directory to be gg
        }else if ([[fileName substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"gg"]){
            
            urlBase = [urlBase stringByAppendingString:[NSString stringWithFormat:@"gg/%@",fileName]];
            
            //If the wav file starts with a zero, deals with the case where chracters that are converted to int that is not a numeric value will also return zero. So we check the string contents
        }else if ([[fileName substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"]){
            
            NSString *directoryName = [self checkIfThereIsANumberInFrontOfWavFile:fileName];
            urlBase = [urlBase stringByAppendingString:[NSString stringWithFormat:@"%@/%@", directoryName,fileName]];
        
            //Checks to see if the intValue of the character is equal to zero, if it does means this is not a number infront.
        }else if ([[fileName substringWithRange:NSMakeRange(0, 1)] intValue] == 0){
            NSString *directoryName = [fileName substringWithRange:NSMakeRange(0, 1)];
            urlBase = [urlBase stringByAppendingString:[NSString stringWithFormat:@"%@/%@", directoryName, fileName]];
            
            //Means there is digits in front of the wav file besides 0
        }else if ([[fileName substringWithRange:NSMakeRange(0, 1)]intValue] != 0){
            
            NSString *directoryName = [self checkIfThereIsANumberInFrontOfWavFile:fileName];
            urlBase = [urlBase stringByAppendingString:[NSString stringWithFormat:@"%@/%@", directoryName, fileName]];
            
        }
        
        NSLog(@"final url for wav file: %@", urlBase);
    }
    return urlBase;
}


//Check to see if there is a number in front of the wav file. If there is we need to change the directory of the file.
-(NSString *)checkIfThereIsANumberInFrontOfWavFile: (NSString *)fileName{
    
    NSString *numberString = @"";
    
    for (int i = 0; i < [fileName length]; i++){
        
        //This gets the next index everytime, and stores that 1 character in to a string.
        NSString *aCharacter = [NSString stringWithFormat:@"%c",[fileName characterAtIndex:i]];
        
        //Well we need to consider the case when the first number a zero, because if we check if a character is not a number it will return zero so we need to take care of this case.
        if ([aCharacter isEqualToString:@"0"]){
            numberString = [numberString stringByAppendingString:aCharacter];
            continue;
        }
        
        if ([aCharacter intValue] != 0){
            
            numberString = [numberString stringByAppendingString:aCharacter];
        }else{
            break;  // If we don't find another number, just break out of the whole loop, and return....
        }
    }
    
    NSLog(@"number is: %@",numberString);
    return numberString;
    
}


//This method helps check if the word has different definition meanings. There can be many different means for example the word "RED" Some dictionary API distinguish different RED types with red[1] and red[2] with different definitions. This method returns the number of different meanings the word can have.

//For example:

// climacteric[1]         entry[@id='climacteric[1]'] or entry[@id='climacteric[2]']

-(int)checkWordMoreThanOneType: (NSString *)word{
    
    int count = 0;
    int numberOfwordWithDifferentmeaning = 1;
    bool check = NO;
    //With Merriam Website API key, get the xml format of all definitions and examples
    NSString *urlString = [NSString stringWithFormat:@"http://www.dictionaryapi.com/api/v1/references/collegiate/xml/%@?key=f0997a42-837f-4508-bcce-c5f246cf6a8c", word];
    
    NSURL *tutorialsUrl = [NSURL URLWithString:urlString];
    
    NSData *tutorialsHtmlData = [NSData dataWithContentsOfURL:tutorialsUrl];
    
    TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:tutorialsHtmlData];
    
    while(check == NO)
    {
        NSString *tutorialsXpathQueryString = [NSString stringWithFormat:@"//entry[@id='%@[%d]']/def/dt", word, numberOfwordWithDifferentmeaning];
        
        numberOfwordWithDifferentmeaning++;
        
        NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
        
        //If the count is null, means theres only 1 meaning for that word
        if([tutorialsNodes count] == 0){
            check = YES;
            return count;
        }else{
            
            count++;
        }
        
    }
    
    //Returns the number of different meanings a word can have.
    return count;
    
}



-(NSMutableArray *)getSuggestedWords:(NSString *)wordEntered{
    
    NSString *wordWithQuery = nil;
    
    NSString *checkSpaces = [wordEntered stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.dictionaryapi.com/api/v1/references/collegiate/xml/%@?key=f0997a42-837f-4508-bcce-c5f246cf6a8c", checkSpaces];
    
    NSURL *tutorialsUrl = [NSURL URLWithString:urlString];
    
    NSData *tutorialsHtmlData = [NSData dataWithContentsOfURL:tutorialsUrl];
    
    TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:tutorialsHtmlData];
    
    // [!] This so far deals with the case that the word only has one context.
    
    //This case only deals with word that is only used in one context
    wordWithQuery = @"//suggestion";
    
    NSString *tutorialsXpathQueryString = wordWithQuery;
    
    NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
    NSLog(@"tutorialNodes array size is %d", [tutorialsNodes count]);

    //NSLog(@"tutorialNodes element %@", [[[tutorialsNodes objectAtIndex:0]firstChild]content]);
    NSMutableArray *suggestedWordList = [[NSMutableArray alloc]init];
    
    NSString *suggestedWord;
    if ([tutorialsNodes count] != 0){
    for (int i = 0; i < [tutorialsNodes count]; i++){
        suggestedWord = [[[tutorialsNodes objectAtIndex:i]firstChild]content];
        
        //Merriam uses lower case, and to make our job more hectic... We need to convert the first character to lower case because they don't support uppercase searching... =(
        NSString *stringToLowerCase = [suggestedWord lowercaseString];
    
        
        NSLog(@"suggestedWord is %@", stringToLowerCase);
        [suggestedWordList addObject:stringToLowerCase];
    }
    }else if ([self checkWordExist:checkSpaces] == NO){
        
        //suggestedWord = [wordEntered lowercaseString];
        suggestedWord = @"No word found";
        [suggestedWordList addObject:suggestedWord];
    
    }else{
        [suggestedWordList addObject:checkSpaces];
    }
    
    
    return suggestedWordList;
    
    
}


-(BOOL)checkWordExist:(NSString *) word{
    NSString *wordWithQuery = nil;
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.dictionaryapi.com/api/v1/references/collegiate/xml/%@?key=f0997a42-837f-4508-bcce-c5f246cf6a8c", word];
    
    NSURL *tutorialsUrl = [NSURL URLWithString:urlString];
    
    NSData *tutorialsHtmlData = [NSData dataWithContentsOfURL:tutorialsUrl];
    
    TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:tutorialsHtmlData];
    
    // [!] This so far deals with the case that the word only has one context.
    
    //This case only deals with word that is only used in one context
    wordWithQuery = @"//dt";
    
    NSString *tutorialsXpathQueryString = wordWithQuery;
    
    NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
    NSLog(@"tutorialNodes array size is %d", [tutorialsNodes count]);
    
    if ([tutorialsNodes count] != 0){
        return YES;
    }
    return NO;
}


@end
