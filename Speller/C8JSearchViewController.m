//
//  C8JSearchViewController.m
//  Speller
//
//  Created by liulei on 2/14/13.
//  Copyright (c) 2013 cool8jay. All rights reserved.
//

#import "C8JSearchViewController.h"
#import "C8JAppDelegate.h"
#import "SVProgressHUD.h"
#import "C8JTableViewCell.h"

@interface C8JSearchViewController ()

@end

@implementation C8JSearchViewController

@synthesize searchMode;

- (id)initWithSearchMode:(SearchMode)aSearchMode{
    self = [super init];
    if (self) {
        searchMode = aSearchMode;
        transitionMode = TransitionModeNormalToReference;
        NSString *title;
        NSString *introContent;
        UIImage *image;
        if(SearchModeCrossword == searchMode){
            title = NSLocalizedString(@"crossword", nil);
            image = [UIImage imageNamed:@"image-1"];
            introContent = @"<font size = 22 face='Baskerville-SemiBold' color = '#573821'>\nCrossword\n</font>"
            "<font size = 16 face='Baskerville-Italic' color = '#573821'>Search for fixed-sequence word.\n\n"
            "<font size = 18 face='Baskerville' color = '#573821'>use question(?) or asterisk(*) symbol to indicate missing characters, for example:\n\n"
            "<p indent=15>1. \"?g??d?\" will match words with 4 missing character, or \"1g2d1\" for short. The result is \"agenda\".\n\n"
            "2. \"g*d\" will match words with unknown amount of missing characters.</p></font>";
        }else{
            title = NSLocalizedString(@"spell", nil);
            image = [UIImage imageNamed:@"image-2"];
            introContent = @"<font size = 22 face='Baskerville-SemiBold' color = '#573821'>\nSpell\n</font>"
            "<font size = 16 face='Baskerville-Italic' color = '#573821'>Search for unknown-sequence word.\n\n"
            "<font size = 18 face='Baskerville' color = '#573821'>Just input characters you need.";
        }
        self.title = title;
        self.tabBarItem.image = image;
        CGRect bound = [[UIScreen mainScreen] bounds] ;
        searchBar = [[C8JSearchBar alloc] initWithFrame:CGRectMake(0, 0, bound.size.width, 0)];
        searchBar.delegate = self;
        
        searchResultsTableView = [[UITableView alloc] init];
        searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        searchResultsTableView.delegate = self;
        searchResultsTableView.dataSource = self;
        
        searchResultsTableView.backgroundColor = BackgroundColor;
        
        searchResultsTableView.hidden = YES;
        
        //        searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar
        //                                                                    contentsController:self];
        //        searchDisplayController.delegate = self;
        //        searchDisplayController.searchResultsDataSource =self;
        //        searchDisplayController.searchResultsDelegate = self;
        ////        searchDisplayController.searchContentsController.view.backgroundColor = BackgroundColor;
        //        searchDisplayController.searchResultsTableView.backgroundView.backgroundColor = BackgroundColor;
        //        searchDisplayController.searchResultsTableView.backgroundColor = BackgroundColor;
        
        introLabel = [[RCLabel alloc] init];
        
        NSMutableDictionary *introData = [NSMutableDictionary dictionary];
        
        [introData setObject:introContent forKey:@"text"];
        
        RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:[introData objectForKey:@"text"]];
        introLabel.componentsAndPlainText = componentsDS;
        
        indexedSearchResult = [NSMutableDictionary dictionary];
        searchResultTitleArray = [NSMutableArray array];
        searchResults = [NSMutableArray array];
        
        
        allAllowedLettersArray = [NSMutableArray array];
        NSString *allAllowedLettersString = @"abcdefghijklmonpqrstuvwxyz";
        [allAllowedLettersString enumerateSubstringsInRange:NSMakeRange(0, [allAllowedLettersString length])
                                                    options:(NSStringEnumerationByComposedCharacterSequences)
                                                 usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                                     [allAllowedLettersArray addObject:substring];
                                                 }];
    }
    return self;
}

