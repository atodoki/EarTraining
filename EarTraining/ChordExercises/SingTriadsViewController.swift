//
//  SingTriadsViewController.swift
//  EarTraining
//
//  Created by Ariel Todoki on 4/3/18.
//  Copyright © 2018 Ariel Todoki. All rights reserved.
//

import UIKit
import AudioKit
import AudioKitUI

class SingTriadsViewController: UIViewController {
    
    @IBOutlet var exerciseNumLabel: UILabel!
    @IBOutlet var rootNote: UILabel!
    @IBOutlet var thirdNote: UILabel!
    @IBOutlet var fifthNote: UILabel!
    @IBOutlet var triadLabel: UILabel!
    @IBOutlet var recordButton: UIButton!
    
    let noteFrequencies = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    let noteFreqRanges = [15.9, 16.83, 17.83, 18.9, 20.01, 21.21, 22.47, 23.8, 25.22, 26.72, 28.31, 29.99, 31.77]
    let noteCents = [0.0, 100.0, 200.0, 300.0, 400.0, 500.0, 600.0, 700.0, 800.0, 900.0, 1000.0, 1100.0]
    let noteNamesWithSharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    let noteNamesWithFlats = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]
    let triadNames = ["Major Triad", "Minor Triad", "Diminished Triad", "Augmented Triad"]
    
    let majChord = [4,7]
    let minChord = [3,7]
    let dimChord = [3,6]
    let augChord = [4,8]
    
    var chordList = [[Int]]()
    
    var chordType = 0
    var root = 0
    var third = 0
    var fifth = 0
    
    var exerciseNum = 1
    
    var rootNoteName = ""
    var thirdNoteName = ""
    var fifthNoteName = ""
    
    let samplerRoot = AKSampler()
    let samplerThird = AKSampler()
    let samplerFifth = AKSampler()
    
    var tpRoot: AKTimePitch!
    var tpThird: AKTimePitch!
    var tpFifth: AKTimePitch!
    
    var mic: AKMicrophone!
    var tracker: AKFrequencyTracker!
    var silence: AKBooster!
    var timer: Timer!
    
    var mixer = AKMixer()
    
    let soundNames = ["Kawai-K11-GrPiano-C4", "Ensoniq-SQ-1-Clarinet-C4", "Ensoniq-SQ-1-French-Horn-C4", "Alesis-Fusion-Pizzicato-Strings-C4"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AKSettings.audioInputEnabled = true
        mic = AKMicrophone()
        tracker = AKFrequencyTracker(mic)
        silence = AKBooster(tracker, gain: 0)
        
        chordList.append(majChord)
        chordList.append(minChord)
        chordList.append(dimChord)
        chordList.append(augChord)
        
        try! samplerRoot.loadWav("../\(soundNames[0])")
        try! samplerThird.loadWav("../\(soundNames[0])")
        try! samplerFifth.loadWav("../\(soundNames[0])")
        
        tpRoot = AKTimePitch(samplerRoot)
        tpRoot.rate = 2.0
        
        tpThird = AKTimePitch(samplerThird)
        tpThird.rate = 2.0
        
        tpFifth = AKTimePitch(samplerFifth)
        tpFifth.rate = 2.0
        
        setChord()
        
        mixer.connect(input: tpRoot)
        mixer.connect(input: tpThird)
        mixer.connect(input: tpFifth)
        
        AudioKit.output = mixer

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AudioKit.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AudioKit.stop()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChord(){
        chordType = Int(arc4random_uniform(4))
        root = Int(arc4random_uniform(12))
        third = root + chordList[chordType][0]
        fifth = root + chordList[chordType][1]
        
        triadLabel.text = "Sing a \(triadNames[chordType])"
        
        tpRoot.pitch = noteCents[root]
        tpThird.pitch = (third > 11 ? noteCents[third%12] + 1200.0 : noteCents[third])
        tpFifth.pitch = (fifth > 11 ? noteCents[fifth%12] + 1200.0 : noteCents[fifth])
        
        
        // set note name variables ???? do you need this?
        rootNoteName = noteNamesWithFlats[root]
        thirdNoteName = (third > 11 ? noteNamesWithFlats[third%12] : noteNamesWithFlats[third])
        fifthNoteName = (fifth > 11 ? noteNamesWithFlats[fifth%12] : noteNamesWithFlats[fifth])
    }
    
    // MARK: - Button Actions
    @IBAction func playRoot(sender: UIButton){
        AudioKit.output = mixer
        samplerRoot.play()
        
    }
    
    @IBAction func playChordSequence(sender: UIButton){
        AudioKit.output = mixer
        samplerRoot.play()
        sleep(1)
        samplerThird.play()
        sleep(1)
        samplerFifth.play()
    }
    
    @IBAction func playChord(sender: UIButton){
        AudioKit.output = mixer
        samplerRoot.play()
        samplerThird.play()
        samplerFifth.play()
    }
    
    @IBAction func next(sender: UIButton){
        setChord()
        rootNote.backgroundColor = UIColor.white
        thirdNote.backgroundColor = UIColor.white
        fifthNote.backgroundColor = UIColor.white
        
        rootNote.text = "Sung Note"
        thirdNote.text = "Sung Note"
        fifthNote.text = "Sung Note"
        
        exerciseNum += 1
        exerciseNumLabel.text = "Exercise #\(exerciseNum)"
    }
    
    @IBAction func handleGesture(_ sender: UILongPressGestureRecognizer){
        if sender.state == UIGestureRecognizerState.began{
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(SingTriadsViewController.updateUI), userInfo: nil, repeats: true)
            recordButton.setTitle("Listening...", for: .normal)
        }
        else if sender.state == UIGestureRecognizerState.ended{
            timer.invalidate()
            recordButton.setTitle("Hold to Record", for: .normal)
        }
    }
    
    @objc func updateUI(){
        AudioKit.output = silence
        var frequency0 = tracker.frequency
        var sungOctave = 0.0
        var sungNoteIndex = 0
        
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
            
            if(rootNote.backgroundColor != UIColor.green){
                changeNoteLabel(label: rootNote, noteIndex: root, sungNoteIndex: sungNoteIndex, sungOctave: sungOctave)
            }else if(thirdNote.backgroundColor != UIColor.green){
                changeNoteLabel(label: thirdNote, noteIndex: third, sungNoteIndex: sungNoteIndex, sungOctave: sungOctave)
            }else{
                changeNoteLabel(label: fifthNote, noteIndex: fifth, sungNoteIndex: sungNoteIndex, sungOctave: sungOctave)
            }
            
            
            
        }
    }
    
    func changeNoteLabel(label: UILabel, noteIndex: Int, sungNoteIndex: Int, sungOctave: Double){
        label.text = "\(noteNamesWithFlats[sungNoteIndex])\(Int(sungOctave))"
        // checks if sung note is correct
        if(sungNoteIndex == (noteIndex > 11 ? noteIndex % 12 : noteIndex)){
            label.backgroundColor = UIColor.green
        }else{
            label.backgroundColor = UIColor.red
        }
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