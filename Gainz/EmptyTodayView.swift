//
//  EmptyTodayView.swift
//  Gainz
//
//  Created by Siena McFetridge on 4/30/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class EmptyTodayView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSBundle.mainBundle().loadNibNamed("EmptyTodayView", owner: self, options: nil)
        self.addSubview(self.view);    // adding the top level view to the view hierarchy
    }

}
