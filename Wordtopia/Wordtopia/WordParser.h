//
//  WordParser.h
//  Wordtopia
//
//  Created by Vincent Ngo on 11/27/12.
//  Copyright (c) 2012 Vincent Ngo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WordParser : NSObject


-(NSMutableDictionary *)buildWord: (NSString *) aWord;

-(NSMutableArray *) parseAllExampleForWord: (NSString *)aWord: (int)numContext;
-(NSMutableArray *)parseAllDefinitionsForWord: (NSString *) word: (NSString *)contentWordnum;

-(NSMutableArray *)getSuggestedWords:(NSString *)wordEntered;

-(BOOL)checkWordExist:(NSString *) word;


-(NSString *) parseSound: (NSString *) word;
-(NSString *) parsePronouciationInformation: (NSString *) word;


@property (strong,nonatomic) NSString *pronouciationWord;

@property (strong, nonatomic) NSString *wavFileName;


@end
