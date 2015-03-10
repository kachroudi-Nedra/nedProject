
#import <UIKit/UIKit.h>

@protocol PKImagePickerViewControllerDelegate <NSObject>

-(void)imageSelected:(UIImage*)img;
-(void)imageSelectionCancelled;


@end

@interface PKImagePickerViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong) id<PKImagePickerViewControllerDelegate> delegate;
-(UIImage *) getimage;
@end
