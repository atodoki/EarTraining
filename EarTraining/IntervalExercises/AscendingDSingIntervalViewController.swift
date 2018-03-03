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
    @IBOutlet private var lowestNoteLabel: UILabel!
    @IBOutlet private var highestNoteLabel: UILabel!
    

    var givenNoteIndex = 0
    var givenNoteFreq = 0.0
    
    var lowOctave = 3.0
    var highOctave = 5.0
    var answerOctave = 0.0
    var intervalIndex = 0
    var answerNoteFreq = 0.0
    
    var lowValueIndex = 17
    var highValueIndex = 12
    
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
    
    let lowRangeSlider = ["C2", "C#2", "D2", "D#2", "E2", "F2", "F#2", "G2","G#2", "A2", "A#2", "B2", "C3","C#3", "D3", "D#3", "E3", "F3", "F#3","G3", "G#3", "A3", "A#3","B3"]
    
    let highRangeSlider = ["C4", "C#4", "D4", "D#4", "E4", "F4", "F#4", "G4","G#4", "A4", "A#4", "B4", "C5","C#5", "D5", "D#5", "E5", "F5", "F#5","G5", "G#5", "A5", "A#5","B5"]
    
    let intervalDiff = [2, 4, 5, 7, 9, 11, 12]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        AKSettings.audioInputEnabled = true
        mic = AKMicrophone()
        tracker = AKFrequencyTracker(mic)
        silence = AKBooster(tracker, gain: 0)
        //AudioKit.output = silence
        
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
    
    @IBAction func changeHighNote(sender: UISlider) {
        highValueIndex = Int(sender.value)
        highestNoteLabel.text = "Highest Note: \(highRangeSlider[highValueIndex])"
        
        if(highValueIndex < 12){
            highOctave = 4.0
        }
        else {
            highOctave = 5.0
        }
    
    }
    
    @IBAction func changeLowNote(sender: UISlider){
        lowValueIndex = Int(sender.value)
        lowestNoteLabel.text = "Lowest Note: \(lowRangeSlider[lowValueIndex])"
        
        if (lowValueIndex < 12) {
            lowOctave = 2.0
        }
        else{
            lowOctave = 3.0
        }
    }
    
    
    @IBAction func replay(sender: UIButton){
        AudioKit.output = oscillator
        oscillator.frequency = givenNoteFreq
        oscillator.start()
        sleep(2)
        oscillator.stop()
    }
    
    @IBAction func playAnswer(sender: UIButton){
        AudioKit.output = oscillator
        oscillator.frequency = answerNoteFreq
        oscillator.start()
        sleep(2)
        oscillator.stop()
    }
    
    @IBAction func start(sender: UIButton){
        AudioKit.output = oscillator
        
        // reset label background colors
        sungNote.backgroundColor = UIColor.white
        givenNote.backgroundColor = UIColor.white
        
        // finds note that is not below the lowest note, or not in the same octave or higher than high octave range if it were pushed up an octave
        repeat{
            givenNoteIndex = Int(arc4random_uniform(12))
        }while(givenNoteIndex < lowValueIndex%12)&&(lowOctave+1 >= highOctave)

        // Play note within user specified range
        var currLowOctave = lowOctave
        if(givenNoteIndex < lowValueIndex%12){
            currLowOctave = lowOctave + 1
        }else{
            currLowOctave = lowOctave
        }
        givenNoteFreq = noteFrequencies[givenNoteIndex] * pow(2,currLowOctave)
        givenNote.text = "\(noteNamesWithSharps[givenNoteIndex])\(Int(currLowOctave))"
        
        
        playDiatonicInterval(currLowOctave: currLowOctave)
        

    }

    func playDiatonicInterval(currLowOctave: Double){
    // pick random diatonic interval
    var intDiff = 0
    intervalIndex = 0
    repeat{
        intervalIndex = Int(arc4random_uniform(7))
        intDiff = intervalDiff[intervalIndex]
        print(intDiff)
        
    } while (givenNoteIndex + intDiff > 11)&&((givenNoteIndex+intDiff)%12 > highValueIndex%12)&&((currLowOctave+1 == highOctave)||currLowOctave == highOctave)&&((lowValueIndex < 22)||(highValueIndex != 0)) // keep picking a random interval until it is in the range specified by user
    
    if(lowValueIndex < 22 || highValueIndex != 0){ // checks if interval range specified by user is too small
        intervalLabel.text = "Sing \(intervalNames[intervalIndex]) above"
        
        //calculate answer
        if((givenNoteIndex + intDiff) > 11){
            answerNoteFreq = noteFrequencies[(givenNoteIndex + intDiff)%12] * pow(2,currLowOctave+1)
            answerOctave = currLowOctave+1
        }else {
            answerNoteFreq = noteFrequencies[givenNoteIndex + intDiff] * pow(2,currLowOctave)
            answerOctave = currLowOctave
        }
        
        // play given note
        oscillator.frequency = givenNoteFreq
        oscillator.start()
        sleep(2)
        oscillator.stop()
    }
    else{
        intervalLabel.text = "Interval Range too small"
    }
    
}
    
    
    @objc func updateUI(){
        AudioKit.output = silence
        var frequency0 = tracker.frequency
        var sungOctave = 0.0
        var sungNoteIndex = 0;
        print(mic.isStarted)
        print(tracker.amplitude)
        if(tracker.amplitude > 0.09){
            
            // Get note frequency in octave 0
            while(frequency0 > noteFrequencies[noteFrequencies.count-1]){
                frequency0 /= 2
                sungOctave += 1
            }
            while(frequency0 < noteFrequencies[0]){
                frequency0 *= 2
                sungOctave -= 1
            }
            
            // get note name
            for i in 0...11{
                if(frequency0 > noteFreqRanges[i] && frequency0 < noteFreqRanges[i+1]){
                    sungNoteIndex = i
                }
            }
            sungNote.text = "\(noteNamesWithSharps[sungNoteIndex])\(Int(sungOctave))"
            
            //checks if sung interval is correct
            let ansIndex = (givenNoteIndex + intervalDiff[intervalIndex])%12
            if((ansIndex == sungNoteIndex) && (sungOctave == answerOctave)){ // if correct pitch class and octave
                    if(frequency0 > inTuneLow[sungNoteIndex] && frequency0 < inTuneHigh[sungNoteIndex]){ // checks if sung note is within -10 and +10 cents of correct pitch
                    sungNote.backgroundColor = UIColor.green
                    }else{
                    sungNote.backgroundColor = UIColor.orange
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
