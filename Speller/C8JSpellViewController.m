//
//  C8JSpellViewController.m
//  Speller
//
//  Created by liulei on 2/8/13.
//  Copyright (c) 2013 cool8jay. All rights reserved.
//

#import "C8JSpellViewController.h"
#import "C8JAppDelegate.h"
#import "SVProgressHUD.h"
#import "C8JTableViewCell.h"

@interface C8JSpellViewController ()

@end

@implementation C8JSpellViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"spell", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"image-2"];
        searchBar = [[UISearchBar alloc] init];
        searchBar.barStyle = UIBarStyleBlack;
        searchBar.delegate = self;
        self.view.backgroundColor = [UIColor whiteColor];
        
        searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar
                                                                    contentsController:self];
        searchDisplayController.delegate = self;
        searchDisplayController.searchResultsDataSource =self;
        searchDisplayController.searchResultsDelegate = self;
        
        indexedSearchResult = [NSMutableDictionary dictionary];
        searchResultTitleArray = [NSMutableArray array];
        searchResults = [NSMutableArray array];
    }
    return self;
}

- (void)arrangeView{
    searchBar.frame = CGRectMake(0, 0, self.view.width, 0);
    
    [searchBar sizeToFit];
    
    contentView.frame = CGRectMake(0,
                                   searchBar.bottom,
                                   self.view.width,
                                   self.view.height-searchBar.height);
    
    introLabel.frame = CGRectMake(0,0,self.view.frame.size.width,400);
    
    [self.view addSubview:searchBar];
    [self.view addSubview:contentView];
    [contentView addSubview:introLabel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    contentView = [[UIScrollView alloc] init];
    contentView.backgroundColor = BackgroundColor;
    
    introLabel = [[RCLabel alloc] init];
    
    NSMutableDictionary *introData = [NSMutableDictionary dictionary];
    [introData setObject:@"<font size = 22 face='Baskerville-SemiBold' color = '#573821'>\nSpell\n</font>"
     "<font size = 16 face='Baskerville-Italic' color = '#573821'>Search for unknown-sequence word.\n\n"
     "<font size = 18 face='Baskerville' color = '#573821'>Just input characters you need.\n\n"
                  forKey:@"text"];
    
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:[introData objectForKey:@"text"]];
    introLabel.componentsAndPlainText = componentsDS;
    
    [self arrangeView];
}

NSInteger stringSort2(id str1, id str2, void *context) {
    if([str1 intValue]>[str2 intValue]){
        return NSOrderedAscending;
    }else if([str1 intValue]<[str2 intValue]){
        return NSOrderedDescending;
    }else{
        return NSOrderedSame;
    }
}

