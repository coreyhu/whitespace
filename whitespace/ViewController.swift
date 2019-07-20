//
//  ViewController.swift
//  whitespace
//
//  Created by Corey Hu on 7/19/19.
//  Copyright © 2019 Corey Hu. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    
    public let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    public var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    public var recognitionTask: SFSpeechRecognitionTask?
    public let audioEngine = AVAudioEngine()
    @IBOutlet var textView : UITextView!
    @IBOutlet var recordButton : UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        recordButton.isEnabled = false
    }
    
    @IBAction func connectToDevice() {
        setupDevice()
    }
    
    @IBAction func startRecording() {
        initSpeech();
        initPosition();
    }
}