- (void)arrangeView{
    searchBar.frame = CGRectMake(0, 0, self.view.width, searchBar.height);
    C8JAppDelegate *delegate = (C8JAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    contentView.frame = CGRectMake(0,
                                   searchBar.bottom,
                                   self.view.width,
                                   self.view.height-searchBar.height-delegate.tabBarController.tabBarHeight);
    
    searchResultsTableView.frame = CGRectMake(0,
                                              0,
                                              contentView.width,
                                              contentView.height);
    
    introLabel.frame = CGRectMake(0,0,self.view.frame.size.width,400);
    
    [self.view addSubview:contentView];
    [self.view addSubview:searchBar];
    [contentView addSubview:introLabel];
    [contentView addSubview:searchResultsTableView];
}

- (void)beginAppearanceTransition:(BOOL)isAppearing animated:(BOOL)animated{
    NSLog(@"B");
    
    if(!isReferenceLibraryShown && needHidingReference){
        //        C8JAppDelegate *delegate = (C8JAppDelegate*)[[UIApplication sharedApplication] delegate];
        //        [[delegate tabBarController] hideTabBar:3 animated:YES];
        //        isReferenceLibraryShown = YES;
        //        needShowingReference = NO;
        //        needHidingReference = YES;
    }else{
        //  C8JAppDelegate *delegate = (C8JAppDelegate*)[[UIApplication sharedApplication] delegate];
        //  [[delegate tabBarController] showTabBar:3 animated:YES];
    }
}

- (void)endAppearanceTransition{
    NSLog(@"E");
    
    if(isReferenceLibraryShown && needHidingReference){
        //       C8JAppDelegate *delegate = (C8JAppDelegate*)[[UIApplication sharedApplication] delegate];
        //       [[delegate tabBarController] hideTabBar:3 animated:YES];
        
        //        C8JAppDelegate *delegate = (C8JAppDelegate*)[[UIApplication sharedApplication] delegate];
        //        [[delegate tabBarController] showTabBar:3 animated:YES];
        //        isReferenceLibraryShown = NO;
        //        needShowingReference = YES;
        //        needHidingReference = NO;
    }else{
        //        C8JAppDelegate *delegate = (C8JAppDelegate*)[[UIApplication sharedApplication] delegate];
        //        [[delegate tabBarController] showTabBar:3 animated:YES];
        //        isReferenceLibraryShown = YES;
    }
    
    
    //    NSLog(@"self.view=%@",self.view);
    //    NSLog(@"self.view.superview=%@",self.view.superview);
    //    NSLog(@"self.view.superview.subviews=%@",self.view.superview.subviews);
}

- (void)viewWillDisappear:(BOOL)animated{
    
    NSLog(@"D");
}

- (void)viewWillAppear:(BOOL)animated{
    isReferenceLibraryShown = NO;
    //    C8JAppDelegate *delegate = (C8JAppDelegate*)[[UIApplication sharedApplication] delegate];
    //    [[delegate tabBarController] showTabBar:2 animated:YES];
    //
    NSLog(@"A");
}

- (UIButton*)createButtonWithAction:(SEL)pAction
                             target:(id)pTarget
{
	UIButton *button = [[UIButton alloc] init];
	UIImage *buttonImage = nil;
	UIImage *buttonHighlightImage = nil;
	UIImage *buttonSelectedImage = nil;
	
    buttonImage = [UIImage imageNamed:@"button_blue_small.png"];
    buttonHighlightImage = [UIImage imageNamed:@"button_blue_small_p.png"];
    
    
	button.exclusiveTouch = YES;
	
	[button setBackgroundImage:buttonImage forState:UIControlStateNormal];
	[button setBackgroundImage:buttonHighlightImage forState:UIControlStateHighlighted];
	[button setBackgroundImage:buttonSelectedImage forState:UIControlStateSelected];
	
	[button addTarget:pTarget action:pAction forControlEvents:UIControlEventTouchUpInside];
	
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
	
	return button;
}

-(void)switchToSpellPage:(id)sender{
    searchMode = SearchModeSpell;
    
    [spellButton setSelected:YES];
    [crosswordButton setSelected:NO];
    [infoButton setSelected:NO];
}

-(void)switchToCrosswordPage:(id)sender{
    searchMode = SearchModeCrossword;
    
    [spellButton setSelected:NO];
    [crosswordButton setSelected:YES];
    [infoButton setSelected:NO];
}

-(void)switchToInfoPage:(id)sender{
    [spellButton setSelected:NO];
    [crosswordButton setSelected:NO];
    [infoButton setSelected:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = BackgroundColor;
    
    contentView = [[UIScrollView alloc] init];
    contentView.backgroundColor = BackgroundColor;
    
    spellButton = [self createButtonWithAction:@selector(switchToSpellPage:)
                                        target:self];
    
    crosswordButton = [self createButtonWithAction:@selector(switchToCrosswordPage:)
                                            target:self];
    
    infoButton = [self createButtonWithAction:@selector(switchToInfoPage:)
                                       target:self];
    
//    [self.view addSubview:spellButton];
//    [self.view addSubview:crosswordButton];
//    [self.view addSubview:infoButton];
    
    [self arrangeView];
}

NSComparisonResult stringSortByNumber(id str1, id str2, void *context) {
    if([str1 intValue]>[str2 intValue]){
        return NSOrderedAscending;
    }else if([str1 intValue]<[str2 intValue]){
        return NSOrderedDescending;
    }else{
        return NSOrderedSame;
    }
}

NSComparisonResult stringSortByAlphabet(id str1, id str2, void *context) {
    return [str1 caseInsensitiveCompare:str2];
}

- (void)populateKeyArray{
    for (NSString *key in [indexedSearchResult allKeys]) {
        int v = [[indexedSearchResult valueForKey:key] count];
        if(v>0){
            [searchResultTitleArray addObject:key];
        }
    }
    
    if(SearchModeCrossword == searchMode){
        searchResultTitleArray = [NSMutableArray arrayWithArray:[searchResultTitleArray sortedArrayUsingFunction:stringSortByAlphabet context:NULL]];
    }else{
        searchResultTitleArray = [NSMutableArray arrayWithArray:[searchResultTitleArray sortedArrayUsingFunction:stringSortByNumber context:NULL]];
    }
    
    if([searchResultTitleArray count]>0){
        isKeyArrayPopulated = YES;
    }
}

- (NSString*)replace:(NSString*)searchText{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\d+" options:0 error:&error];
    
    NSTextCheckingResult *result = [regex firstMatchInString:searchText
                                                     options:NSMatchingReportProgress
                                                       range:NSMakeRange(0, [searchText length])];
    
    NSRange matchRange = [result range];
    NSMutableString *stringToReplace = [NSMutableString stringWithString:@""];
    
    int number = [[searchText substringWithRange:matchRange]intValue];
    for (int i=0;i<number; i++) {
        [stringToReplace appendString:@"?"];
    }
    
    searchText = [searchText stringByReplacingCharactersInRange:matchRange withString:stringToReplace];
    
    if([self isMatch:searchText]){
        return [self replace:searchText];
    }else{
        return searchText;
    }
}

-(BOOL)isMatch:(NSString*)searchText{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\d+" options:0 error:&error];
    
    NSArray *matches = [regex matchesInString:searchText
                                      options:NSMatchingReportProgress
                                        range:NSMakeRange(0, [searchText length])];
    
    return [matches count]>0;
}

-(BOOL)hasNumber:(NSString*)searchText{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\d+" options:0 error:&error];
    
    NSArray *matches = [regex matchesInString:searchText
                                      options:NSMatchingReportProgress
                                        range:NSMakeRange(0, [searchText length])];
    
    return [matches count]>0;
}

- (NSString*)replaceNumber:(NSString*)searchText{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\d+" options:0 error:&error];
    
    NSTextCheckingResult *result = [regex firstMatchInString:searchText
                                                     options:NSMatchingReportProgress
                                                       range:NSMakeRange(0, [searchText length])];
    
    NSRange matchRange = [result range];
    NSMutableString *stringToReplace = [NSMutableString stringWithString:@""];
    
    int number = [[searchText substringWithRange:matchRange]intValue];
    for (int i=0;i<number; i++) {
        [stringToReplace appendString:@"?"];
    }
    
    searchText = [searchText stringByReplacingCharactersInRange:matchRange withString:stringToReplace];
    
    if([self hasNumber:searchText]){
        return [self replaceNumber:searchText];
    }else{
        return searchText;
    }
}

-(void)categorizeWordsByLength{
    for (NSString *word in searchResults) {
        int length = [word length];
        NSString *keyAsLength = [NSString stringWithFormat:@"%d",length];
        
        if(![indexedSearchResult valueForKey:keyAsLength]){
            NSMutableArray *arrayWithLength = [NSMutableArray array];
            [arrayWithLength addObject:word];
            [indexedSearchResult setValue:arrayWithLength forKey:keyAsLength];
        }else{
            NSMutableArray *arrayWithLength = (NSMutableArray*)[indexedSearchResult valueForKey:keyAsLength];
            [arrayWithLength addObject:word];
        }
    }
}

-(void)categorizeWordsByAlphabet{
    NSArray *characterArray = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",
                                @"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    
    for (NSString *prefix in characterArray) {
        NSPredicate *resultPredicate = [NSPredicate
                                        predicateWithFormat:@"SELF beginswith[cd] %@",
                                        prefix];
        NSArray *a = [searchResults filteredArrayUsingPredicate:resultPredicate];
        [indexedSearchResult setValue:a forKey:prefix];
    }
}

- (NSString*)handleInputString:(NSString*)inputString{
    NSString* inputLetters = inputString;
    NSCharacterSet *allAllowedLetters = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmonpqrstuvwxyzABCDEFGHIJKLMONPQRSTUVWXYZ1234567890?*"];
    
    NSMutableString *filteredSring = [NSMutableString string];
    
    unsigned int i;
    int inputLettersLength=[inputLetters length];
    
    for (i=0; i<inputLettersLength; i++)
    {
        unichar asciiChar = [inputLetters characterAtIndex:i];
        if ([allAllowedLetters characterIsMember:asciiChar]){
            NSString *stringFromAsciiChar = [NSString stringWithCharacters:&asciiChar length:1];
            [filteredSring appendString:stringFromAsciiChar];
        }
    }
    
    return [self replaceNumber:filteredSring];
}

- (void)searchForCrossword:(NSString*)searchText
{
    searchText = [self handleInputString:searchText];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF like[cd] %@", searchText];
    
    C8JAppDelegate *delegate = (C8JAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSArray *allItems = [delegate dictionaryWords];
    searchResults = [NSMutableArray arrayWithArray:[allItems filteredArrayUsingPredicate:resultPredicate]];
    
    [self categorizeWordsByAlphabet];
    [searchResultsTableView reloadData];
    searchResultsTableView.hidden = NO;
    [SVProgressHUD dismiss];
}

- (void)searchForSpell:(NSString*)searchText
{
    C8JAppDelegate *delegate = (C8JAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSArray *allItems = [delegate dictionaryWords];
    
    NSMutableArray *filteredLetterArray = [NSMutableArray array];
    
    [searchText enumerateSubstringsInRange:NSMakeRange(0, [searchText length])
                                   options:(NSStringEnumerationByComposedCharacterSequences)
                                usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                    if([allAllowedLettersArray indexOfObject:substring]){
                                        [filteredLetterArray addObject:substring];
                                    }
                                }];
    
    // Keep an immutable copy of the character value array
    int inputLetterSetLength=[filteredLetterArray count];
    
    for (NSString *candidate in allItems) {
		Boolean flag=TRUE;
		int l = [candidate length];
        NSString *lowerCaseCandidate = [candidate lowercaseString];
		
        // optimization: no point in examining words that are longer that the set of letters
		if (l>inputLetterSetLength)
			continue;
		
        // Here uses the judgement of subset arithmetic.
        // First, make a working copy of input letter set
		NSMutableArray *testSet = [NSMutableArray arrayWithArray:filteredLetterArray];
		while (l--) {
            // Test each character by trying to delete it from the working set
			//unichar c = [candidate characterAtIndex:l];
            NSString *s = [lowerCaseCandidate substringWithRange:NSMakeRange(l,1)];
            int j = [testSet indexOfObject:s];
            if(j==NSNotFound){
                flag = FALSE;
                break;
            }
            
            // Remove used letter in input letter set, if without this step, situation like this
            // will happen:	you input letter set is "two", but the result contains "too", because
            // the "o" in "two" is used twice to check the 2 "o's" in "too".
			[testSet removeObjectAtIndex:j];
		}
        // Till this point, the candidate word pass all letter check, so it can be spelled using
        // the input set. We tell the controller (on the main thread) to add it to the result list.
		if(flag){
            [searchResults addObject:candidate];
		}
	}
    
    [self categorizeWordsByLength];
    [self populateKeyArray];
    [searchResultsTableView reloadData];
    searchResultsTableView.hidden = NO;
    [SVProgressHUD dismiss];
}

- (NSString *)tabImageName
{
    if(SearchModeCrossword == searchMode){
        return @"image-1";
    }else{
        return @"image-2";
    }
}

#pragma mark - UISearchBarDelegate delegate methods

- (void)searchBar:(C8JSearchBar *)aSearchBar textDidChange:(NSString *)searchText{
    if([aSearchBar.text isEqualToString:@""]){
        [self searchBarCancelButtonClicked:aSearchBar];
    }
}

- (void)searchBarSearchButtonClicked:(C8JSearchBar *)aSearchBar{
    isKeyArrayPopulated = NO;
    [searchResults removeAllObjects];
    [indexedSearchResult removeAllObjects];
    [searchResultTitleArray removeAllObjects];
    [searchResultsTableView reloadData];
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"searching...", nil) maskType:SVProgressHUDMaskTypeGradient];
    
    if(SearchModeCrossword == searchMode){
        [self performSelector:@selector(searchForCrossword:)
                   withObject:[aSearchBar getText]
                   afterDelay:0];
    }else{
        [self performSelector:@selector(searchForSpell:)
                   withObject:[aSearchBar getText]
                   afterDelay:0];
    }
}

- (void)searchBarCancelButtonClicked:(C8JSearchBar *) aSearchBar{
    isKeyArrayPopulated = NO;
    [searchResultTitleArray removeAllObjects];
    
    [indexedSearchResult removeAllObjects];
    
    [searchResultsTableView reloadData];
    searchResultsTableView.hidden = YES;
}

#pragma mark - Table view delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    int i=0;
    for (NSString *key in [indexedSearchResult allKeys]) {
        int v = [[indexedSearchResult valueForKey:key] count];
        if(v>0){
            i++;
        }
    }
    return i;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if(!isKeyArrayPopulated){
        [self populateKeyArray];
    }
    
    return searchResultTitleArray;
    
    if(SearchModeCrossword == searchMode){
        return [searchResultTitleArray sortedArrayUsingFunction:stringSortByAlphabet context:NULL];
    }else{
        return [searchResultTitleArray sortedArrayUsingFunction:stringSortByNumber context:NULL];
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return [searchResultTitleArray indexOfObject:title];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(!isKeyArrayPopulated){
        [self populateKeyArray];
    }
    
    NSString *sectionTitleString = [searchResultTitleArray objectAtIndex:section];
    
    UIView *a = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    a.backgroundColor = [UIColor colorWithRed:0.824 green:0.849 blue:0.653 alpha:0.90];
    UILabel *textSection = [[UILabel alloc] initWithFrame:CGRectMake(10,2, tableView.width-2*10, 20)];
    
    textSection.frame = CGRectMake(10,0, tableView.width-2*10, 20);
    
    textSection.text = sectionTitleString;
    textSection.textColor =[UIColor whiteColor];
    textSection.backgroundColor = [UIColor clearColor];
    textSection.font = [UIFont fontWithName:@"Baskerville-Bold" size:22];
    [a addSubview:textSection];
    
    return a;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(!isKeyArrayPopulated){
        [self populateKeyArray];
    }
    return [searchResultTitleArray objectAtIndex:section];
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *selectWord = [[indexedSearchResult valueForKey:[searchResultTitleArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    UIReferenceLibraryViewController *referenceLibraryViewController = [[UIReferenceLibraryViewController alloc] initWithTerm:selectWord];
    [referenceLibraryViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentModalViewController:referenceLibraryViewController animated:YES];
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    if(!isKeyArrayPopulated){
        [self populateKeyArray];
    }
    
    NSString *key = [searchResultTitleArray objectAtIndex:section];
    NSArray *a = [indexedSearchResult valueForKey:key];
    return [a count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    C8JTableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[C8JTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setLabelText:[[indexedSearchResult valueForKey:[searchResultTitleArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]];
    
    return cell;
}

@end
