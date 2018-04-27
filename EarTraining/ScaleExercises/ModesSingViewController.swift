//
//  ModesSingViewController.swift
//  EarTraining
//
//  Created by Ariel Todoki on 4/23/18.
//  Copyright © 2018 Ariel Todoki. All rights reserved.
//

import UIKit
import AudioKit

class ModesSingViewController: UIViewController {

    @IBOutlet var exerciseNumLabel: UILabel!
    
    @IBOutlet var note1: UILabel!
    @IBOutlet var note2: UILabel!
    @IBOutlet var note3: UILabel!
    @IBOutlet var note4: UILabel!
    @IBOutlet var note5: UILabel!
    @IBOutlet var note6: UILabel!
    @IBOutlet var note7: UILabel!
    @IBOutlet var note8: UILabel!
    
    @IBOutlet var scaleLabel: UILabel!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var instrumentButtons: [UIButton]!
    @IBOutlet var noteLabels: [UILabel]!
    
    let noteFrequencies = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    let noteFreqRanges = [15.9, 16.83, 17.83, 18.9, 20.01, 21.21, 22.47, 23.8, 25.22, 26.72, 28.31, 29.99, 31.77]
    let noteCents = [0.0, 100.0, 200.0, 300.0, 400.0, 500.0, 600.0, 700.0, 800.0, 900.0, 1000.0, 1100.0]
    let octaveChange = [0,0,-2400.0,-1200.0,0,1200.0,2400.0]
    
    let scaleNames = ["Ionian Scale", "Dorian Scale","Phrygian Scale","Lydian Scale","Mixolydian Scale", "Aeolian Scale", "Locrian Scale"]
    
    let ionian = [0,2,4,5,7,9,11,12]
    let dorian = [0,2,3,5,7,9,10,12]
    let phrygian = [0,1,3,5,7,8,10,12]
    let lydian = [0,2,4,6,7,9,11,12]
    let mixolydian = [0,2,4,5,7,9,10,12]
    let aeolian = [0,2,3,5,7,8,10,12]
    let locrian = [0,1,3,5,6,8,10,12]
    
    var scaleList = [[Int]]()
    
    let noteNamesWithSharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    
    var scaleType = 0
    var firstNote = 0
    var firstNoteOctave = 4
    
    var noteInd1 = 0
    var noteInd2 = 0
    var noteInd3 = 0
    var noteInd4 = 0
    var noteInd5 = 0
    var noteInd6 = 0
    var noteInd7 = 0
    var noteInd8 = 0
    
    var exerciseNum = 1
    
    var timer: Timer!
    
    var conductor = Conductor.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        conductor.closeMic()
        
        // Do any additional setup after loading the view.
        scaleList.append(ionian)
        scaleList.append(dorian)
        scaleList.append(phrygian)
        scaleList.append(lydian)
        scaleList.append(mixolydian)
        scaleList.append(aeolian)
        scaleList.append(locrian)
        
        setScale()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setScale(){
        scaleType = Int(arc4random_uniform(7))
        scaleLabel.text = " Sing a \(scaleNames[scaleType])"
        
        firstNote = Int(arc4random_uniform(12))
        
        noteInd1 = scaleList[scaleType][0] + firstNote
        noteInd2 = scaleList[scaleType][1] + firstNote
        noteInd3 = scaleList[scaleType][2] + firstNote
        noteInd4 = scaleList[scaleType][3] + firstNote
        noteInd5 = scaleList[scaleType][4] + firstNote
        noteInd6 = scaleList[scaleType][5] + firstNote
        noteInd7 = scaleList[scaleType][6] + firstNote
        noteInd8 = scaleList[scaleType][7] + firstNote
    }
    
    func playScale(scale: Array<Int>){
        
        
        for i in scale{
            let noteIndex = firstNote+i
            
            conductor.changePitch(pitch: noteIndex > 11 ? noteCents[noteIndex%12] + octaveChange[firstNoteOctave] + 1200.0 : noteCents[noteIndex] + octaveChange[firstNoteOctave], note: .root)
            conductor.play(note: .root)
            
            usleep(500000)
        }
        
        
    }
    
    func closeInstButtons(){
        for b in instrumentButtons{
            b.isHidden = true
        }
    }
    
    
    // MARK: - Button Actions
    
    @IBAction func changeOctave(sender: UISlider){
        //change octave of first note in scale
        firstNoteOctave = Int(sender.value)
        
        note1.text = "\(noteNamesWithSharps[firstNote])\(firstNoteOctave)"
    }
    
    @IBAction func playFirstNote(sender: UIButton){
        conductor.changePitch(pitch: noteCents[noteInd1%12] + octaveChange[firstNoteOctave] , note: .root)
        conductor.play(note: .root)
    }
    
    @IBAction func playAnswer(sender: UIButton){
        
        playScale(scale: scaleList[scaleType])
        
    }
    
    @IBAction func next(sender: UIButton){
        setScale()
        exerciseNum += 1
        exerciseNumLabel.text = "Exercise # \(exerciseNum)"
        
        var i = 8
        for l in noteLabels{
            l.backgroundColor = UIColor.white
            l.text = "Note \(i)"
            i -= 1
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
    
    @IBAction func handleGesture(_ sender: UILongPressGestureRecognizer){
        if sender.state == UIGestureRecognizerState.began{
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(ModesSingViewController.updateUI), userInfo: nil, repeats: true)
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
            
            
            if(note1.backgroundColor != UIColor.green){
                changeNoteLabel(label: note1, noteIndex: noteInd1, sungNoteIndex: sungNoteIndex, sungOctave: sungOctave)
            }else if(note2.backgroundColor != UIColor.green){
                changeNoteLabel(label: note2, noteIndex: noteInd2, sungNoteIndex: sungNoteIndex, sungOctave: sungOctave)
            }else if(note3.backgroundColor != UIColor.green){
                changeNoteLabel(label: note3, noteIndex: noteInd3, sungNoteIndex: sungNoteIndex, sungOctave: sungOctave)
            }else if(note4.backgroundColor != UIColor.green){
                changeNoteLabel(label: note4, noteIndex: noteInd4, sungNoteIndex: sungNoteIndex, sungOctave: sungOctave)
            }else if(note5.backgroundColor != UIColor.green){
                changeNoteLabel(label: note5, noteIndex: noteInd5, sungNoteIndex: sungNoteIndex, sungOctave: sungOctave)
            }else if(note6.backgroundColor != UIColor.green){
                changeNoteLabel(label: note6, noteIndex: noteInd6, sungNoteIndex: sungNoteIndex, sungOctave: sungOctave)
            }else if(note7.backgroundColor != UIColor.green){
                changeNoteLabel(label: note7, noteIndex: noteInd7, sungNoteIndex: sungNoteIndex, sungOctave: sungOctave)
            }else if(note8.backgroundColor != UIColor.green){
                changeNoteLabel(label: note8, noteIndex: noteInd8, sungNoteIndex: sungNoteIndex, sungOctave: sungOctave)
            }else{
                note8.text = "Correct!"
            }
            
        }
    }
    
    func changeNoteLabel(label: UILabel, noteIndex: Int, sungNoteIndex: Int, sungOctave: Int){
        label.text = "\(noteNamesWithSharps[sungNoteIndex])\(Int(sungOctave))"
        // checks if sung note is correct
        if(sungNoteIndex == (noteIndex > 11 ? noteIndex % 12 : noteIndex)){
            label.backgroundColor = UIColor.green
        }else{
            label.backgroundColor = UIColor.red
        }
    }
    
    @IBAction func unwindSegueScaleSing(segue: UIStoryboardSegue) {
        
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
