//
//  FZFilePreviewView.h
//  FZFilePreviewer
//
//  Created by 吴福增 on 2019/7/19.
//

#import <UIKit/UIKit.h>

#import "FZFilePreviewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FZFilePreviewView : UIView

-(void)preview:(NSArray <FZFilePreviewModel *>*)files;


@end

NS_ASSUME_NONNULL_END
