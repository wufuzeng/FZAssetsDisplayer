//
//  FZGifImageView.h
//  FZFilePreviewer
//
//  Created by 吴福增 on 2019/7/20.
//

#import <UIKit/UIKit.h>
#import "FZFilePreviewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FZGifImageView : UIImageView



@property (nonatomic,copy) void(^animationCompletedHandler)(BOOL finished);

-(void)configWithModel:(FZFilePreviewModel *)model;
-(void)startGifAnimating;

-(void)stopGifAnimating;

@end

NS_ASSUME_NONNULL_END
