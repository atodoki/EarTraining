//
//  SingSeventhsViewController.swift
//  EarTraining
//
//  Created by Ariel Todoki on 4/26/18.
//  Copyright © 2018 Ariel Todoki. All rights reserved.
//

import UIKit

class SingSeventhsViewController: UIViewController {

    @IBOutlet var exerciseNumLabel: UILabel!
    @IBOutlet var rootNote: UILabel!
    @IBOutlet var thirdNote: UILabel!
    @IBOutlet var fifthNote: UILabel!
    @IBOutlet var seventhNote: UILabel!
    @IBOutlet var chordLabel: UILabel!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var instrumentButtons: [UIButton]!
    
    let noteFrequencies = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    let noteFreqRanges = [15.9, 16.83, 17.83, 18.9, 20.01, 21.21, 22.47, 23.8, 25.22, 26.72, 28.31, 29.99, 31.77]
    let noteCents = [0.0, 100.0, 200.0, 300.0, 400.0, 500.0, 600.0, 700.0, 800.0, 900.0, 1000.0, 1100.0]
    let octaveChange = [0,0,-2400.0,-1200.0,0,1200.0,2400.0]
    
    let noteNamesWithSharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    let noteNamesWithFlats = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]
    let chordNames = ["Major Seventh", "Minor Seventh", "Dominant Seventh", "Half-Diminished Seventh", "Diminished Seventh"]
    
    let majSChord = [4,7,11]
    let minSChord = [3,7,10]
    let domChord = [4,7,10]
    let hDimChord = [3,6,10]
    let fDimChord = [3,6,9]
    
    var chordList = [[Int]]()
    
    var chordType = 0
    var root = 0
    var third = 0
    var fifth = 0
    var seventh = 0
    
    var exerciseNum = 1
    
    var rootOctave = 4
    var thirdOctave = 4
    var fifthOctave = 4
    var seventhOctave = 4
    
    
    var timer: Timer!
    
    var conductor = Conductor.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chordList.append(majSChord)
        chordList.append(minSChord)
        chordList.append(domChord)
        chordList.append(hDimChord)
        chordList.append(fDimChord)
        
        conductor.setMic()
        setChord()

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChord(){
        chordType = Int(arc4random_uniform(5))
        root = Int(arc4random_uniform(12))
        third = root + chordList[chordType][0]
        fifth = root + chordList[chordType][1]
        seventh = root + chordList[chordType][2]
        
        thirdOctave = third > 11 ? rootOctave + 1 : rootOctave
        fifthOctave = fifth > 11 ? rootOctave + 1 : rootOctave
        seventhOctave = seventh > 11 ? rootOctave + 1 : rootOctave
        
        chordLabel.text = "Sing a \(chordNames[chordType]) chord"
        
        conductor.changePitch(pitch: noteCents[root] + octaveChange[rootOctave], note: .root)
        conductor.changePitch(pitch: noteCents[third%12] + octaveChange[thirdOctave], note: .third)
        conductor.changePitch(pitch: noteCents[fifth%12] + octaveChange[fifthOctave], note: .fifth)
        conductor.changePitch(pitch: noteCents[seventh%12] + octaveChange[seventhOctave], note: .seventh)
        
    }
    
    func closeInstButtons(){
        for b in instrumentButtons{
            b.isHidden = true
        }
    }
    
    // MARK: - Button Actions
    
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
    
    @IBAction func playRoot(sender: UIButton){
        conductor.play(note: .root)
        
    }
    
    @IBAction func playChordSequence(sender: UIButton){
        conductor.play(note: .root)
        sleep(1)
        conductor.play(note: .third)
        sleep(1)
        conductor.play(note: .fifth)
        sleep(1)
        conductor.play(note: .seventh)
    }
    
    @IBAction func playChord(sender: UIButton){
        conductor.play(note: .root)
        conductor.play(note: .third)
        conductor.play(note: .fifth)
        conductor.play(note: .seventh)
        
    }
    
    @IBAction func next(sender: UIButton){
        setChord()

        rootNote.backgroundColor = UIColor.white
        thirdNote.backgroundColor = UIColor.white
        fifthNote.backgroundColor = UIColor.white
        seventhNote.backgroundColor = UIColor.white
        
        rootNote.text = "Sung Note"
        thirdNote.text = "Sung Note"
        fifthNote.text = "Sung Note"
        seventhNote.text = "Sung Note"
        
        
        exerciseNum += 1
        exerciseNumLabel.text = "Exercise #\(exerciseNum)"
    }
    
    @IBAction func changeOctave(sender: UISlider){
        rootOctave = Int(sender.value)
        thirdOctave = third > 11 ? rootOctave + 1 : rootOctave
        fifthOctave = fifth > 11 ? rootOctave + 1 : rootOctave
        seventhOctave = seventh > 11 ? rootOctave + 1 : rootOctave
        
        conductor.changePitch(pitch: noteCents[root] + octaveChange[rootOctave], note: .root)
        conductor.changePitch(pitch: noteCents[third%12] + octaveChange[thirdOctave], note: .third)
        conductor.changePitch(pitch: noteCents[fifth%12] + octaveChange[fifthOctave], note: .fifth)
        conductor.changePitch(pitch: noteCents[seventh%12] + octaveChange[seventhOctave], note: .seventh)
        
        rootNote.text = "\(noteNamesWithSharps[root])\(rootOctave)"
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
        var frequency0 = conductor.listenFreq()
        var sungOctave = 0
        var sungNoteIndex = 0
        
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
            
            if(rootNote.backgroundColor != UIColor.green){
                changeNoteLabel(label: rootNote, noteIndex: root, sungNoteIndex: sungNoteIndex, sungOctave: sungOctave, noteOctave: rootOctave)
            }else if(thirdNote.backgroundColor != UIColor.green){
                changeNoteLabel(label: thirdNote, noteIndex: third, sungNoteIndex: sungNoteIndex, sungOctave: sungOctave, noteOctave: thirdOctave)
            }else if(fifthNote.backgroundColor != UIColor.green){
                changeNoteLabel(label: fifthNote, noteIndex: fifth, sungNoteIndex: sungNoteIndex, sungOctave: sungOctave, noteOctave: fifthOctave)
            }else {
                changeNoteLabel(label: seventhNote, noteIndex: seventh, sungNoteIndex: sungNoteIndex, sungOctave: sungOctave, noteOctave: seventhOctave)
            }
            
            
            
        }
    }
    
    func changeNoteLabel(label: UILabel, noteIndex: Int, sungNoteIndex: Int, sungOctave: Int, noteOctave: Int){
        label.text = "\(noteNamesWithSharps[sungNoteIndex])\(Int(sungOctave))"
        // checks if sung note is correct
        if(sungNoteIndex == (noteIndex > 11 ? noteIndex % 12 : noteIndex) && sungOctave == noteOctave){
            label.backgroundColor = UIColor.green
        }else{
            label.backgroundColor = UIColor.red
        }
    }
    
    @IBAction func unwindSegueChordSing(segue: UIStoryboardSegue) {
        
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
