//
//  THPublicBT.swift
//  TryHard
//
//  Created by Sergey on 6/14/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit
import CoreBluetooth

class THPublicBT: UIViewController, UITableViewDelegate, UITableViewDataSource, CBCentralManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var devices = [CBPeripheral]()
    var centralManager = CBCentralManager()
    var connectedDevice:CBPeripheral!
    
    var miManager:MIServiceManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        miManager = MIServiceManager.sharedManager()
        
        scanButton.enabled = false
    }
    
    func enabled() {
        scanButton.enabled = true
    }
    
    //MARK:- TableViewHelper
    
    func didDiscoverPeripheral(peripheral: CBPeripheral) {
        
        for (index, device) in devices.enumerate() {
            
            if device == peripheral {
                devices.removeAtIndex(index)
                break
            }
        }
        
        devices.append(peripheral)
        tableView.reloadData()
    }
    
    //MARK:- IBActions
    
    @IBAction func scanAction(sender: AnyObject) {
        
        devices = []
        tableView.reloadData()
        
        centralManager.scanForPeripheralsWithServices([CBUUID(string: MIService.MILI.rawValue)], options: nil)
        print("start scanning")
    }
    
    @IBAction func refresh(sender: AnyObject) {
    }
    
    @IBAction func stopAction(sender: AnyObject) {
        centralManager.stopScan()
        print("stop scanning")
    }
    
    //MARK:- UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let device = devices[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("deviceCell")!
        
        cell.textLabel!.text = device.name ?? "Empty name"
        
        return cell
    }
    
    //MARK:- UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let device = devices[indexPath.row]
        
        
        centralManager.connectPeripheral(device, options: nil)
    }
    
    //MARK:- CBCentralManagerDelegate
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        
        didDiscoverPeripheral(peripheral)
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        
        print("did connect to peripheral", peripheral.name)
        
        connectedDevice = peripheral
        
        centralManager.stopScan()
        
        if let name = peripheral.name where name == "MI" {
            connectedDevice.delegate = self
            connectedDevice.discoverServices(nil)
        }
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("failed connection with ", peripheral.name)
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        switch (central.state) {
        case .PoweredOff:
            print("CoreBluetooth BLE hardware is powered off")
            
        case .PoweredOn:
            print("CoreBluetooth BLE hardware is powered on and ready")
            enabled()
        case .Resetting:
            print("CoreBluetooth BLE hardware is resetting")
            
        case .Unauthorized:
            print("CoreBluetooth BLE state is unauthorized")
            
        case .Unknown:
            print("CoreBluetooth BLE state is unknown");
            
        case .Unsupported:
            print("CoreBluetooth BLE hardware is unsupported on this platform");
            
        }
    }
}

//MARK:- CBPeripheralDelegate
extension THPublicBT : CBPeripheralDelegate {
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        
        NSLog("Peripheral services")
        print("peripheral: ", peripheral.name)
        
        for service in peripheral.services! {
            switch MIService(rawValue: service.UUID.UUIDString)! {
            case .MILI:
                peripheral.discoverCharacteristics(nil, forService: service)
                print("MILI service")
            case .Alert:
                peripheral.discoverCharacteristics(nil, forService: service)
            default:
                break
            }
        }
        
        print("-----------------")
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        NSLog("Peripheral characteristics")
        
        print("service: ", service.UUID.UUIDString)
        
        if MIService(rawValue: service.UUID.UUIDString)! == .MILI {
            for ch in service.characteristics! {
                miManager.add(ch)
                switch MICharacteristic(rawValue: ch.UUID.UUIDString)! {
                case .PAIR:
                    connectedDevice.writeValue("2".dataUsingEncoding(NSUTF8StringEncoding)!, forCharacteristic: ch, type: .WithResponse)
                default:
                    break
                }
            }
        } else if MIService(rawValue: service.UUID.UUIDString)! == .Alert {
            for ch in service.characteristics! {
                miManager.add(ch)
//                switch MICharacteristic(rawValue: ch.UUID.UUIDString)! {
//                case .Alert:
//                    let value = [0x02]
//                    let data = NSData(bytes: value, length: value.count)
//                    connectedDevice.writeValue(data, forCharacteristic: ch, type: .WithoutResponse)
//                default:
//                    break
//                }
            }
        }
        
        
        
        print("-----------------")
    }
    
    func peripheral(peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        print("didModifyServices: ", invalidatedServices)
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverIncludedServicesForService service: CBService, error: NSError?) {
        print("didDiscoverIncludedServicesForService: ", service)
    }
    
    func peripheral(peripheral: CBPeripheral, didWriteValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        switch MICharacteristic(rawValue: characteristic.UUID.UUIDString)! {
        case .PAIR:
            connectedDevice.readValueForCharacteristic(characteristic)
        default:
            break
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        print("didUpdateValueForCharacteristic: ", characteristic)
        
        switch MICharacteristic(rawValue: characteristic.UUID.UUIDString)! {
        case .PAIR:
            let data = characteristic.value
            
//            let c = CBMutableCharacteristic(type: CBUUID(string: MICharacteristic.Alert.rawValue), properties: .Notify, value: nil, permissions: .Writeable)
            let value = [0x02]
            let data1 = NSData(bytes: value, length: value.count)
            peripheral.writeValue(data1, forCharacteristic: miManager.get(.Alert)!, type: .WithoutResponse)
        default:
            break
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        print("didUpdateNotificationStateForCharacteristic: ", characteristic)
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverDescriptorsForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        print("didDiscoverDescriptorsForCharacteristic", characteristic)
    }
}
