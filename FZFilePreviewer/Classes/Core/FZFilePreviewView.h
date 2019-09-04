//
//  FZFilePreviewView.h
//  FZFilePreviewer
//
//  Created by 吴福增 on 2019/7/19.
//

#import <UIKit/UIKit.h>

#import "FZFilePreviewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class FZFilePreviewView;
@protocol FZFilePreviewViewDelegate <NSObject>

-(void)previewView:(FZFilePreviewView *_Nullable)previewView scrollToIndex:(NSInteger)index;

-(void)previewView:(FZFilePreviewView *_Nullable)previewView clickedIndex:(NSInteger)index;

@end

@interface FZFilePreviewView : UIView

@property (nonatomic,weak) id<FZFilePreviewViewDelegate> delegate;

@property (nonatomic,assign) BOOL showPageControl;

@property (nonatomic,assign) BOOL canZoomPic;

-(void)preview:(NSArray <FZFilePreviewModel *>*)files;

-(void)startCurrentPageActivity;

-(void)stopCurrentPageActivity;

@end

NS_ASSUME_NONNULL_END
