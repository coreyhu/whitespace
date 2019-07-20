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
import SceneKit
import SpriteKit

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
            if isRecording {
                manager.clearAll()
            }
        }
    }
    
    @IBOutlet var scene : SCNView!
    let audioSource = SCNAudioSource(fileNamed: "ooga_booga.mp3")!
    var actionSequence : SCNAction!
    let node = SCNNode()
    
    
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
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        isRecording = false
        isConnected = false
        
        audioSource.isPositional = true
        audioSource.load()
        
        
        let playAudio = SCNAction.playAudio(audioSource, waitForCompletion: true)
        let waitActionLong = SCNAction.wait(duration: 45)
        let waitActionShort = SCNAction.wait(duration: 20)
        let moveLeft = SCNAction.move(to: SCNVector3(-100, 0, -100), duration: 2)
        let moveMiddle = SCNAction.move(to: SCNVector3(0, 0, -100), duration: 5)
        let moveRight = SCNAction.move(to: SCNVector3(100, 0, -100), duration: 2)
        let sequence = SCNAction.sequence([moveMiddle,
                                           playAudio,
                                           waitActionLong,
                                           moveLeft,
                                           playAudio,
                                           waitActionShort,
                                           moveMiddle,
                                           playAudio,
                                           waitActionLong,
                                           moveRight,
                                           playAudio,
                                           waitActionShort])
        let repeatForever = SCNAction.repeatForever(sequence)
        actionSequence = repeatForever
        
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

