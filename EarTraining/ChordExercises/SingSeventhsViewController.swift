//
//  SingSeventhsViewController.swift
//  EarTraining
//
//  Created by Ariel Todoki on 4/26/18.
//  Copyright © 2018 Ariel Todoki. All rights reserved.
//

import UIKit
import AudioKit

/**
 View controller for the Seventh Chord Singing exercises.
 
 A random seventh chord and root note will be chosen and displayed to the user, and the user has to sing the seventh chord sequentially into the microphone while holding down the record button.
 */
class SingSeventhsViewController: UIViewController {

    // MARK: - IBOutlet Properties
    
    /// Label that displays the number of the exercise.
    @IBOutlet var exerciseNumLabel: UILabel!
    /// Label that displays the root note.
    @IBOutlet var rootNote: UILabel!
    /// Label that displays the note that is the third of the seventh chord.
    @IBOutlet var thirdNote: UILabel!
    /// Label that displays the note that is the fifth of the seventh chord.
    @IBOutlet var fifthNote: UILabel!
    /// Label that displays the note that is the seventh of the seventh chord.
    @IBOutlet var seventhNote: UILabel!
    /// Label that displays the type of seventh chord.
    @IBOutlet var chordLabel: UILabel!
    /// Button that the user holds down to record.
    @IBOutlet var recordButton: UIButton!
    /// Collection of the intrument buttons.
    @IBOutlet var instrumentButtons: [UIButton]!
    
    /// Array that holds the note frequencies for an octave of pitches starting from C0.
    let noteFrequencies = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    /// Array that holds the note frequency ranges that classifies a frequency as a certain note.
    let noteFreqRanges = [15.9, 16.83, 17.83, 18.9, 20.01, 21.21, 22.47, 23.8, 25.22, 26.72, 28.31, 29.99, 31.77]
    /// Array that holds the cent values of notes starting from C4.
    let noteCents = [0.0, 100.0, 200.0, 300.0, 400.0, 500.0, 600.0, 700.0, 800.0, 900.0, 1000.0, 1100.0]
    /// Array that holds the cent values to be added to a pitch to change the octave.
    let octaveChange = [0,0,-2400.0,-1200.0,0,1200.0,2400.0]
    
