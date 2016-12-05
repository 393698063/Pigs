#import <UIKit/UIKit.h>

@protocol CHCImageClipFrame
@required
@property(nonatomic,assign) CGRect cropRect;
@end

#define HC_ImageClip_ScreenBound [UIScreen mainScreen].bounds

@class  CHCImageClipingViewController;

typedef void(^HFImageEditorDoneCallback)(UIImage *image, BOOL canceled);

@interface CHCImageClipingViewController : UIViewController<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property(nonatomic,retain) IBOutlet UIButton *saveButton;
@property(nonatomic,copy) HFImageEditorDoneCallback doneCallback;
@property(nonatomic,copy) UIImage *sourceImage;
@property(nonatomic,copy) UIImage *previewImage;
@property(nonatomic,assign) CGSize cropSize;
@property(nonatomic,assign) CGFloat outputWidth;
@property(nonatomic,assign) CGFloat minimumScale;
@property(nonatomic,assign) CGFloat maximumScale;

@property(nonatomic,assign) BOOL panEnabled;
@property(nonatomic,assign) BOOL rotateEnabled;
@property(nonatomic,assign) BOOL scaleEnabled;
@property(nonatomic,assign) BOOL tapToResetEnabled;

- (void)reset:(BOOL)animated;
- (id)initWithCompletionBlock:(void (^)(UIImage *editedImage, BOOL canceled))aCompletion;

@end


