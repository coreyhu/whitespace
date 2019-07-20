//
//  ViewController.swift
//  whitespace
//
//  Created by Corey Hu on 7/19/19.
//  Copyright © 2019 Corey Hu. All rights reserved.
//

import UIKit
import Speech
import BoseWearable

class ViewController: UIViewController {
    
    @IBOutlet var textView : UITextView!
    @IBOutlet var recordButton : UIButton!
    @IBOutlet weak var connectButton: UIButton!
    
    var enabledMetrics: [Metric] = []
    
    let sensors: [SensorType] = [.accelerometer, .rotation, .gyroscope, .gameRotation]
    let samplePeriod: SamplePeriod = ._20ms
    
    var manager: CaptureManager!
    
    var session: (WearableDeviceSession)!
    var device: WearableDevice!
    
    // We create the SensorDispatch without any reference to a session or a device.
    // We provide a queue on which the sensor data events are dispatched on.
    let sensorDispatch = SensorDispatch(queue: .main)
    
    /// Retained for the lifetime of this object. When deallocated, deregisters
    /// this object as a WearableDeviceEvent listener.
    var token: ListenerToken?
    
    public let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    public var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    public var recognitionTask: SFSpeechRecognitionTask?
    public let audioEngine = AVAudioEngine()
    
    var isRecording = false {
        didSet {
            self.navigationItem.rightBarButtonItem?.isEnabled = !isRecording
        }
    }
    
    var isConnected = false {
        didSet {
            connectButton.setTitle(isConnected ? "Disconnect" : "Connect", for: [])
            recordButton.isEnabled = isConnected
        }
    }
    
    @IBAction func recordButtonTapped() {
        if isConnected {
            isRecording = !isRecording
            toggleSensors()
            toggleRecording()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        isRecording = false
        isConnected = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager = CaptureManager(metrics: enabledMetrics)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SettingsSegue" {
            let settingsVC = segue.destination as? SettingsViewController
            settingsVC?.vc = self
        }
    }
}

