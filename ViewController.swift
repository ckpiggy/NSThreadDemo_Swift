//
//  ViewController.swift
//  NSThreadDemo
//
//  Created by ChangChao-Tang on 2015/7/3.
//  Copyright (c) 2015年 ChangChao-Tang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var arr = [Int]()
    
    private var thread1 = NSThread()
    
    private var thread2 = NSThread()
    
    private let synQueue = dispatch_queue_create("sync queue", nil)

    @IBOutlet var counter1Lb: UILabel!
   
    @IBOutlet var counter2Lb: UILabel!
    
    @IBOutlet var safetyBtn: UIButton!
    
    @IBOutlet var stop1Btn: UIButton!
    
    @IBOutlet var stop2Btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.thread1 = NSThread(target: self, selector: "thread1Routine", object: nil);
        self.thread2 = NSThread(target: self, selector: "thread2Routine", object: nil);
       
    }
    
    func thread1Routine(){
        autoreleasepool{
            let curThread = NSThread.currentThread()
            let curRunLoop = NSRunLoop.currentRunLoop()
            var counter = 0
            
            while curThread.cancelled == false {
                counter += 1
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.counter1Lb.text = "\(counter * 2)"
                });
                
                usleep(500000);
               
            }
            
            NSThread.exit()
        }
    }
    
    func thread2Routine(){
        autoreleasepool{
            let curThread = NSThread.currentThread()
            let curRunLoop = NSRunLoop.currentRunLoop()
            var counter = 0
            
            while curThread.cancelled == false {
                counter += 1
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.counter2Lb.text = "\(counter * 2 - 1)"
                });
                
                usleep(500000);
                
            }
            
            NSThread.exit()
        }
    }
    
    func threadAJob(){
        autoreleasepool{
            let startDate = NSDate()
            while NSDate().timeIntervalSinceDate(startDate) < 10{
                
                dispatch_sync(self.synQueue, { () -> Void in
                    self.arr.append(10)
                    println("\(self.arr)")
                })
                
                usleep(500000)
            }
            NSThread.exit()
        }
    }
    
    func threadBJob(){
        autoreleasepool{
            let startDate = NSDate()
            while NSDate().timeIntervalSinceDate(startDate) < 10{
                
                dispatch_sync(self.synQueue, { () -> Void in
                    self.arr.insert(0, atIndex: 0)
                    println("\(self.arr)")
                })
                
                usleep(500000)
            }
            NSThread.exit()
        }
    }
    
    @IBAction func thread1Start(sender: UIButton) {
        sender.enabled = false
        self.thread1.start()
        self.stop1Btn.enabled = true
    }
    
    @IBAction func thread2Start(sender: UIButton) {
        sender.enabled = false
        self.thread2.start()
        self.stop2Btn.enabled = true
    }
    
    @IBAction func stop1(sender: UIButton) {
        self.thread1.cancel()
    }
    
    @IBAction func stop2(sender: UIButton) {
        self.thread2.cancel()
    }
    
    
    @IBAction func safetyBtnPressed(sender: UIButton) {
       NSThread.detachNewThreadSelector("threadAJob", toTarget: self, withObject: nil)
       NSThread.detachNewThreadSelector("threadBJob", toTarget: self, withObject: nil)
    }
}

