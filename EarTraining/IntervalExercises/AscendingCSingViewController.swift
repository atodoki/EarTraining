//
//  AscendingCSingViewController.swift
//  EarTraining
//
//  Created by Ariel Todoki on 4/26/18.
//  Copyright © 2018 Ariel Todoki. All rights reserved.
//

import UIKit
import AudioKit

/**
 View controller for the Ascending Chromatic Sing interval exercises.
 
 A random ascending chromatic interval will be displayed for the user to sing above a given pitch. The user can change the octave using the slider, and the user can change the instrument that is used to play the pitches. The background showing the sung note turns red if it is incorrect, orange if it is correct but out of tune by 10 cents, and green if correct and in tune.
 */
class AscendingCSingViewController: UIViewController {
    
    // MARK: - IBOutlet Properties

    /// Label that displays the given bottom note.
    @IBOutlet var givenNote: UILabel!
    
    /// Label that displays the sung top note.
    @IBOutlet var sungNote: UILabel!
    
    /// Label that displays the chromatic interval to be sung.
    @IBOutlet var intervalLabel: UILabel!
    
    /// Button the user holds down to record.
    @IBOutlet var recordButton: UIButton!
    
    /// Collection of the instrument buttons.
    @IBOutlet var instrumentButtons: [UIButton]!
    
    /// Label that displays the number of the exercise.
    @IBOutlet var exerciseNumLabel: UILabel!
    
    // MARK: - Variables
    
    /// Initialize bottom note octave.
    var bNoteOctave = 4
    /// Initialize top note octave.
    var tNoteOctave = 4
    /// Initialize bottom note index.
    var bottomNote = 0
    /// Initialize top note index.
    var topNote = 0
    /// Initialize the chromatic interval size.
    var intervalSize = 0
    /// Initialize the index used for the randomly picked diatonic interval.
    var intervalIndex = 0
    /// Initialize the exercise number to be displayed.
    var exerciseNum = 1
    
    /// Initialize conductor to the shared instance of `Conductor`.
    var conductor = Conductor.sharedInstance
    
    /// Initialize timer to be a `Timer` object.
    var timer: Timer!
    
    /// Array that holds the note frequencies for an octave of pitches starting from C0.
    let noteFrequencies = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    
    /// Array that holds the cent values of notes starting from C4.
    let noteCents = [0.0, 100.0, 200.0, 300.0, 400.0, 500.0, 600.0, 700.0, 800.0, 900.0, 1000.0, 1100.0]
    /// Array that holds the cent values to be added to a pitch to change the octave.
    let octaveChange = [0,0,-2400.0,-1200.0,0,1200.0,2400.0]
    
