//
//  ModesScalesViewController.swift
//  EarTraining
//
//  Created by Ariel Todoki on 4/9/18.
//  Copyright © 2018 Ariel Todoki. All rights reserved.
//

import UIKit
import AudioKit

/**
 View controller for the Modes of the Major Scale exercises.
 
 A random mode of the major scale will be played, and the user guesses the type of scale by pressing on the corresponding buttons. The user has the option to change the instrument that is used to play the scales.
 */
class ModesScalesViewController: UIViewController {

    // MARK: - IBOutlet Properties
    
    /// Collection of the scale buttons.
    @IBOutlet var scaleButtons: [UIButton]!
    /// Collection of the instrument buttons.
    @IBOutlet var instrumentButtons: [UIButton]!
    /// Label that displays the number of the exercise.
    @IBOutlet var exerciseNumLabel: UILabel!
    
    /// Array that holds the cent values of notes starting from C4.
    let noteCents = [0.0, 100.0, 200.0, 300.0, 400.0, 500.0, 600.0, 700.0, 800.0, 900.0, 1000.0, 1100.0]
    
    /// Array that holds the note indices for the ionian scale.
    let ionian = [0,2,4,5,7,9,11,12]
    /// Array that holds the note indices for the dorian scale.
    let dorian = [0,2,3,5,7,9,10,12]
    /// Array that holds the note indices for the phrygian scale.
    let phrygian = [0,1,3,5,7,8,10,12]
    /// Array that holds the note indices for the lydian scale.
    let lydian = [0,2,4,6,7,9,11,12]
    /// Array that holds the note indices for the mixolydian scale.
    let mixolydian = [0,2,4,5,7,9,10,12]
    /// Array that holds the note indices for the aeolian scale.
    let aeolian = [0,2,3,5,7,8,10,12]
    /// Array that holds the note indices for the locrian scale.
    let locrian = [0,1,3,5,6,8,10,12]
    
    /// 2D array that holds the different scale types.
    var scaleList = [[Int]]()
    
    /// Initialize the scale type index
    var scaleType = 0
    /// Initialize the index of the first note
    var firstNote = 0
    
    /// Initialize the exercise number to be displayed.
    var exerciseNum = 1

    /// Initialize conductor to the shared instance of `Conductor`.
    var conductor = Conductor.sharedInstance
    
    // MARK: - Default View Controller Methods
    
    /// Close the mic, add scales to `scaleList`, and set `scaleType` and `firstNote` to random indices.
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
        
        scaleType = Int(arc4random_uniform(7))
        firstNote = Int(arc4random_uniform(12))
    }
    
    
    // MARK: - Custom Methods
    
    /**
     Plays the scale.
     - Parameter scale: The array that has the indices for the scale to be played.
     */
    func playScale(scale: Array<Int>){
        
        for i in scale{
            let noteIndex = firstNote+i
            
            conductor.changePitch(pitch: noteIndex > 11 ? noteCents[noteIndex%12] + 1200.0 : noteCents[noteIndex], noteType: .root)
            conductor.play(noteType: .root)

            usleep(500000)
        }
        
    }
    
    /**
     Checks if the user selected the correct scale button. Turns the selected button red if wrong, and green if correct.
     - Parameters:
        - button: UIButton which was selected by the user.
        - scale: The index of the scale type.
     */
    func checkAnswer(button: UIButton, scale: Int){
        if(scale == scaleType){
            button.backgroundColor = UIColor.green
            for b in scaleButtons{
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
     Plays the current scale again. Calls `playScale()`.
     */
    @IBAction func playAgain(sender: UIButton){
        
        playScale(scale: scaleList[scaleType])
        
    }
    
    /**
     Moves on to the next exercise by resetting the buttons and randomly selecting a scale type and first note.
     - Parameters:
        - sender: The UIButton labeled next.
     */
    @IBAction func next(sender: UIButton){
        // Reset interval button background color
        for b in scaleButtons{
            b.backgroundColor = UIColor.white
            b.alpha = 1.0
            b.isEnabled = true
        }
        
        exerciseNum += 1
        exerciseNumLabel.text = "Exercise # \(exerciseNum)"
        
        scaleType = Int(arc4random_uniform(7))
        firstNote = Int(arc4random_uniform(12))
        
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
    
    /// Button turns green if the scale played is an ionian scale, turns red if not.
    @IBAction func ionian(sender: UIButton){
        checkAnswer(button: sender, scale: 0)
    }
    
    /// Button turns green if the scale played is a dorian scale, turns red if not.
    @IBAction func dorian(sender: UIButton){
        checkAnswer(button: sender, scale: 1)
    }
    
    /// Button turns green if the scale played is a phrygian scale, turns red if not.
    @IBAction func phrygian(sender: UIButton){
        checkAnswer(button: sender, scale: 2)
    }
    
    /// Button turns green if the scale played is a lydian scale, turns red if not.
    @IBAction func lydian(sender: UIButton){
        checkAnswer(button: sender, scale: 3)
    }
    
    /// Button turns green if the scale played is a mixolydian scale, turns red if not.
    @IBAction func mixolydian(sender: UIButton){
        checkAnswer(button: sender, scale: 4)
    }
    
    /// Button turns green if the scale played is an aeolian scale, turns red if not.
    @IBAction func aeolian(sender: UIButton){
        checkAnswer(button: sender, scale: 5)
    }
    
    /// Button turns green if the scale played is a locrian scale, turns red if not.
    @IBAction func locrian(sender: UIButton){
        checkAnswer(button: sender, scale: 6)
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
