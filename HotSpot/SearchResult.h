//
//  SearchResult.h
//  HotSpot
//
//  Created by aodemuyi on 7/18/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchResult : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *searchResultTitle;
@property (weak, nonatomic) IBOutlet UILabel *searchResultSubtitle;

@end

NS_ASSUME_NONNULL_END
