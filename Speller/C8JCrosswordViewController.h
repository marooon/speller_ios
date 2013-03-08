//
//  C8JCrosswordViewController.h
//  Speller
//
//  Created by liulei on 2/8/13.
//  Copyright (c) 2013 cool8jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCLabel.h"

@interface C8JCrosswordViewController : UIViewController<UISearchDisplayDelegate,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>{
    BOOL isKeyArrayPopulated;
    
    NSMutableArray *searchResultTitleArray;
    NSMutableArray *searchResults;
    NSMutableDictionary *indexedSearchResult;
    
    RCLabel *introLabel;
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
    UIScrollView *contentView;
}

@end
