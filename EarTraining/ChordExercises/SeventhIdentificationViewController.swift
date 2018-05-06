//
//  SeventhIdentificationViewController.swift
//  EarTraining
//
//  Created by Ariel Todoki on 4/25/18.
//  Copyright © 2018 Ariel Todoki. All rights reserved.
//

import UIKit
import AudioKit

/**
 View controller for the Seventh Identification exercises
 
 Random seventh chords in root position will be played, and the user guesses the type of seventh chord by pressing on the corresponding buttons. The user has the option to change the instrument that is used to play the chords.
 */
class SeventhIdentificationViewController: UIViewController {

    // MARK: - IBOutlet Properties
    
    /// Collection of the interval buttons.
    @IBOutlet var intervalButtons: [UIButton]!
    
    /// Collection of the instrument buttons.
    @IBOutlet var instrumentButtons: [UIButton]!
    
    /// Label that displays the number of the exercise.
    @IBOutlet var exerciseNumLabel: UILabel!
    
    // MARK: - Variables
    
    /// Array that holds the cent values of notes starting from C4.
    let noteCents = [0.0, 100.0, 200.0, 300.0, 400.0, 500.0, 600.0, 700.0, 800.0, 900.0, 1000.0, 1100.0]
    /// Array that holds the cent values to be added to a pitch to change the octave.
    let octaveChange = [0,0,-2400.0,-1200.0,0,1200.0,2400.0]
    
    /// Array that holds the interval ranges for a major seventh chord
    let majSChord = [4,7,11]
    /// Array that holds the interval ranges for a minor seventh chord
    let minSChord = [3,7,10]
    /// Array that holds the interval ranges for a dominant seventh chord
    let domChord = [4,7,10]
    /// Array that holds the interval ranges for a half diminished seventh chord
    let hDimChord = [3,6,10]
    /// Array that holds the interval ranges for a diminished seventh chord
    let fDimChord = [3,6,9]
    
    /// 2D array that holds the differnt kinds of seventh chords
    var chordList = [[Int]]()
    
    /// Initialize the index to decide chord type
    var chordType = 0
    /// Initialize the index of the root note of the seventh chord
    var root = 0
    /// Initialize the index of the note that is the third of the seventh chord
    var third = 0
    /// Initialize the index of the note that is the fifth of the seventh chord
    var fifth = 0
    /// Initialize the index of the note that is the seventh of the seventh chord
    var seventh = 0
    
    /// Initialize the octave of the root note
    var rootOctave = 4
    /// Initialize the octave of the note that is the third of the seventh chord
    var thirdOctave = 4
    /// Initialize the octave of the note that is the fifth of the seventh chord
    var fifthOctave = 4
    /// Initialize the octave of the note that is the seventh of the seventh chord
    var seventhOctave = 4
    
    /// Initialize the exercise number to be displayed
    var exerciseNum = 1
    
    /// Initialize conductor to the shared instance of `Conductor`.
    var conductor = Conductor.sharedInstance
    
    // MARK: - Default View Controller Methods
    
    /// Close the mic, add chords to `chordList`, and call `setChord()`.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chordList.append(majSChord)
        chordList.append(minSChord)
        chordList.append(domChord)
        chordList.append(hDimChord)
        chordList.append(fDimChord)
        
        conductor.closeMic()
        setChord()
  
    }
    
    
    // MARK: Custom Methods
    
    /**
     Randomly picks a chord type and a root note, then builds the rest of the seventh chord from that.
     */
    func setChord(){
        chordType = Int(arc4random_uniform(5))
        root = Int(arc4random_uniform(12))
        third = root + chordList[chordType][0]
        fifth = root + chordList[chordType][1]
        seventh = root + chordList[chordType][2]
        
        rootOctave = Int(arc4random_uniform(2) + 3)
        thirdOctave = third > 11 ? rootOctave + 1 : rootOctave
        fifthOctave = fifth > 11 ? rootOctave + 1 : rootOctave
        seventhOctave = seventh > 11 ? rootOctave + 1 : rootOctave
        
        conductor.changePitch(pitch: noteCents[root] + octaveChange[rootOctave], noteType: .root)
        conductor.changePitch(pitch: noteCents[third%12] + octaveChange[thirdOctave], noteType: .third)
        conductor.changePitch(pitch: noteCents[fifth%12] + octaveChange[fifthOctave], noteType: .fifth)
        conductor.changePitch(pitch: noteCents[seventh%12] + octaveChange[seventhOctave], noteType: .seventh)
        
    }
    
    /// Plays the seventh chord (four notes simultaneously).
    func playChord(){
        conductor.play(noteType: .root)
        conductor.play(noteType: .third)
        conductor.play(noteType: .fifth)
        conductor.play(noteType: .seventh)
        
    }
    
    /**
     Checks if the user selected the correct chord type button. Turns the selected button red if wrong, and green if correct.
     - Parameters:
        - button: UIButton which was selected by the user.
        - chord: The index of the chord type as listed in `chordList`.
     */
    func checkAnswer(button: UIButton, chord: Int){
        if (chordType == chord){
            button.backgroundColor = UIColor.green
            for b in intervalButtons{
                b.alpha = 0.75
                b.isEnabled = false
            }
        }
        else{
            button.backgroundColor = UIColor.red
        }
    }
    
    /**
     Hides the list of instruments
     */
    func closeInstButtons(){
        for b in instrumentButtons{
            b.isHidden = true
        }
    }
    
    
    // MARK: - IBAction Methods
    
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
     Plays the current seventh chord again. Calls `playChord()`.
     - Parameters:
        - sender: The UIButton to replay the chord.
     */
    @IBAction func playAgain(sender: UIButton){
        
        playChord()
        
    }
    
    /**
     Moves on to the next exercise by resetting the buttons and calls `setChord()`.
     - Parameters:
        - sender: The UIButton labeled next.
     */
    @IBAction func next(sender: UIButton){
        setChord()
        
        for b in intervalButtons{
            b.backgroundColor = UIColor.white
            b.alpha = 1.0
            b.isEnabled = true
        }
        
        exerciseNum += 1
        
        exerciseNumLabel.text = "Exercise # \(exerciseNum)"
        
        
    }
    
    /// Button turns green if the chord played is a major seventh chord, turns red if not.
    @IBAction func majSChord(sender: UIButton){
        checkAnswer(button: sender, chord: 0)
    }
    
    /// Button turns green if the chord played is a minor seventh chord, turns red if not.
    @IBAction func minSChord(sender: UIButton){
        checkAnswer(button: sender, chord: 1)
    }
    
    /// Button turns green if the chord played is a dominant chord, turns red if not.
    @IBAction func domChord(sender: UIButton){
        checkAnswer(button: sender, chord: 2)
    }
    
    /// Button turns green if the chord played is a half diminished seventh chord, turns red if not.
    @IBAction func hDimChord(sender: UIButton){
        checkAnswer(button: sender, chord: 3)
    }
    
    /// Button turns green if the chord played is a diminished seventh chord, turns red if not.
    @IBAction func fDimChord(sender: UIButton){
        checkAnswer(button: sender, chord: 4)
    }
    
    // MARK: - Navigation
    /// Unwind segue when in the instruction page.
    @IBAction func unwindSegueID(segue: UIStoryboardSegue) {
        
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
