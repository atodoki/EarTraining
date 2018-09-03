//
//  MajMinSingViewController.swift
//  EarTraining
//
//  Created by Ariel Todoki on 4/23/18.
//  Copyright © 2018 Ariel Todoki. All rights reserved.
//

import UIKit
import AudioKit

/**
 View controller for the Sing Major and Minor Scale exercises.
 
 A random major, natural minor, harmonic minor, or melodic minor scale will be displayed along with a starting pitch. The user must hold down the record button and sing the scale from the starting pitch. The user has the option to change the instrument that is used to play the starting pitch and answer, and they can use the slider to change the octave of the scale.
 */
class MajMinSingViewController: UIViewController {
    
    // MARK: - IBOutlet Properties
    
    /// Label that displays the number of the exercise.
    @IBOutlet var exerciseNumLabel: UILabel!
    
    /// Label for note 1.
    @IBOutlet var note1: UILabel!
    /// Label for note 2.
    @IBOutlet var note2: UILabel!
    /// Label for note 3.
    @IBOutlet var note3: UILabel!
    /// Label for note 4.
    @IBOutlet var note4: UILabel!
    /// Label for note 5.
    @IBOutlet var note5: UILabel!
    /// Label for note 6.
    @IBOutlet var note6: UILabel!
    /// Label for note 7.
    @IBOutlet var note7: UILabel!
    /// Label for note 8.
    @IBOutlet var note8: UILabel!
    
    /// Label for the scale type.
    @IBOutlet var scaleLabel: UILabel!
    /// The record button.
    @IBOutlet var recordButton: UIButton!
    /// Collection of the instrument buttons.
    @IBOutlet var instrumentButtons: [UIButton]!
    /// Collection of the note labels.
    @IBOutlet var noteLabels: [UILabel]!
    
    /// Array that holds the note frequencies starting from C0.
    let noteFrequencies = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    /// Array that holds the note frequency ranges that classifies a frequency as a certain note.
    let noteFreqRanges = [15.9, 16.83, 17.83, 18.9, 20.01, 21.21, 22.47, 23.8, 25.22, 26.72, 28.31, 29.99, 31.77]
    /// Array that holds the cent values of notes starting from C4.
    let noteCents = [0.0, 100.0, 200.0, 300.0, 400.0, 500.0, 600.0, 700.0, 800.0, 900.0, 1000.0, 1100.0]
    /// Array that holds the cent values to be added to a pitch to change the octave.
    let octaveChange = [0,0,-2400.0,-1200.0,0,1200.0,2400.0]
    
    /// Array that holds the names of the types of scales.
    let scaleNames = ["Major Scale", "Natural Minor Scale","Harmonic Minor Scale","Melodic Minor Scale"]
    
    /// Array that holds the chromatic note names with sharps.
    let noteNamesWithSharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    
    /// Array that holds the note indices for the major scale.
    let majorScale = [0,2,4,5,7,9,11,12]
    /// Array that holds the note indices for the natural minor scale.
    let naturalMinorScale = [0,2,3,5,7,8,10,12]
    /// Array that holds the note indices for the harmonic minor scale.
    let harmonicMinorScale = [0,2,3,5,7,8,11,12]
    /// Array that holds the note indices for the melodic minor scale.
    let melodicMinorScale = [0,2,3,5,7,9,11,12]
    
    /// 2D array that holds the different scale types.
    var scaleList = [[Int]]()
    
    /// Initialize the scale type index.
    var scaleType = 0
    /// Initialize the index of the first note.
    var firstNote = 0
    /// Initialize the octave of the first note.
    var firstNoteOctave = 4
    
    /// Index for note 1.
    var noteInd1 = 0
    /// Index for note 2.
    var noteInd2 = 0
    /// Index for note 3.
    var noteInd3 = 0
    /// Index for note 4.
    var noteInd4 = 0
    /// Index for note 5.
    var noteInd5 = 0
    /// Index for note 6.
    var noteInd6 = 0
    /// Index for note 7.
    var noteInd7 = 0
    /// Index for note 8.
    var noteInd8 = 0
    
    /// Initialize the exercise number to be displayed.
    var exerciseNum = 1
    
    /// Initialize the timer to be a `Timer` object.
    var timer: Timer!
    
    /// Initialize conductor to the shared instance of `Conductor`.
    var conductor = Conductor.sharedInstance

    // MARK: - Default View Controller Methods
    
    /// Set the mic, add scales to `scaleList`, and call `setScale()`.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scaleList.append(majorScale)
        scaleList.append(naturalMinorScale)
        scaleList.append(harmonicMinorScale)
        scaleList.append(melodicMinorScale)
        
