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
    
    static var fileNames = ["fiftyreps.png", "hundredreps.png", "fivehundredreps.png", "lion.png", "elephant.png", "dino.png", "whale.png", "tenexercises.png", "twentyfiveexercises.png", "fiftyexercises.png", "hundredexercises.png", "fivedays.png", "tendays.png", "onemonth.png"]
    
    //OFFICIAL BADGE ORDER
        //0: 50reps
        //1: 100reps
        //2: 500reps
        //3: lion
        //4: elephant
        //5: dino
        //6: whale
        //7: 10exer
        //8: 25exer
        //9: 50exer
        //10: 100exercises
        //11: 5day
        //12: 10day
        //13: 1month
    
    
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
