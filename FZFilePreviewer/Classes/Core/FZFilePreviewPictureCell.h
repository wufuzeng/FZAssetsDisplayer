//
//  FZFilePreviewPictureCell.h
//  FZFilePreviewer
//
//  Created by 吴福增 on 2019/7/19.
//

#import <UIKit/UIKit.h>
#import "FZFilePreviewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FZFilePreviewPictureCell : UICollectionViewCell

@property (nonatomic,assign) BOOL canZoom;

-(void)configWithModel:(FZFilePreviewModel *)model;

@end

NS_ASSUME_NONNULL_END
