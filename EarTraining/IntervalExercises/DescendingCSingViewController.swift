//
//  DescendingCSingViewController.swift
//  EarTraining
//
//  Created by Ariel Todoki on 4/26/18.
//  Copyright © 2018 Ariel Todoki. All rights reserved.
//

import UIKit
import AudioKit

class DescendingCSingViewController: UIViewController {

    @IBOutlet var givenNote: UILabel!
    @IBOutlet var sungNote: UILabel!
    @IBOutlet var intervalLabel: UILabel!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var instrumentButtons: [UIButton]!
    @IBOutlet var exerciseNumLabel: UILabel!
    
    var bNoteOctave = 4
    var tNoteOctave = 4
    var bottomNote = 0
    var topNote = 0
    var intervalSize = 0
    var intervalIndex = 0
    
    var exerciseNum = 1
    
    var conductor = Conductor.sharedInstance
    
    var timer: Timer!
    
    let noteFrequencies = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    
    let noteCents = [0.0, 100.0, 200.0, 300.0, 400.0, 500.0, 600.0, 700.0, 800.0, 900.0, 1000.0, 1100.0]
    let octaveChange = [0,0,-2400.0,-1200.0,0,1200.0,2400.0]
    
    let noteNamesWithSharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    let noteNamesWithFlats = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]
    
    let noteFreqRanges = [15.9, 16.83, 17.83, 18.9, 20.01, 21.21, 22.47, 23.8, 25.22, 26.72, 28.31, 29.99, 31.77]
    
    let inTuneLow = [16.26, 17.22, 18.24, 19.33, 20.48, 21.7, 22.99, 24.36, 25.81, 27.34, 28.97, 30.69]
    
    let inTuneHigh = [16.45, 17.42, 18.46, 19.56, 20.72, 21.95, 23.26, 24.64, 26.11, 27.66, 29.3, 31.05]
    
    let intervalNames = ["Minor 2nd", "Major 2nd", "Minor 3rd","Major 3rd", "Perfect 4th", "Tritone","Perfect 5th", "Minor 6th","Major 6th", "Minor 7th","Major 7th", "Octave"]
    
    let chromaticIntervals = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        conductor.setMic()
        setInterval()
        
    }
    
    
    func setInterval(){
        topNote = Int(arc4random_uniform(12)) // random number 0<n<12-1
        intervalIndex = chromaticIntervals.randomIndex
        intervalSize = chromaticIntervals[intervalIndex]
        bottomNote = topNote - intervalSize
        bNoteOctave = (bottomNote < 0 ? tNoteOctave - 1 : tNoteOctave)
        bottomNote += 12

        givenNote.text = "\(noteNamesWithSharps[topNote])\(tNoteOctave)"
        intervalLabel.text = "Sing \(intervalNames[intervalIndex])"
        
    }
    
    func closeInstButtons(){
        for b in instrumentButtons{
            b.isHidden = true
        }
    }
    
    @IBAction func instruments(sender: UIButton){
        if(instrumentButtons[0].isHidden){
            for b in instrumentButtons{
                b.isHidden = false
            }
        }else{
            closeInstButtons()
        }
    }
    
    @IBAction func piano(sender: UIButton){
        conductor.changeInstrument(instr: .piano)
        
        closeInstButtons()
    }
    
    @IBAction func clarinet(sender: UIButton){
        conductor.changeInstrument(instr: .clarinet)
        
        closeInstButtons()
    }
    
    @IBAction func frenchHorn(sender: UIButton){
        conductor.changeInstrument(instr: .french_horn)
        
        closeInstButtons()
    }
    
    @IBAction func string(sender: UIButton){
        conductor.changeInstrument(instr: .pizz_strings)
        
        closeInstButtons()
    }
    
    @IBAction func changeOctave(sender: UISlider){
        tNoteOctave = Int(sender.value)
        bottomNote = topNote - intervalSize
        bNoteOctave = (bottomNote < 0 ? tNoteOctave - 1 : tNoteOctave)
        bottomNote += 12
        givenNote.text = "\(noteNamesWithSharps[topNote])\(tNoteOctave)"
    }
    
    
    @IBAction func replay(sender: UIButton){
        conductor.changePitch(pitch: noteCents[topNote] + octaveChange[tNoteOctave], note: .root)
        conductor.play(note: .root)

    }
    
    @IBAction func playAnswer(sender: UIButton){
        conductor.changePitch(pitch: noteCents[bottomNote%12] + octaveChange[bNoteOctave], note: .root)
        conductor.play(note: .root)

    }
    
    @IBAction func start(sender: UIButton){
        
        // reset label background colors
        sungNote.backgroundColor = UIColor.white
        sungNote.text = "Sung Note"
        givenNote.backgroundColor = UIColor.white
        
        setInterval()
        
        conductor.changePitch(pitch: noteCents[topNote] + octaveChange[tNoteOctave], note: .root)
        conductor.play(note: .root)
        
        exerciseNum += 1
        exerciseNumLabel.text = "Exercise # \(exerciseNum)"
        
        sender.setTitle("Next", for: .normal)
        
    }
    
    @objc func updateUI(){
        var frequency0 = conductor.listenFreq()
        var sungOctave = 0.0
        var sungNoteIndex = 0;
        
        if(conductor.listenAmp() > 0.05){
            
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
            
            if((sungNoteIndex == bottomNote%12) && (Int(sungOctave) == bNoteOctave)){ // if correct pitch class and octave
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
            
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(DescendingDSingViewController.updateUI), userInfo: nil, repeats: true)
            recordButton.setTitle("Listening...", for: .normal)
        }
        else if sender.state == UIGestureRecognizerState.ended{
            timer.invalidate()
            recordButton.setTitle("Hold to Record", for: .normal)
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
