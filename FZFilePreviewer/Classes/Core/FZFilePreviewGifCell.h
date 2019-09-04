//
//  FZFilePreviewGifCell.h
//  FZFilePreviewer
//
//  Created by 吴福增 on 2019/7/19.
//

#import <UIKit/UIKit.h>
#import "FZGifImageView.h"
NS_ASSUME_NONNULL_BEGIN

@interface FZFilePreviewGifCell : UICollectionViewCell

@property (nonatomic,strong) FZGifImageView *gifImageView;

-(void)configWithModel:(FZFilePreviewModel *)model;


@end

NS_ASSUME_NONNULL_END
