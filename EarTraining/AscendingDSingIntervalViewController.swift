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
    @IBOutlet private var recordButton: UIButton!

    
    var mic: AKMicrophone!
    var tracker: AKFrequencyTracker!
    var silence: AKBooster!
    var timer: Timer!
    
    
    let noteFrequencies = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    let noteNamesWithSharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    let noteNamesWithFlats = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]
    
    let noteFreqRanges = [15.9, 16.83, 17.83, 18.9, 20.01, 21.21, 22.47, 23.8, 25.22, 26.72, 28.31, 29.99, 31.77]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        AKSettings.audioInputEnabled = true
        mic = AKMicrophone()
        tracker = AKFrequencyTracker(mic)
        silence = AKBooster(tracker, gain: 0)
        AudioKit.output = silence

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AudioKit.start()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AudioKit.stop()
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
                frequency0 *= 2
            }
            
            // get note name
            for i in 0...11{
                if(frequency0 > noteFreqRanges[i] && frequency0 < noteFreqRanges[i+1]){
                    noteIndex = i
                }
            }
            sungNote.text = noteNamesWithSharps[noteIndex]
            
            
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
