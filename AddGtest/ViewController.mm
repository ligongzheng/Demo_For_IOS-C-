//
//  ViewController.m
//  AddGtest
//
//  Created by 李恭政 on 18/6/22.
//  Copyright © 2018年 李恭政. All rights reserved.
//

#import "ViewController.h"

//引入gtest的framework，制作好framework后要手动的在工程属性里面设置Header Search Paths
//注意保证framework的名字要和里面的胖库名字一致
#include "gtest/gtest.h"

int add(int a, int b){
    return a+b;
}

TEST(First_Try, add){
    EXPECT_EQ(2, add(1, 1));
}

int c_main(){
    return RUN_ALL_TESTS();
}

@interface ViewController ()

@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self redirectSTD:STDOUT_FILENO];
    [self redirectSTD:STDERR_FILENO];
      // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)EnterForGest {
    [self->logTextView deleteBackward];
    self->logTextView.editable = false;
    [self FuncForGtest];
    
}

- (void)FuncForGtest {
    //很关键的将初始化出main函数的参数并传给InitGoogleTest
    // Pass the command-line arguments to Google Test to support the --gtest options
    NSArray *arguments = [[NSProcessInfo processInfo] arguments];
    
    int i = 0;
    int argc = (int)[arguments count];
    const char **argv = (const char **)calloc((unsigned int)argc + 1, sizeof(const char *));
    for (NSString *arg in arguments) {
        argv[i++] = [arg UTF8String];
    }
    
    testing::InitGoogleTest(&argc, (char **)argv);
    
    c_main();
   
    }

//下面两个方法是为了将标准输出送到UITextView中，这两个方法会在viewDidLoad中调用
- (void)redirectNotificationHandle:(NSNotification *)nf{ // 通知方法
    NSData *data = [[nf userInfo] objectForKey:NSFileHandleNotificationDataItem];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    self->logTextView.text = [NSString stringWithFormat:@"%@\n\n%@",self->logTextView.text, str];// logTextView 就是要将日志输出的视图（UITextView）
    NSRange range;
    range.location = [self->logTextView.text length] - 1;
    range.length = 0;
    [self->logTextView scrollRangeToVisible:range];
    [[nf object] readInBackgroundAndNotify];
}

- (void)redirectSTD:(int )fd{
    NSPipe * pipe = [NSPipe pipe] ;// 初始化一个NSPipe 对象
    NSFileHandle *pipeReadHandle = [pipe fileHandleForReading] ;
    dup2([[pipe fileHandleForWriting] fileDescriptor], fd) ;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(redirectNotificationHandle:)
                                                 name:NSFileHandleReadCompletionNotification
                                               object:pipeReadHandle]; // 注册通知
    [pipeReadHandle readInBackgroundAndNotify];
}

@end

