//
//  ViewController.m
//  测试陀螺仪
//
//  Created by zhangyong on 16/9/18.
//  Copyright © 2016年 zhangyong. All rights reserved.
//

#import "ViewController.h"

#import <CoreMotion/CoreMotion.h>//陀螺仪和速度计的依赖库


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lab1;

@property (weak, nonatomic) IBOutlet UILabel *lab2;


@property (nonatomic, strong) CMMotionManager *motionManager;

@property (nonatomic, strong) NSOperationQueue *queue;


@end


@implementation ViewController

- (CMMotionManager *)motionManager{
    
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    
    return _motionManager;
}


- (NSOperationQueue *)queue{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
    }
    
    return _queue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 调用加速器
    [self configureAccelerometer];
    
    // 调用陀螺仪
    [self configureGrro];
}


// 调用加速计，ios5.0后改用push方式
- (void)configureAccelerometer {
    
    // push 方式
    if ([self.motionManager isAccelerometerAvailable]) {
        // 设置加速器的频率
        [self.motionManager setAccelerometerUpdateInterval:1 / 40.0];
        // 开始采集数据
        [self.motionManager startAccelerometerUpdatesToQueue:self.queue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            
            // 检测到震动的条件是某个方向的偏移大于2
            if (fabs(accelerometerData.acceleration.x) > 2.0 || fabs(accelerometerData.acceleration.y) > 2.0 || fabs(accelerometerData.acceleration.z) > 2.0) {
                
//                NSLog(@"加速计x值：%.2f y值：%.2f z值：%.2f",accelerometerData.acceleration.x,accelerometerData.acceleration.y,accelerometerData.acceleration.z);
                
                //数据请求完，回到主线程刷新ui
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                      self.lab1.text = [NSString stringWithFormat:@"加速计x值：%.2f y值：%.2f z值：%.2f",accelerometerData.acceleration.x,accelerometerData.acceleration.y,accelerometerData.acceleration.z];
                    
                });
            }
            
        }];
    }else{
        NSLog(@"加速器不能使用");
    }
    
}


// 调用陀螺仪
- (void)configureGrro {
   
    if ([self.motionManager isGyroAvailable]) {
        [self.motionManager startGyroUpdatesToQueue:self.queue withHandler:^(CMGyroData *gyroData, NSError *error) {
            
            // 检测到晃动的条件是某个方向的偏移大于2
            if (fabs(gyroData.rotationRate.x) > 2.0 || fabs(gyroData.rotationRate.y) > 2.0 || fabs(gyroData.rotationRate.z) > 2.0) {

//                NSLog(@"陀螺仪x偏移：%.2f  y偏移：%.2f  z偏移：%.2f",gyroData.rotationRate.x,gyroData.rotationRate.y,gyroData.rotationRate.z);
                
                //数据请求完，回到主线程刷新ui
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                     self.lab2.text = [NSString stringWithFormat:@"陀螺仪x偏移：%.2f  y偏移：%.2f  z偏移：%.2f",gyroData.rotationRate.x,gyroData.rotationRate.y,gyroData.rotationRate.z];
                    
                });
            }
            
        }];
    }else{
        NSLog(@"陀螺仪不能使用");
    }
    
}

// 触摸结束的时候
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CMAcceleration acceleration = self.motionManager.accelerometerData.acceleration;
    NSLog(@"触摸结束 %.2f__%.2f__%.2f",acceleration.x,acceleration.y,acceleration.z);
}


/*
 // 每一个设备晃动的时候, 系统通知每一个在用的设备, 可以使本身成为第一响应者
 - (BOOL)canBecomeFirstResponder
 {
 return YES;
 }
 
 - (void)viewDidAppear:(BOOL)animated
 {
 [self becomeFirstResponder];
 }
 */


// 晃动触发的一些方法
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.motionManager stopAccelerometerUpdates];//停止获取加速度计数据
    [self.motionManager stopGyroUpdates];//停止获取陀螺仪数据
    [self.motionManager stopDeviceMotionUpdates];//停止获取设备motion数据
}

// 开始晃动的时候触发
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"开始晃动");
}

// 结束晃动的时候触发
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"晃动结束");
}

// 中断晃动的时候触发
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"取消晃动,晃动终止");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
