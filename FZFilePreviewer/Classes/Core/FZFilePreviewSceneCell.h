//
//  FZFilePreviewSceneCell.h
//  FZFilePreviewer
//
//  Created by 吴福增 on 2019/7/20.
//

#import <UIKit/UIKit.h>
#import "FZFilePreviewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FZFilePreviewSceneCell : UICollectionViewCell

-(void)configWithModel:(FZFilePreviewModel *)model;

- (void)startWaggle;

- (void)stopWaggle;

@end

NS_ASSUME_NONNULL_END
