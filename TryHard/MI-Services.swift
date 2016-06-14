//
//  MI-Services.swift
//  TryHard
//
//  Created by Sergey on 6/14/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import Foundation

enum MIService : String {
    case MILI = "FEE0"          //Mili-Service
    case Unknown1 = "FEE1"
    case Unknown2 = "FEE7"
    case Alert = "1802"         //Alert services
    case HeartRate = "180D"     //HeartRate
}

enum MICharacteristic : String {
    
    //MILI service
    case DEVICE_INFO = "FF01"       //read
    case DEVICE_NAME = "FF02"       //read
    case NOTIFICATION = "FF03"      //read/notify
    case USER_INFO = "FF04"         //read/write
    case CONTROL_POINT = "FF05"     //write
    case REALTIME_STEPS = "FF06"    //read/notify
    case ACTIVITY_DATA = "FF07"     //read/indicate
    case FIRMWARE_DATA = "FF08"     //write w/o response
    case LE_PARAMS = "FF09"         //read/write
    case DATE_TIME = "FF0A"         //read/write
    case STATISTICS = "FF0B"        //read/write
    case BATTERY = "FF0C"           //read/notify
    case TEST = "FF0D"              //read/write
    case SENSOR_DATA = "FF0E"       //read/notify
    case PAIR = "FF0F"              //read/write
    case Unknown1 = "FF10"
    
    //Alert service
    case Alert = "2A06"             //write w/o response
}