//  DrawHM
//
//  China Hacker Union
//  DrawHM  QQ 121118811
//  Created by 唐三 on 2021/12/9
#import "hookURL.h"
#import <objc/runtime.h>
@implementation NSURL (hook)
+(void)load
{
    Method one = class_getClassMethod([self class], @selector(URLWithString:));
    Method one1 = class_getClassMethod([self class], @selector(hook_URLWithString:));
    method_exchangeImplementations(one, one1);
}

+(instancetype)hook_URLWithString:(NSString *)Str
{
    //循环删文件
    //循环删除动画循环时间0.1
    [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
          
          NSString *filepath9= [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/ShadowTrackerExtra/Saved/Paks/Arts_Timeliness/CG016_Version_Gundam/CG016_Version_Event/Arts_Player/MoviesPak/Gundam_Event01_Movie_A1.mp4"];
          NSFileManager *fileManager9= [NSFileManager defaultManager];
          [fileManager9 removeItemAtPath:filepath9 error:nil];
          
      }];
    
    if ([Str containsString:@"https://jiazhang.qq.com/healthy/dist/faceRecognition/guide.html"]) {
        return [NSURL hook_URLWithString:@"https://jiazhang.qq.com/wap/family/dist/msdk/parent.html"];
    }else {
            return [NSURL hook_URLWithString:Str];
        }
    }

@end