    /// Array that holds chromatic note names with sharps.
    let noteNamesWithSharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    /// Array that holds chromatic note names with flats.
    let noteNamesWithFlats = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]
    /// Array that holds the names of the types of seventh chords.
    let chordNames = ["Major Seventh", "Minor Seventh", "Dominant Seventh", "Half-Diminished Seventh", "Diminished Seventh"]
    
    /// Array that holds the interval ranges for a major seventh chord.
    let majSChord = [4,7,11]
    /// Array that holds the interval ranges for a minor seventh chord.
    let minSChord = [3,7,10]
    /// Array that holds the interval ranges for a dominant chord.
    let domChord = [4,7,10]
    /// Array that holds the interval ranges for a half diminished seventh chord.
    let hDimChord = [3,6,10]
    /// Array that holds the interval ranges for a diminished seventh chord.
    let fDimChord = [3,6,9]
    
    /// 2D array that holds the different kinds of seventh chords
    var chordList = [[Int]]()
    
    /// Initialize the index to decide chord type
    var chordType = 0
    /// Initialize the index of the root note of the seventh chord.
    var root = 0
    /// Initialize the index of the note that is the third of the seventh chord.
    var third = 0
    /// Initialize the index of the note that is the fifth of the seventh chord.
    var fifth = 0
    /// Initialize the index of the note that is the seventh of the seventh chord.
    var seventh = 0
    
    /// Initialize the exercise number to be displayed.
    var exerciseNum = 1
    
    /// Initialize the octave of the root note.
    var rootOctave = 4
    /// Initialize the octave of the note that is the third of the seventh chord.
    var thirdOctave = 4
    /// Initialize the octave of the note that is the fifth of the seventh chord.
    var fifthOctave = 4
    /// Initialize the octave of the note that is the seventh of the seventh chord.
    var seventhOctave = 4
    
    /// Initialize the timer to be a `Timer` object.
    var timer: Timer!
    
    /// Initialize conductor to the shared instance of `Conductor`.
    var conductor = Conductor.sharedInstance
    
    // MARK: - Default View Controller Methods
    
    /// Set the mic, add chords to `chordList`, and call `setChord()`.
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
    
    
    // MARK: - Custom Methods
    
    /**
     Randomly picks a chord type and a root note, then builds the rest of the seventh chord from that.
     */
    func setChord(){
        repeat{
            chordType = Int(arc4random_uniform(5))
            root = Int(arc4random_uniform(12))
            third = root + chordList[chordType][0]
            fifth = root + chordList[chordType][1]
            seventh = root + chordList[chordType][2]
            
            thirdOctave = third > 11 ? rootOctave + 1 : rootOctave
            fifthOctave = fifth > 11 ? rootOctave + 1 : rootOctave
            seventhOctave = seventh > 11 ? rootOctave + 1 : rootOctave
        }while seventhOctave > 5
        
        chordLabel.text = "Sing a \(chordNames[chordType]) chord"
        
        conductor.changePitch(pitch: noteCents[root] + octaveChange[rootOctave], noteType: .root)
        conductor.changePitch(pitch: noteCents[third%12] + octaveChange[thirdOctave], noteType: .third)
        conductor.changePitch(pitch: noteCents[fifth%12] + octaveChange[fifthOctave], noteType: .fifth)
        conductor.changePitch(pitch: noteCents[seventh%12] + octaveChange[seventhOctave], noteType: .seventh)
        
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
        - noteIndex: The index of the note in the chord.
        - sungNoteIndex: The index of the note that is being sung.
        - sungOctave: The octave of the sung note.
        - noteOctave: The octave of the note in the chord.
     */
    func changeNoteLabel(label: UILabel, noteIndex: Int, sungNoteIndex: Int, sungOctave: Int, noteOctave: Int){
        label.text = "\(noteNamesWithSharps[sungNoteIndex])\(Int(sungOctave))"
        // checks if sung note is correct
        if(sungNoteIndex == (noteIndex > 11 ? noteIndex % 12 : noteIndex) && sungOctave == noteOctave){
            label.backgroundColor = UIColor.green
        }else{
            label.backgroundColor = UIColor.red
        }
    }
    
    // MARK: - IBAction Methods
    
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
     Plays the root note again.
     - Parameters:
        - sender: The UIButton to play the root of the chord.
     */
    @IBAction func playRoot(sender: UIButton){
        conductor.play(noteType: .root)
    }
    
    /**
     Plays the chord as a sequence (as you would sing it).
     - Parameters:
        - sender: The UIButton to play the answer/chord sequence.
     */
    @IBAction func playChordSequence(sender: UIButton){
        conductor.play(noteType: .root)
        sleep(1)
        conductor.play(noteType: .third)
        sleep(1)
        conductor.play(noteType: .fifth)
        sleep(1)
        conductor.play(noteType: .seventh)
    }
    
    /**
     Plays the seventh chord, all four notes simultaneously.
     - Parameters:
        - sender: The UIButton to play the chord.
     */
    @IBAction func playChord(sender: UIButton){
        conductor.play(noteType: .root)
        conductor.play(noteType: .third)
        conductor.play(noteType: .fifth)
        conductor.play(noteType: .seventh)
        
    }
    
    /**
     Moves on to the next exercise by resetting the labels and calls `setChord()`.
     - Parameters:
        - sender: The UIButton labeled next.
     */
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
    
    /**
     Changes the octave of the chord.
     - Parameters:
        - sender: The UISlider.
     */
    @IBAction func changeOctave(sender: UISlider){
        rootOctave = Int(sender.value)
        thirdOctave = third > 11 ? rootOctave + 1 : rootOctave
        fifthOctave = fifth > 11 ? rootOctave + 1 : rootOctave
        seventhOctave = seventh > 11 ? rootOctave + 1 : rootOctave
        
        conductor.changePitch(pitch: noteCents[root] + octaveChange[rootOctave], noteType: .root)
        conductor.changePitch(pitch: noteCents[third%12] + octaveChange[thirdOctave], noteType: .third)
        conductor.changePitch(pitch: noteCents[fifth%12] + octaveChange[fifthOctave], noteType: .fifth)
        conductor.changePitch(pitch: noteCents[seventh%12] + octaveChange[seventhOctave], noteType: .seventh)
        
        rootNote.text = "\(noteNamesWithSharps[root])\(rootOctave)"
    }
    
    /**
     Changes the text on the button used to hold down to record when pressed, and calls `updateUI()` using the timer.
     */
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
    
    // MARK: - Navigation
    /// Unwind segue when in the instruction page.
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
