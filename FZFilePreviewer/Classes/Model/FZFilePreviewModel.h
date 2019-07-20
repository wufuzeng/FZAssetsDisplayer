//
//  FZFilePreviewModel.h
//  FZFilePreviewer
//
//  Created by 吴福增 on 2019/7/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FZFilePreviewType) {
    FZFilePreviewTypePicture,
    FZFilePreviewTypeGif,
    FZFilePreviewTypeScene,
    FZFilePreviewTypeLive,
    FZFilePreviewTypeVideo
};

@interface FZFilePreviewModel : NSObject

@property (nonatomic,assign) FZFilePreviewType fileType;


@property (nonatomic,strong) UIImage *image;

@property (nonatomic,strong) NSURL *URL;

@property (nonatomic,strong) NSData *data;

@property (nonatomic,strong) NSArray<UIImage *> *images;

@property (nonatomic,assign) UIViewContentMode contentMode;

@end

NS_ASSUME_NONNULL_END
