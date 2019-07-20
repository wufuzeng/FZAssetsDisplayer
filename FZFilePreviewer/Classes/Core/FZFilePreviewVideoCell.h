//
//  FZFilePreviewVideoCell.h
//  FZFilePreviewer
//
//  Created by 吴福增 on 2019/7/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FZFilePreviewVideoCell : UICollectionViewCell

@property (nonatomic,strong) NSURL *URL;

-(void)startPlay;

-(void)stopPlay;

@end

NS_ASSUME_NONNULL_END
