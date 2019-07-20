//
//  ViewController+Position.swift
//  whitespace
//
//  Created by Kevin Hu on 7/19/19.
//  Copyright © 2019 Corey Hu. All rights reserved.
//

import Foundation
import UIKit
import BoseWearable

extension ViewController {
    
    @IBAction func connectToDevice() {
        if isConnected && session != nil {
            session.close()
            session = nil
            isConnected = false
            return
        }
        
        let sensorIntent = SensorIntent(sensors: Set.init(sensors), samplePeriods: [samplePeriod])
        
        BoseWearable.shared.startConnection(mode: .alwaysShow, sensorIntent: sensorIntent) { result in
            switch result {
            case .success(let session):
                self.setupSession(session)
                self.isConnected = true
                
            case .failure(let error):
                print("Error: \(error)")
                
            case .cancelled:
                break
            }
        }
    }
    
    func setupSession(_ session: (WearableDeviceSession)) {
        self.session = session
        self.session.delegate = self
        
        sensorDispatch.handler = self
        
        self.device = session.device
        
        token = device.addEventListener(queue: .main) { [weak self] event in
            self?.wearableDeviceEvent(event)
        }
    }
    
    private func wearableDeviceEvent(_ event: WearableDeviceEvent) {
        switch event {
        case .didFailToWriteSensorConfiguration(let error):
            // Show an error if we were unable to set the sensor configuration.
            print("Error: \(error)")
            
        case .didSuspendWearableSensorService(let reason):
            // Block the UI when the sensor service is suspended.
            print("Suspended: \(reason)")

        default:
            break
        }
    }
    
    private func listenForSensors() {
        // Configure sensors at 50 Hz (a 20 ms sample period)
        device.configureSensors { config in

            // Here, config is the current sensor config. We begin by turning off
            // all sensors, allowing us to start with a "clean slate."
            config.disableAll()
            
            // Enable the rotation and accelerometer sensors
            device.wearableDeviceInformation?.availableSensors.forEach({ sensor in
                config.enable(sensor: sensor, at: samplePeriod)
            })
        }
    }
    
    private func stopListeningForSensors() {
        // Disable all sensors.
        device.configureSensors { config in
            config.disableAll()
        }
    }
    
    func toggleSensors() {
        if isRecording {
            listenForSensors()
        } else {
            stopListeningForSensors()
        }
    }
}

extension ViewController: SensorDispatchHandler {
    /// Indicates that an accelerometer reading has been received.
    internal func receivedAccelerometer(vector: Vector, accuracy: VectorAccuracy, timestamp: SensorTimestamp) {
        print("Acc: \(vector)")
    }
    
    /// Indicates that a gyroscope reading has been received.
    internal func receivedGyroscope(vector: Vector, accuracy: VectorAccuracy, timestamp: SensorTimestamp) {
        
    }
    
    /// Indicates that a rotation reading has been received.
    func receivedRotation(quaternion: Quaternion, accuracy: QuaternionAccuracy, timestamp: SensorTimestamp) {
        
    }
    
    /// Indicates that a game rotation reading has been received.
    func receivedGameRotation(quaternion: Quaternion, timestamp: SensorTimestamp) {
        
    }
}

extension ViewController: WearableDeviceSessionDelegate {
    func sessionDidOpen(_ session: WearableDeviceSession) {
        // This view controller is only shown after the session has successfully
        // opened. It is dismissed when the session closes. We don't need to do
        // anything here.
    }
    
    func session(_ session: WearableDeviceSession, didFailToOpenWithError error: Error?) {
        // This view controller is only shown after the session has successfully
        // opened. It is dismissed when the session closes. We don't need to do
        // anything here.
    }
    
    func session(_ session: WearableDeviceSession, didCloseWithError error: Error?) {
        // The session was closed, possibly due to an error.
    }
}
