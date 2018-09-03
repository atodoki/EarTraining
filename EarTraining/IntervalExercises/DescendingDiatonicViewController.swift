//
//  DescendingDiatonicViewController.swift
//  EarTraining
//
//  Created by Ariel Todoki on 3/1/18.
//  Copyright © 2018 Ariel Todoki. All rights reserved.
//

import UIKit
import AudioKit

/**
 View controller for the Descending Diatonic interval exercises.
 
 Random descending diatonic intervals will be played, and the user guesses the interval by pressing on the corresponding buttons. The user has the option to change the instrument that is used to play the intervals.
 */
class DescendingDiatonicViewController: UIViewController {
    
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
    /// Array that holds the interval range for diatonic intervals only.
    let diatonicIntervals = [2,4,5,7,9,11,12]
    
    /// Initialize bottom note octave.
    var bNoteOctave = 4
    /// Initialize top note octave.
    var tNoteOctave = 4
    
    /// Initialize bottom note index.
    var bottomNote = 0
    /// Initialize top note index.
    var topNote = 0
    /// Initialize the index used for the randomly picked diatonic interval.
    var randomIndex = 0
    /// Initialize the exercise number to be displayed.
    var exerciseNum = 1
    /// Initialize conductor to the shared instance of `Conductor`.
    var conductor = Conductor.sharedInstance
    
    // MARK: - Default View Controller Methods
    
    /// Close the mic and call `setInterval()`.
    override func viewDidLoad() {
        super.viewDidLoad()
        conductor.closeMic()
        setInterval()
        
    }

    
    // MARK: - Custom Methods
    
    /**
     Randomly picks a top note, top note octave, and diatonic interval. Then sets the bottom note and bottom note octave to be the correct interval below the top note.
     */
    func setInterval(){
        repeat{
            topNote = Int(arc4random_uniform(12)) // random number 0<n<12-1
            randomIndex = Int(arc4random_uniform(UInt32(diatonicIntervals.count))) // random number from array diatonicIntervals
            bottomNote = topNote - diatonicIntervals[randomIndex]// random number diatonic interval from topNote
            tNoteOctave = Int(arc4random_uniform(3))+3 // octave 3 to 5
            bNoteOctave = (bottomNote < 0 ? tNoteOctave - 1 : tNoteOctave)
            bottomNote += 12
        }while bNoteOctave < 3
    }
    
    /// Plays the interval; top note first then the bottom note.
    func playInterval(){
        conductor.changePitch(pitch: noteCents[topNote] + octaveChange[tNoteOctave], noteType: .root)
        conductor.play(noteType: .root)

        sleep(1)
        
        conductor.changePitch(pitch: noteCents[bottomNote%12] + octaveChange[bNoteOctave], noteType: .root)
        conductor.play(noteType: .root)

    }
    
    /**
     Checks if the user selected the correct interval button. Turns the selected button red if wrong, and green if correct.
     - Parameters:
        - sender: UIButton which was selected by the user.
        - interval: The intervalic difference between the top note and the bottom note.
     */
    func checkAnswer(sender: UIButton, interval: Int){
        if(diatonicIntervals[randomIndex] == interval){
            sender.backgroundColor = UIColor.green
            for b in intervalButtons{
                b.alpha = 0.75
                b.isEnabled = false
            }
        }
        else{
            sender.backgroundColor = UIColor.red
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
     Plays the current interval again. Calls `playInterval()`.
     - Parameters:
        - sender: The UIButton to replay the interval.
     */
    @IBAction func playAgain(sender: UIButton){
        playInterval()
        
    }
    
    /**
     Moves on to the next exercise by resetting the buttons and calls `setInterval()`.
     - Parameters:
        - sender: The UIButton labeled next.
     */
    @IBAction func next(sender: UIButton){
        
        // MAKE BUTTON BACKGROUNDS GO BACK TO NORMAL
        for b in intervalButtons{
            b.backgroundColor = UIColor.white
            b.alpha = 1.0
            b.isEnabled = true
        }
        
        setInterval()
        
        exerciseNum += 1
        
        exerciseNumLabel.text = "Exercise #\(exerciseNum)"
        
    }
    
    /// Button turns green if the interval played is a major second, turns red if not.
    @IBAction func majorSecond(sender: UIButton){
        checkAnswer(sender: sender, interval: 2)
    }

    /// Button turns green if the interval played is a major third, turns red if not.
    @IBAction func majorThird(sender: UIButton){
        checkAnswer(sender: sender, interval: 4)
    }

    /// Button turns green if the interval played is a perfect fourth, turns red if not.
    @IBAction func perfectFourth(sender: UIButton){
        checkAnswer(sender: sender, interval: 5)
    }

    /// Button turns green if the interval played is a perfect fifth, turns red if not.
    @IBAction func perfectFifth(sender: UIButton){
        checkAnswer(sender: sender, interval: 7)
    }

    /// Button turns green if the interval played is a major sixth, turns red if not.
    @IBAction func majorSixth(sender: UIButton){
        checkAnswer(sender: sender, interval: 9)
    }

    /// Button turns green if the interval played is a major seventh, turns red if not.
    @IBAction func majorSeventh(sender: UIButton){
        checkAnswer(sender: sender, interval: 11)
    }

    /// Button turns green if the interval played is an octave, turns red if not.
    @IBAction func octave(sender: UIButton){
        checkAnswer(sender: sender, interval: 12)
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

