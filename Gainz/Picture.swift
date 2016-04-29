//
//  Picture.swift
//  TestCollectionView
//
//  Created by Robert Seitsinger on 9/17/15.
//  Copyright © 2015 cs378. All rights reserved.
//

import UIKit

class Picture : NSObject {
    
    private var id:String? = nil
    private var image:UIImage? = nil
    
    init(id:String, image:UIImage?) {
        super.init()
        self.id = id
        self.image = image
    }
    
    func getId() -> String {
        return self.id!
    }
    
    func getImage() -> UIImage? {
        return self.image
    }
    
    func getGreyImage() -> UIImage? {
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.Only.rawValue)
        let context = CGBitmapContextCreate(nil, Int(self.image!.size.width), Int(self.image!.size.height), 8, 0, nil, bitmapInfo.rawValue)
        CGContextDrawImage(context, CGRectMake(0, 0, self.image!.size.width, self.image!.size.height), self.image!.CGImage);
        let mask = CGBitmapContextCreateImage(context)
        return UIImage(CGImage: CGImageCreateWithMask(convertToGrayScaleNoAlpha(), mask)!, scale: 0, orientation: UIImageOrientation.Up)
        
    }
    
    private func convertToGrayScaleNoAlpha() -> CGImageRef {
        let colorSpace = CGColorSpaceCreateDeviceGray();
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.None.rawValue)
        let width = self.image!.size.width
        let height = self.image!.size.height
        let context = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, colorSpace, bitmapInfo.rawValue)
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), self.image!.CGImage)
        return CGBitmapContextCreateImage(context)!
    }
}