//
//  FZFilePreviewModel.m
//  FZFilePreviewer
//
//  Created by 吴福增 on 2019/7/19.
//

#import "FZFilePreviewModel.h"

@implementation FZFilePreviewModel

-(FZFilePreviewPicModel *)picModel{
    if (_picModel == nil) {
        _picModel = [FZFilePreviewPicModel new];
    }
    return _picModel;
}
-(FZFilePreviewGifModel *)gifModel{
    if (_gifModel == nil) {
        _gifModel = [FZFilePreviewGifModel new];
    }
    return _gifModel;
}
-(FZFilePreviewSceneModel *)sceneModel{
    if (_sceneModel == nil) {
        _sceneModel = [FZFilePreviewSceneModel new];
    }
    return _sceneModel;
}

@end

@implementation FZFilePreviewPicModel



@end

@implementation FZFilePreviewGifModel

@end

@implementation FZFilePreviewSceneModel

@end