        conductor.setMic()
        setScale()
    }
    
    // MARK: - Custom Methods
    
    /**
     Randomly picks a scale type and first note, then builds the rest of the scale from that.
     */
    func setScale(){
        scaleType = Int(arc4random_uniform(4))
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
    
    /**
     Plays the scale.
     - Parameter scale: Array of the note indices of the scale.
     */
    func playScale(scale: Array<Int>){
        for i in scale{
            let noteIndex = firstNote+i
            
            conductor.changePitch(pitch: noteIndex > 11 ? noteCents[noteIndex%12] + octaveChange[firstNoteOctave] + 1200.0 : noteCents[noteIndex] + octaveChange[firstNoteOctave], noteType: .root)
            conductor.play(noteType: .root)
            
            usleep(500000)
        }
    }
    
    /**
     Hides the list of instruments.
     */
    func closeInstButtons(){
        for b in instrumentButtons{
            b.isHidden = true
        }
    }
    
    /**
     Checks if the sung note is correct and changes the background of the label to green if correct and red if not.
     - Parameters:
        - label: The UILabel to be changed.
        - noteIndex: The index of the note in the scale.
        - sungNoteIndex: The index of the note that is being sung.
        - sungOctave: The octave of the sung note.
        - noteOctave: The octave of the note in the chord.
     */
    func changeNoteLabel(label: UILabel, noteIndex: Int, sungNoteIndex: Int, sungOctave: Int){
        label.text = "\(noteNamesWithSharps[sungNoteIndex])\(Int(sungOctave))"
        // checks if sung note is correct
        if(sungNoteIndex == (noteIndex > 11 ? noteIndex % 12 : noteIndex)){
            label.backgroundColor = UIColor.green
        }else{
            label.backgroundColor = UIColor.red
        }
    }
    
    // MARK: - IBAction Methods
    
    /**
     Changes the octave of the scale.
     - Parameters:
        - sender: The UISlider.
     */
    @IBAction func changeOctave(sender: UISlider){
        //change octave of first note in scale
        firstNoteOctave = Int(sender.value)
        
        note1.text = "\(noteNamesWithSharps[firstNote])\(firstNoteOctave)"
    }
    
    /**
     Plays the first note of the current scale.
     - Parameter sender: The UIButton to play the first note of the scale.
     */
    @IBAction func playFirstNote(sender: UIButton){
        conductor.changePitch(pitch: noteCents[noteInd1%12] + octaveChange[firstNoteOctave] , noteType: .root)
        conductor.play(noteType: .root)
    }
    
    /**
     Plays the current scale (the answer; the scale the user should sing).
     - Parameter sender: The UIButton to play the answer.
     */
    @IBAction func playAnswer(sender: UIButton){
        
        playScale(scale: scaleList[scaleType])
        
    }
    
    /**
     Moves on to the next exercise by resetting the labels and calls `setScale()`.
     - Parameter sender: The UIButton labeled next.
     */
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
    
    /**
     Displays and hides the instrument button list.
     - Parameters:
        - sender: The UIButton to show/hide the list of instruments
     */
    @IBAction func instruments(sender: UIButton){
        if(instrumentButtons[0].isHidden){
            for b in instrumentButtons{
                b.isHidden = false
            }
        }else{
            closeInstButtons()
        }
    }
    
    /**
     Changes the instrument to a piano.
     - Parameters:
        - sender: The UIButton labeled Piano
     */
    @IBAction func piano(sender: UIButton){
        conductor.changeInstrument(instr: .piano)
        
        closeInstButtons()
    }
    
    /**
     Changes the instrument to a clarinet.
     - Parameters:
        - sender: The UIButton labeled Clarinet
     */
    @IBAction func clarinet(sender: UIButton){
        conductor.changeInstrument(instr: .clarinet)
        
        closeInstButtons()
    }
    
    /**
     Changes the instrument to a french horn.
     - Parameters:
        - sender: The UIButton labeled French Horn.
     */
    @IBAction func frenchHorn(sender: UIButton){
        conductor.changeInstrument(instr: .french_horn)
        
        closeInstButtons()
    }
    
    /**
     Changes the instrument to pizzicato strings.
     - Parameters:
        - sender: The UIButton labeled Pizz Strings.
     */
    @IBAction func string(sender: UIButton){
        conductor.changeInstrument(instr: .pizz_strings)
        
        closeInstButtons()
    }
    
    /**
     Changes the text on the button used to hold down to record when pressed, and calls `updateUI()` using the timer.
     */
    @IBAction func handleGesture(_ sender: UILongPressGestureRecognizer){
        if sender.state == UIGestureRecognizerState.began{
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(MajMinSingViewController.updateUI), userInfo: nil, repeats: true)
            recordButton.setTitle("Listening...", for: .normal)
        }
        else if sender.state == UIGestureRecognizerState.ended{
            timer.invalidate()
            recordButton.setTitle("Hold to Record", for: .normal)
        }
    }
    
    /**
     Sets the sung note label to what is being sung into the microphone.
     */
    @objc func updateUI(){
        var frequency0 = conductor.listenFreq()
        var sungOctave = 0
        var sungNoteIndex = 0
        
        if(conductor.listenAmp() > 0.01){
            
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

    // MARK: - Navigation
    /// Unwind segue when in the instruction page.
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
