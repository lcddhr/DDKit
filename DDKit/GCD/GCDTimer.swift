//
//  GCDTimer.swift
//  DouyuTV
//
//  Created by lovelydd on 16/1/15.
//  Copyright © 2016年 xiaomutou. All rights reserved.
//

import UIKit


class GCDTimer {

    private var _timer : dispatch_source_t?
    
    typealias GCDTimerHandle = (() -> Void)
    
    
    init(){
        
        
    }

    private func _createTimer(interval: Double, queue: dispatch_queue_t, block: GCDTimerHandle) -> dispatch_source_t {
        
        let timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        if (timer != nil)
        {
            dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, Int64(interval * Double(NSEC_PER_SEC))), UInt64(interval * Double(NSEC_PER_SEC)), (1 * NSEC_PER_SEC) / 10);
            dispatch_source_set_event_handler(timer, block);
            dispatch_resume(timer);
        }
        return timer;
    }
    
    func start(interval: Double, block: (() ->Void)) {
        
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        _timer = _createTimer(interval, queue: queue, block: block)
    }
    
    
    func stop() {

        if (_timer != nil) {
            
            dispatch_source_cancel(_timer!);
            _timer = nil;
        }

        
    }
    
}
