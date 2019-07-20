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
    
    var blacklist: [String] = ["like", "actually", "you know", "damn"]
    var blacklistCount: Int = 0
    
    var wordCount: Int = 0
    var lastTextUpdate: Date = Date()
    
    var enabledMetrics: [Metric] = [.headLevel, .speakingRate, .sway]
    
    let sensors: [SensorType] = [.accelerometer, .rotation, .gyroscope, .gameRotation]
    let samplePeriod: SamplePeriod = ._20ms
    
    var manager: CaptureManager!
    
    var session: (WearableDeviceSession)!
    var device: WearableDevice!
    
    var startTime : Date?
    
    
    var audioPlayer: AVAudioPlayer?
    
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
            self.navigationItem.title = self.isRecording ? "Recording" : ""
            
            self.navigationItem.rightBarButtonItem?.isEnabled = !isRecording
            if isRecording {
                manager.clearAll()
                blacklistCount = 0
                alert(text: "Recording")
            } else {
                alert(text: "Stopped Recording")
                self.performSegue(withIdentifier: "SummarySegue", sender: self)
            }
        }
    }
    
    var isConnected = false {
        didSet {
            connectButton.setTitle(isConnected ? "Disconnect" : "Connect", for: [])
            recordButton.isEnabled = isConnected
            if !isConnected && isRecording {
                toggleRecording()
                isRecording = false
            }
        }
    }
    
    @IBAction func recordButtonTapped() {
        if isConnected {
            isRecording = !isRecording
            toggleSensors()
            toggleRecording()
        }
    }
    
    func initAudio() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, options: .allowBluetooth)
            try audioSession.setMode(AVAudioSession.Mode.default)
            try audioSession.setActive(true)
        } catch {
            print(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //isRecording = false
        isConnected = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager = CaptureManager(metrics: enabledMetrics)
        manager.vc = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SettingsSegue" {
            let settingsVC = segue.destination as? SettingsViewController
            settingsVC?.vc = self
        } else if segue.identifier == "SummarySegue" {
            let statisticsVC = segue.destination as? StatisticsViewController
            statisticsVC?.vc = self
            statisticsVC?.duration = DateInterval(start: startTime, end: Date())
            
        }
    }
}

extension ViewController: AVAudioPlayerDelegate {
    
    func alert(text: String) {
        let synth = AVSpeechSynthesizer()
        synth.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synth.speak(utterance)
    }
    
    func playAudio(filename: String) {
        let url = URL.init(fileURLWithPath: Bundle.main.path(forResource: filename, ofType: "mp3")!)
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
        } catch let error as NSError {
            print("audioPlayer error \(error.localizedDescription)")
        }
        audioPlayer!.play()
    }
}

