//
//  C8JSearchViewController.h
//  Speller
//
//  Created by liulei on 2/14/13.
//  Copyright (c) 2013 cool8jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCLabel.h"
#import "C8JSearchBar.h"

typedef enum{
    SearchModeCrossword,
    SearchModeSpell
}SearchMode;

typedef enum{
    TransitionModeNormalToReference,
    TransitionModeReferenceToNormal
}TransitionMode;

@interface C8JSearchViewController : UIViewController<C8JSearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource, UITableViewDelegate, C8JSearchBarDelegate>{
    SearchMode searchMode;
    
    TransitionMode transitionMode;
    BOOL isKeyArrayPopulated;
    BOOL isReferenceLibraryShown;
    BOOL needShowingReference;
    BOOL needHidingReference;
    
    NSMutableArray *searchResultTitleArray;
    NSMutableArray *searchResults;
    NSMutableDictionary *indexedSearchResult;
    
    NSMutableArray *allAllowedLettersArray;
    
    RCLabel *introLabel;
    C8JSearchBar *searchBar;
    // UISearchDisplayController *searchDisplayController;
    UIScrollView *contentView;
    UITableView *searchResultsTableView;
    
    UIButton *spellButton;
    UIButton *crosswordButton;
    UIButton *infoButton;
}

@property(nonatomic)SearchMode searchMode;

- (id)initWithSearchMode:(SearchMode)aSearchMode;

@end