    /// Array that holds chromatic note names with sharps.
    let noteNamesWithSharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    /// Array that holds chromatic note names with flats.
    let noteNamesWithFlats = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]
    
    /// Array that holds the note frequency ranges that classifies a frequency as a certain note.
    let noteFreqRanges = [15.9, 16.83, 17.83, 18.9, 20.01, 21.21, 22.47, 23.8, 25.22, 26.72, 28.31, 29.99, 31.77]
    /// Array that holds the note frequency ranges that classifies a frequency as in tune on the flat side.
    let inTuneLow = [16.26, 17.22, 18.24, 19.33, 20.48, 21.7, 22.99, 24.36, 25.81, 27.34, 28.97, 30.69]
    /// Array that holds the note frequency ranges that classifies a frequency as in tune on the sharp side.
    let inTuneHigh = [16.45, 17.42, 18.46, 19.56, 20.72, 21.95, 23.26, 24.64, 26.11, 27.66, 29.3, 31.05]
    
    /// Array that holds the names of chromatic intervals.
    let intervalNames = ["Minor 2nd", "Major 2nd", "Minor 3rd","Major 3rd", "Perfect 4th", "Tritone","Perfect 5th", "Minor 6th","Major 6th", "Minor 7th","Major 7th", "Octave"]
    
    /// Array that holds the interval range for chromatic intervals only
    let chromaticIntervals = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    
    // MARK: - Default View Controller Methods
    
    /// Open the mic and call `setInterval()`.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        conductor.setMic()
        setInterval()
        
    }
    
    // MARK: - Custom Methods
    
    /**
     Randomly picks a bottom note, bottom note octave, and chromatic interval. Then sets the top note and top note octave to be the correct interval above the bottom note. Sets the text of the interval label.
     */
    func setInterval(){
        bottomNote = Int(arc4random_uniform(12)) // random number 0<n<12-1
        intervalIndex = chromaticIntervals.randomIndex
        intervalSize = chromaticIntervals[intervalIndex]
        topNote = bottomNote + intervalSize
        tNoteOctave = (topNote > 11 ? bNoteOctave + 1 : bNoteOctave)
        
        givenNote.text = "\(noteNamesWithSharps[bottomNote])\(bNoteOctave)"
        intervalLabel.text = "Sing \(intervalNames[intervalIndex])"
        
    }
    
    /**
     Hides the list of instruments
     */
    func closeInstButtons(){
        for b in instrumentButtons{
            b.isHidden = true
        }
    }
    
    // MARK: IBAction Methods
    
    /**
     Displays and hides the instrument button list
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
     Changes the octave of the given note and answer.
     - Parameters:
        - sender: The UISlider.
     */
    @IBAction func changeOctave(sender: UISlider){
        bNoteOctave = Int(sender.value)
        tNoteOctave = topNote > 11 ? bNoteOctave + 1 : bNoteOctave
        givenNote.text = "\(noteNamesWithSharps[bottomNote])\(bNoteOctave)"
    }
    
    /**
     Plays the bottom note again.
     - Parameters:
        - sender: The UIButton to replay the given bottom note.
     */
    @IBAction func replay(sender: UIButton){
        conductor.changePitch(pitch: noteCents[bottomNote] + octaveChange[bNoteOctave], noteType: .root)
        conductor.play(noteType: .root)
        
    }
    
    /**
     Plays the answer (top note).
     - Parameters:
        - sender: The UIButton to play the answer.
     */
    @IBAction func playAnswer(sender: UIButton){
        conductor.changePitch(pitch: noteCents[topNote%12] + octaveChange[tNoteOctave], noteType: .root)
        conductor.play(noteType: .root)
        
    }
    
    /**
     Moves on to the next exercise by resetting the buttons, calls `setInterval()`, and plays the new bottom note.
     - Parameters:
        - sender: The UIButton labeled start.
     */
    @IBAction func start(sender: UIButton){
        
        // reset label background colors
        sungNote.backgroundColor = UIColor.white
        sungNote.text = "Sung Note"
        givenNote.backgroundColor = UIColor.white
        
        setInterval()
        
        conductor.changePitch(pitch: noteCents[bottomNote] + octaveChange[bNoteOctave], noteType: .root)
        conductor.play(noteType: .root)
        
        exerciseNum += 1
        exerciseNumLabel.text = "Exercise # \(exerciseNum)"

        
    }
    
    /**
     Sets the sung note label to what is being sung into the microphone.
     */
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
            
            if((sungNoteIndex == topNote%12) && (Int(sungOctave) == tNoteOctave)){ // if correct pitch class and octave
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
    
    /**
     Changes the text on the button used to hold down to record when pressed, and calls `updateUI()` using the timer.
     */
    @IBAction func handleGesture(_ sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began{
            
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(AscendingDSingIntervalViewController.updateUI), userInfo: nil, repeats: true)
            recordButton.setTitle("Listening...", for: .normal)
        }
        else if sender.state == UIGestureRecognizerState.ended{
            timer.invalidate()
            recordButton.setTitle("Hold to Record", for: .normal)
        }
    }
    
    // MARK: - Navigation
    /// Unwind segue when in the instruction page.
    @IBAction func unwindSegueSinging(segue: UIStoryboardSegue) {
        
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
