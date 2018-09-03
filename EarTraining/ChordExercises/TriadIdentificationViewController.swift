//
//  BasicChordIdentificationViewController.swift
//  EarTraining
//
//  Created by Ariel Todoki on 3/2/18.
//  Copyright © 2018 Ariel Todoki. All rights reserved.
//

import UIKit
import AudioKit

/**
 View controller for the Triad Identification exercises.
 
 Random triads in root position will be played, and the user guesses the type of triad by pressing on the corresponding buttons. The user has the option to change the instrument that is used to play the chords.
 */
class TriadIdentificationViewController: UIViewController {
    
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
    
    /// Array that holds the interval ranges for a major triad
    let majChord = [4,7]
    /// Array that holds the interval ranges for a minor triad
    let minChord = [3,7]
    /// Array that holds the interval ranges for a diminished triad
    let dimChord = [3,6]
    /// Array that holds the interval ranges for an augmented triad
    let augChord = [4,8]
    
    /// 2D array that holds the different kinds of triads
    var chordList = [[Int]]()
    
    /// Initialize the index to decide chord type
    var chordType = 0
    /// Initialize the index of the root note of the triad
    var root = 0
    /// Initialize the index of the note that is the third of the triad
    var third = 0
    /// Initialize the index of the note that is the fifth of the triad
    var fifth = 0
    
    /// Initialize the octave of the root note
    var rootOctave = 4
    /// Initialize the octave of the note that is the third of the triad
    var thirdOctave = 4
    /// Initialize the octave of the note that is the fifth of the triad
    var fifthOctave = 4

    /// Initialize the exercise number to be displayed
    var exerciseNum = 1
    
    /// Initialize conductor to the shared instance of `Conductor`.
    var conductor = Conductor.sharedInstance
    
    // MARK: - Default View Controller Methods
    
    /// Close the mic, add chords to `chordList`, and call `setChord()`.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chordList.append(majChord)
        chordList.append(minChord)
        chordList.append(dimChord)
        chordList.append(augChord)
        

        conductor.closeMic()
        setChord()

    }

    
    // MARK: - Custom Methods
    
    /**
     Randomly picks a chord type and a root note, then builds the rest of the triad from that.
     */
    func setChord(){
        
        repeat{
            chordType = Int(arc4random_uniform(4))
            root = Int(arc4random_uniform(12))
            third = root + chordList[chordType][0]
            fifth = root + chordList[chordType][1]
            
            rootOctave = Int(arc4random_uniform(3) + 3)
            thirdOctave = third > 11 ? rootOctave + 1 : rootOctave
            fifthOctave = fifthOctave > 11 ? rootOctave + 1 : rootOctave
        }while fifthOctave > 5
        
        conductor.changePitch(pitch: noteCents[root] + octaveChange[rootOctave], noteType: .root)
        conductor.changePitch(pitch: noteCents[third%12] + octaveChange[thirdOctave], noteType: .third)
        conductor.changePitch(pitch: noteCents[fifth%12] + octaveChange[fifthOctave], noteType: .fifth)
        
    }
    
    /// Plays the triad (three notes simultaneously).
    func playChord(){
        conductor.play(noteType: .root)
        conductor.play(noteType: .third)
        conductor.play(noteType: .fifth)

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
     Plays the current triad again. Calls `playChord()`.
     - Parameters:
        - sender: The UIButton to replay the triad.
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
        
        exerciseNumLabel.text = "Exercise #\(exerciseNum)"
        
        
    }
    
    /// Button turns green if the triad played is a major triad, turns red if not.
    @IBAction func majChord(sender: UIButton){
        checkAnswer(button: sender, chord: 0)
    }
    
    /// Button turns green if the triad played is a minor triad, turns red if not.
    @IBAction func minChord(sender: UIButton){
        checkAnswer(button: sender, chord: 1)
    }
    
    /// Button turns green if the triad played is a diminished triad, turns red if not.
    @IBAction func dimChord(sender: UIButton){
        checkAnswer(button: sender, chord: 2)
    }
    
    /// Button turns green if the triad played is an augmented triad, turns red if not.
    @IBAction func augChord(sender: UIButton){
        checkAnswer(button: sender, chord: 3)
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
