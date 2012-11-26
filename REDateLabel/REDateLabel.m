//
//  REDateLabel.m
//  REDateLabel
//
//  Created by Reefaq on 27/10/12.
//  Copyright (c) 2012 Reefaq. All rights reserved.
//

#import "REDateLabel.h"
#import "NSDate+TimeAgo.h"

@interface REDateLabel () {
    dispatch_queue_t q_default;
    dispatch_source_t timer;
}

@end

@implementation REDateLabel

-(void)startTimer{
    [self configureTimer];
    dispatch_resume(timer);
}
-(void)configureTimer{
    if (!timer) {
        q_default = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, q_default); //run event handler on the default global queue
        dispatch_time_t now = dispatch_walltime(DISPATCH_TIME_NOW, 0);
        dispatch_source_set_timer(timer, now, 1ull*NSEC_PER_SEC, 5000ull);
        dispatch_source_set_event_handler(timer, ^{
            
            dispatch_async(dispatch_get_main_queue(), ^ {
                self.text = [self.date timeAgo];
                [self sizeToFit];
            });
        });
        
    }
}

-(void)setDate:(NSDate *)date{
    _date = date;
    [self startTimer];
}

-(void)dealloc{
    if (timer) {
        dispatch_suspend(timer);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
