//
//  JsonModel.swift
//  Movie App Final
//
//  Created by Awatef Ahmed on 1/3/20.
//  Copyright © 2020 Mostafa Samir. All rights reserved.
//

import Foundation
class JsonModel{
    var movtitle:String?
    var movimage:String?
    var movoverview:String?
    var movrate:Double?
    var movereleaseyear:Date?
    var movpopularity:Int?
    var movid:Int?
    
    init(title:String,image:String,overview:String,rate:Double,releaseyear:Date,popularity:Int,id:Int) {
        movtitle=title
        movimage=image
        movoverview=overview
        movrate=rate
        movereleaseyear=releaseyear
        movpopularity=popularity
        movid=id
    }
}
