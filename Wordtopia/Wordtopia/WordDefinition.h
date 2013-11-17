//
//  WordDefinition.h
//  Wordtopia
//
//  Created by Vincent Ngo on 11/20/12.
//  Copyright (c) 2012 Vincent Ngo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordDefinition : NSObject

//Stores the word
@property (nonatomic, copy)NSString *wordTitle;
@property (nonatomic, copy)NSString *wordContextNum;

//Stores all the defintions in this array
@property (nonatomic, strong) NSMutableArray *definitionList;

//Stores all the examples in this array
@property (nonatomic, strong) NSMutableArray *exampleList;

//Stores the type of word, e.g. adjective, noun, verb, adverb etc.
@property (nonatomic, strong) NSString *wordType;

//Number of context
@property (nonatomic)int numContext;

//Word pronouciation
@property (nonatomic, strong) NSString *wordPronuciation;

//Gets the word's wav file to be parsed.
@property (nonatomic, strong) NSString *wordSoundFileName;

@end
