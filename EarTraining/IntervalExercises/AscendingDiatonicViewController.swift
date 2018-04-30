//
//  AscendingDiatonicViewController.swift
//  EarTraining
//
//  Created by Ariel Todoki on 2/7/18.
//  Copyright © 2018 Ariel Todoki. All rights reserved.
//

import UIKit
import AudioKit


class AscendingDiatonicViewController: UIViewController {
    
    @IBOutlet var intervalButtons: [UIButton]!
    @IBOutlet var instrumentButtons: [UIButton]!
    @IBOutlet var exerciseNumLabel: UILabel!

    let noteCents = [0.0, 100.0, 200.0, 300.0, 400.0, 500.0, 600.0, 700.0, 800.0, 900.0, 1000.0, 1100.0]
    let octaveChange = [0,0,-2400.0,-1200.0,0,1200.0,2400.0]
    
    let diatonicIntervals = [2,4,5,7,9,11,12]
    
    var bNoteOctave = 4
    var tNoteOctave = 4

    var bottomNote = 0
    var topNote = 0
    var randomIndex = 0
    
    var exerciseNum = 1
    
    var conductor = Conductor.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        conductor.closeMic()
        setInterval()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Defined Functions
    
    func setInterval(){
        bottomNote = Int(arc4random_uniform(12)) // random number 0<n<12-1
        randomIndex = Int(arc4random_uniform(UInt32(diatonicIntervals.count))) // random number from array diatonicIntervals
        topNote = bottomNote + diatonicIntervals[randomIndex] // random number diatonic interval from bottomNote
        bNoteOctave = Int(arc4random_uniform(3))+3 // octave 3 to 5
        tNoteOctave = topNote > 11 ? bNoteOctave + 1 : bNoteOctave
        
    }
    
    func playInterval(){
        conductor.changePitch(pitch: noteCents[bottomNote] + octaveChange[bNoteOctave], note: .root)
        conductor.play(note: .root)

        sleep(1)
        
        conductor.changePitch(pitch: noteCents[topNote%12] + octaveChange[tNoteOctave], note: .root)
        conductor.play(note: .root)

    }
    
    func checkAnswer(sender: UIButton, interval: Int){
        if(topNote - bottomNote == interval){
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
    
    @IBAction func playAgain(sender: UIButton){
        playInterval()
    }
    
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
    
    
    @IBAction func majorSecond(sender: UIButton){
        // Button turns green if the interval played is a major second, turns red if not
        checkAnswer(sender: sender, interval: 2)
        
    }
    
    @IBAction func majorThird(sender: UIButton){
        // Button turns green if the interval played is a major third, turns red if not
        checkAnswer(sender: sender, interval: 4)
        
    }
    
    @IBAction func perfectFourth(sender: UIButton){
        // Button turns green if the interval played is a perfect fourth, turns red if not
        checkAnswer(sender: sender, interval: 5)
        
    }
    
    @IBAction func perfectFifth(sender: UIButton){
        // Button turns green if the interval played is a perfect fifth, turns red if not
        checkAnswer(sender: sender, interval: 7)
        
    }
    
    @IBAction func majorSixth(sender: UIButton){
        // Button turns green if the interval played is a major sixth, turns red if not
        checkAnswer(sender: sender, interval: 9)
    }
    
    @IBAction func majorSeventh(sender: UIButton){
        // Button turns green if the interval played is a major seventh, turns red if not
        checkAnswer(sender: sender, interval: 11)
        
    }
    
    @IBAction func octave(sender: UIButton){
        // Button turns green if the interval played is an octave, turns red if not
        checkAnswer(sender: sender, interval: 12)
        
    }
    
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
