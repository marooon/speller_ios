//
//  C8JCrosswordViewController.m
//  Speller
//
//  Created by liulei on 2/8/13.
//  Copyright (c) 2013 cool8jay. All rights reserved.
//

#import "C8JCrosswordViewController.h"
#import "C8JAppDelegate.h"
#import "SVProgressHUD.h"
#import "C8JTableViewCell.h"

@interface C8JCrosswordViewController ()

@end

@implementation C8JCrosswordViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"crossword", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"image-1"];
        searchBar = [[UISearchBar alloc] init];
        searchBar.barStyle = UIBarStyleBlack;
        searchBar.delegate = self;
        self.view.backgroundColor = [UIColor whiteColor];
        
        searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar
                                                                    contentsController:self];
        searchDisplayController.delegate = self;
        searchDisplayController.searchResultsDataSource =self;
        searchDisplayController.searchResultsDelegate = self;
        searchDisplayController.searchResultsTableView.backgroundView.backgroundColor = BackgroundColor;
        searchDisplayController.searchResultsTableView.backgroundColor = BackgroundColor;
        
        indexedSearchResult = [NSMutableDictionary dictionary];
        searchResultTitleArray = [NSMutableArray array];
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
    
    [introData setObject:@"<font size = 22 face='Baskerville-SemiBold' color = '#573821'>\nCrossword\n</font>"
     "<font size = 16 face='Baskerville-Italic' color = '#573821'>Search for fixed-sequence word.\n\n"
     "<font size = 18 face='Baskerville' color = '#573821'>use question(?) or asterisk(*) symbol to indicate missing characters, for example:\n\n"
     "<p indent=15>1. \"?g??d?\" will match words with 4 missing character, or \"1g2d1\" for short. The result is \"agenda\".\n\n"
     "2. \"g*d\" will match words with unknown amount of missing characters.</p></font>"
                  forKey:@"text"];
    
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:[introData objectForKey:@"text"]];
    introLabel.componentsAndPlainText = componentsDS;
    
    [self arrangeView];
}

NSInteger stringSort(id str1, id str2, void *context) {
    return [str1 caseInsensitiveCompare:str2];
}

- (void)populateKeyArray{
    for (NSString *key in [indexedSearchResult allKeys]) {
        int v = [[indexedSearchResult valueForKey:key] count];
        if(v>0){
            [searchResultTitleArray addObject:key];
        }
    }
    
    NSSortDescriptor* desc = [[NSSortDescriptor alloc] initWithKey:@"description" ascending:YES];
    [searchResultTitleArray sortUsingDescriptors:[NSArray arrayWithObject:desc]];
    
    if([searchResultTitleArray count]>0){
        isKeyArrayPopulated = YES;
    }
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

- (void)filterContentForSearchText:(NSString*)searchText
{
    searchText = [self handleInputString:searchText];
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF like[cd] %@", searchText];
    
    C8JAppDelegate *delegate = (C8JAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSArray *allItems = [delegate dictionaryWords];
    searchResults = [NSMutableArray arrayWithArray:[allItems filteredArrayUsingPredicate:resultPredicate]];
    
    [self categorizeWordsByAlphabet];
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
    
    return [searchResultTitleArray sortedArrayUsingFunction:stringSort context:NULL];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return [searchResultTitleArray indexOfObject:title];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *sectionTitleString = [searchResultTitleArray objectAtIndex:section];

    UIView *a = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    a.backgroundColor = [UIColor colorWithRed:0.824 green:0.849 blue:0.653 alpha:0.90];
    UILabel *textSection = [[UILabel alloc] initWithFrame:CGRectMake(10,2, tableView.width-2*10, 20)];
    
    textSection.frame = CGRectMake(10,2, tableView.width-2*10, 20);
    
    textSection.text = sectionTitleString;
    textSection.textColor =[UIColor whiteColor];
    textSection.backgroundColor = [UIColor clearColor];
    textSection.font = [UIFont fontWithName:@"Baskerville" size:22];
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
    [referenceLibraryViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
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

#pragma mark - UISearchDisplayController delegate methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // do not show search result synchronously, on iphone, it is very slow to do so.
    return NO;
}

@end
