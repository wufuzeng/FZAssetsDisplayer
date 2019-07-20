//
//  FZFilePreviewSceneCell.h
//  FZFilePreviewer
//
//  Created by 吴福增 on 2019/7/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FZFilePreviewSceneCell : UICollectionViewCell

@property (nonatomic,strong) NSArray<UIImage *>*images;

- (void)startWaggle;

- (void)stopWaggle;

@end

NS_ASSUME_NONNULL_END