- (void)populateKeyArray{
    for (NSString *key in [indexedSearchResult allKeys]) {
        int v = [[indexedSearchResult valueForKey:key] count];
        if(v>0){
            [searchResultTitleArray addObject:key];
        }
    }
    
    searchResultTitleArray = [NSMutableArray arrayWithArray:[searchResultTitleArray sortedArrayUsingFunction:stringSort2 context:NULL]];
    
    if([searchResultTitleArray count]>0){
        isKeyArrayPopulated = YES;
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

//- (NSString*)replace:(NSString*)searchText{
//    NSError *error = nil;
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\d+" options:0 error:&error];
//    
//    NSTextCheckingResult *result = [regex firstMatchInString:searchText
//                                                     options:NSMatchingReportProgress
//                                                       range:NSMakeRange(0, [searchText length])];
//    
//    NSRange matchRange = [result range];
//    NSMutableString *stringToReplace = [NSMutableString stringWithString:@""];
//    
//    int number = [[searchText substringWithRange:matchRange]intValue];
//    for (int i=0;i<number; i++) {
//        [stringToReplace appendString:@"?"];
//    }
//    
//    searchText = [searchText stringByReplacingCharactersInRange:matchRange withString:stringToReplace];
//    
//    if([self isMatch:searchText]){
//        return [self replace:searchText];
//    }else{
//        return searchText;
//    }
//}

- (void)filterContentForSearchText:(NSString*)searchText
{
    C8JAppDelegate *delegate = (C8JAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSArray *allItems = [delegate dictionaryWords];
    
    // ignore case
    NSString* inputLetters = [NSString stringWithFormat:@"%@%@", [searchText lowercaseString],[searchText uppercaseString]];
    NSCharacterSet *allAllowedLetters = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmonpqrstuvwxyzABCDEFGHIJKLMONPQRSTUVWXYZ"];
    
    NSMutableArray *filteredLetterArray = [NSMutableArray array];
    
    unsigned int i;
    int inputLettersLength=[inputLetters length];
    for (i=0; i<inputLettersLength; i++)
    {
        unichar c = [inputLetters characterAtIndex:i];
        if ([allAllowedLetters characterIsMember:c]){
            [filteredLetterArray addObject:[NSNumber numberWithUnsignedShort:c]];
        }
    }
    
    // Keep an immutable copy of the character value array
    int inputLetterSetLength=[filteredLetterArray count]/2;
    
    for (NSString *candidate in allItems) {
		Boolean flag=TRUE;
		int l = [candidate length];
		
        // optimization: no point in examining words that are longer that the set of letters
		if (l>inputLetterSetLength)
			continue;
		
        // Here uses the judgement of subset arithmetic.
        // First, make a working copy of input letter set
		NSMutableArray *testSet = [NSMutableArray arrayWithArray:filteredLetterArray];
		while (l--) {
            // Test each character by trying to delete it from the working set
			unichar c = [candidate characterAtIndex:l];
			unsigned int i = [testSet indexOfObject:[NSNumber numberWithUnsignedShort:c]];
			
            // Candidate word contains a letter that isn't in the input letter set, so it can not
            // be spelled out by your input letters, we should jump out of the judgement.
			if (i==NSNotFound)
			{
                // This candidate word should not be added into the result list
				flag=FALSE;
				break;
			}
            // Remove used letter in input letter set, if without this step, situation like this
            // will happen:	you input letter set is "two", but the result contains "too", because
            // the "o" in "two" is used twice to check the 2 "o's" in "too".
			[testSet removeObjectAtIndex:i];
		}
        // Till this point, the candidate word pass all letter check, so it can be spelled using
        // the input set. We tell the controller (on the main thread) to add it to the result list.
		if(flag){
            [searchResults addObject:candidate];
		}
	}
    
    [self categorizeWordsByLength];
    [self populateKeyArray];
    [searchDisplayController.searchResultsTableView reloadData];
    [SVProgressHUD dismiss];
}

#pragma mark - UISearchBarDelegate delegate methods

- (void)searchBar:(UISearchBar *)aSearchBar textDidChange:(NSString *)searchText{
    if([aSearchBar.text isEqualToString:@""]){
        [self searchBarCancelButtonClicked:aSearchBar];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar{
    isKeyArrayPopulated = NO;
    [searchResults removeAllObjects];
    [indexedSearchResult removeAllObjects];
    [searchResultTitleArray removeAllObjects];
    
    [searchDisplayController.searchResultsTableView reloadData];
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"searching...", nil) maskType:SVProgressHUDMaskTypeGradient];
    
    [self performSelector:@selector(filterContentForSearchText:)
               withObject:aSearchBar.text
               afterDelay:0];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) aSearchBar{
    isKeyArrayPopulated = NO;
    [searchResultTitleArray removeAllObjects];
    
    [indexedSearchResult removeAllObjects];
    [searchDisplayController.searchResultsTableView reloadData];
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
    
    return [searchResultTitleArray sortedArrayUsingFunction:stringSort2 context:NULL];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return [searchResultTitleArray indexOfObject:title];
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
    [referenceLibraryViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentModalViewController:referenceLibraryViewController animated:YES];
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return [[indexedSearchResult valueForKey:[searchResultTitleArray objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    C8JTableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[C8JTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    [cell setLabelText:[[indexedSearchResult valueForKey:[searchResultTitleArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UISearchDisplayController delegate methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // do not show search result synchronously, on iphone, it is very slow to do so.
    return NO;
}

@end
