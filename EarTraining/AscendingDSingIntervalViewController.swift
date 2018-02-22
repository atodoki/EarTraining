//
//  AscendingDSingIntervalViewController.swift
//  EarTraining
//
//  Created by Ariel Todoki on 2/14/18.
//  Copyright © 2018 Ariel Todoki. All rights reserved.
//

import UIKit
import AudioKit
import AudioKitUI

class AscendingDSingIntervalViewController: UIViewController {
    
    @IBOutlet private var givenNote: UILabel!
    @IBOutlet private var sungNote: UILabel!
    @IBOutlet private var intervalLabel: UILabel!
    @IBOutlet private var recordButton: UIButton!
    

    var givenNoteIndex = 0
    var octaveRange = 4.0
    var intervalIndex = 0
    let oscillator = AKOscillator()
    
    var mic: AKMicrophone!
    var tracker: AKFrequencyTracker!
    var silence: AKBooster!
    var timer: Timer!
    
    
    let noteFrequencies = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    let noteNamesWithSharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    let noteNamesWithFlats = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]
    
    let noteFreqRanges = [15.9, 16.83, 17.83, 18.9, 20.01, 21.21, 22.47, 23.8, 25.22, 26.72, 28.31, 29.99, 31.77]
    
    let inTuneLow = [16.26, 17.22, 18.24, 19.33, 20.48, 21.7, 22.99, 24.36, 25.81, 27.34, 28.97, 30.69]
    
    let inTuneHigh = [16.45, 17.42, 18.46, 19.56, 20.72, 21.95, 23.26, 24.64, 26.11, 27.66, 29.3, 31.05]
    
    let intervalNames = ["Major 2nd", "Major 3rd", "Perfect 4th", "Perfect 5th", "Major 6th", "Major 7th", "Octave"]
    
    let intervalDiff = [2, 4, 5, 7, 9, 11, 12]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        AKSettings.audioInputEnabled = true
        mic = AKMicrophone()
        tracker = AKFrequencyTracker(mic)
        silence = AKBooster(tracker, gain: 0)
        AudioKit.output = silence
        
        oscillator.frequency = 0.0
        oscillator.amplitude = 0.5
        AudioKit.output = oscillator

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AudioKit.start()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AudioKit.stop()
    }
    
    @IBAction func start(sender: UIButton){
        // Play note within user specified range
        givenNoteIndex = Int(arc4random_uniform(12))
        oscillator.frequency = noteFrequencies[givenNoteIndex] * pow(2,octaveRange)
        givenNote.text = "\(noteNamesWithSharps[givenNoteIndex])\(Int(octaveRange))"
        
        
        intervalIndex = Int(arc4random_uniform(UInt32(intervalNames.count)))
        intervalLabel.text = "Sing \(intervalNames[intervalIndex]) above"
    
        // reset label background colors
        sungNote.backgroundColor = UIColor.white
        givenNote.backgroundColor = UIColor.white
        
        oscillator.start()
        sleep(2)
        oscillator.stop()
        

    }
    
    
    @objc func updateUI(){
        var frequency0 = tracker.frequency
        var octave = 0
        var noteIndex = 0;
        print(mic.isStarted)
        print(tracker.amplitude)
        if(tracker.amplitude > 0.09){
//            frequencyLabel.text = String(format: "%0.1f", tracker.frequency)
//            amplitudeLabel.text = String(format: "%0.2f", tracker.amplitude)
            
            // Get note frequency in octave 0
            while(frequency0 > noteFrequencies[noteFrequencies.count-1]){
                frequency0 /= 2
                octave += 1
            }
            while(frequency0 < noteFrequencies[0]){ // don't need this??
                //frequency0 *= 2 ?????
                octave -= 1
            }
            
            // get note name
            for i in 0...11{
                if(frequency0 > noteFreqRanges[i] && frequency0 < noteFreqRanges[i+1]){
                    noteIndex = i
                }
            }
            sungNote.text = "\(noteNamesWithSharps[noteIndex])\(octave)"
            
            // preliminary check if sung note is higher than given note
//            if((Int(octaveRange) == octave) || (octave > Int(octaveRange))){
//
//
//            } else {
//                sungNote.backgroundColor = UIColor.red
//            }
            
            //checks if sung interval is correct
            let intDiff = givenNoteIndex + intervalDiff[intervalIndex]
            if(intDiff%12 == noteIndex){
                if((intDiff > 11 && octave > Int(octaveRange)) || (intDiff < 12 && octave == Int(octaveRange))){
                    if(frequency0 > inTuneLow[noteIndex] && frequency0 < inTuneHigh[noteIndex]){
                    sungNote.backgroundColor = UIColor.green
                    }else{
                    sungNote.backgroundColor = UIColor.orange
                    }
                    
                }else{
                    sungNote.backgroundColor = UIColor.red
                }
            }else {
                sungNote.backgroundColor = UIColor.red
            }
            
            
            
      
            
        }
        
    }
    
    @IBAction func handleGesture(_ sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began{
//            tracker.start()
//            mic.start()
            
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(AscendingDSingIntervalViewController.updateUI), userInfo: nil, repeats: true)
            recordButton.setTitle("Listening...", for: .normal)
        }
        else if sender.state == UIGestureRecognizerState.ended{
//            tracker.stop()
            timer.invalidate()
//            mic.stop()
            recordButton.setTitle("Press to Record", for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
