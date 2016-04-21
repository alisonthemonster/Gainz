//
//  Badges.swift
//  Gainz
//
//  Created by Alison on 4/21/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class Badges: NSObject {
    private var list:[Picture] = [Picture]()
    
    //OFFICIAL BADGE ORDER
        //50reps
        //100reps
        //500reps
        //lion
        //elephant
        //dino
        //whale
        //10exer
        //25exer
        //50exer
        //100exercises
        //5day
        //10day
        //1month
    
    
    override init() {
        super.init()
        list.append(Picture(id:"50reps", image:UIImage(named:"fiftyreps.png")!))
        list.append(Picture(id:"100reps", image:UIImage(named:"hundredreps.png")!))
        list.append(Picture(id:"500reps", image:UIImage(named:"fivehundredreps.png")!))
        list.append(Picture(id:"lion", image:UIImage(named:"lion.png")!))
        list.append(Picture(id:"elephant", image:UIImage(named:"elephant.png")!))
        list.append(Picture(id:"dino", image:UIImage(named:"dino.png")!))
        list.append(Picture(id:"whale", image:UIImage(named:"whale.png")!))
        list.append(Picture(id:"10exer", image:UIImage(named:"tenexercises.png")!))
        list.append(Picture(id:"25exer", image:UIImage(named:"twentyfiveexercises.png")!))
        list.append(Picture(id:"50exer", image:UIImage(named:"fiftyexercises.png")!))
        list.append(Picture(id:"100exer", image:UIImage(named:"hundredexercises.png")!))
        list.append(Picture(id:"5day", image:UIImage(named:"fivedays.png")!))
        list.append(Picture(id:"10day", image:UIImage(named:"tendays.png")!))
        list.append(Picture(id:"1month", image:UIImage(named:"onemonth.png")!))
    }
    
    func count() -> Int {
        return list.count
    }
    
    func getPicture(index index:Int) -> Picture {
        return list[index]
    }
    
}
