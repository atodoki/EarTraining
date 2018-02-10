//
//  AscendingChromaticViewController.swift
//  EarTraining
//
//  Created by Ariel Todoki on 2/9/18.
//  Copyright © 2018 Ariel Todoki. All rights reserved.
//

import UIKit
import AudioKit
import AudioKitUI

class AscendingChromaticViewController: UIViewController {
    
    @IBOutlet var intervalButtons: [UIButton]!
    
    let noteFrequency = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    let noteNameSharps = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
    let noteNameFlats = ["C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"]
    
    var bNoteOctave = 4.0
    var tNoteOctave = 4.0
    
    var bottomNote = 0
    var topNote = 0
    var randomIndex = 0
    
    let oscillator = AKOscillator()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bottomNote = Int(arc4random_uniform(12)) // random number 0<n<12-1
        randomIndex = Int(arc4random_uniform(11))+1 // random number 1<n<11
        topNote = bottomNote + randomIndex // random number chromatic interval from bottom note
        
        oscillator.frequency = 0.0
        oscillator.amplitude = 0.5
        AudioKit.output = oscillator
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AudioKit.start()
        
        oscillator.start()
        
        if(topNote > 11){
            tNoteOctave = bNoteOctave + 1
        }
        
        oscillator.frequency = noteFrequency[bottomNote] * pow(2,bNoteOctave)
        sleep(2)
        oscillator.frequency = noteFrequency[topNote%12] * pow(2,tNoteOctave)
        sleep(2)
        
        oscillator.stop()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Actions
    
    @IBAction func playAgain(sender: UIButton){
        oscillator.frequency = noteFrequency[bottomNote] * pow(2,bNoteOctave)
        oscillator.start()
        sleep(2)
        oscillator.frequency = noteFrequency[topNote%12] * pow(2,tNoteOctave)
        sleep(2)
        oscillator.stop()
    }
    
    @IBAction func next(sender: UIButton){
        // Reset interval button background color
        for b in intervalButtons{
            b.backgroundColor = UIColor.white
        }
        
        bottomNote = Int(arc4random_uniform(12)) // random number 0<n<12-1
        randomIndex = Int(arc4random_uniform(12)) // random number 0<n<12-1
        topNote = bottomNote + randomIndex // random number diatonic interval from bottomNote
        
        if(topNote > 11){
            tNoteOctave = bNoteOctave + 1
        } else {
            tNoteOctave = bNoteOctave
        }
        
//        oscillator.frequency = noteFrequency[bottomNote] * pow(2,bNoteOctave)
//        oscillator.start()
//        sleep(2)
//        oscillator.frequency = noteFrequency[topNote%12] * pow(2,tNoteOctave)
//        sleep(2)
//        oscillator.stop()
        
        
    }

    
    @IBAction func minorSecond(sender: UIButton){
        // Button turns green if the interval played is a minor second, turns red if not
        if(topNote - bottomNote == 1){
            sender.backgroundColor = UIColor.green
        }
        else{
            sender.backgroundColor = UIColor.red
        }
    }
    
    @IBAction func majorSecond(sender: UIButton){
        // Button turns green if the interval played is a major second, turns red if not
        if(topNote - bottomNote == 2){
            sender.backgroundColor = UIColor.green
        }
        else{
            sender.backgroundColor = UIColor.red
        }
        
    }
    
    @IBAction func minorThird(sender: UIButton){
        // Button turns green if the interval played is a minor third, turns red if not
        if(topNote - bottomNote == 3){
            sender.backgroundColor = UIColor.green
        }
        else{
            sender.backgroundColor = UIColor.red
        }
        
    }
    
    @IBAction func majorThird(sender: UIButton){
        // Button turns green if the interval played is a major third, turns red if not
        if(topNote - bottomNote == 4){
            sender.backgroundColor = UIColor.green
        }
        else{
            sender.backgroundColor = UIColor.red
        }
        
    }
    
    @IBAction func perfectFourth(sender: UIButton){
        // Button turns green if the interval played is a perfect fourth, turns red if not
        if(topNote - bottomNote == 5){
            sender.backgroundColor = UIColor.green
        }
        else{
            sender.backgroundColor = UIColor.red
        }
        
    }
    
    @IBAction func tritone(sender: UIButton){
        // Button turns green if the interval played is a tritone, turns red if not
        if(topNote - bottomNote == 6){
            sender.backgroundColor = UIColor.green
        }
        else{
            sender.backgroundColor = UIColor.red
        }
        
    }
    
    @IBAction func perfectFifth(sender: UIButton){
        // Button turns green if the interval played is a perfect fifth, turns red if not
        if(topNote - bottomNote == 7){
            sender.backgroundColor = UIColor.green
        }
        else{
            sender.backgroundColor = UIColor.red
        }
        
    }
    
    @IBAction func minorSixth(sender: UIButton){
        // Button turns green if the interval played is a minor sixth, turns red if not
        if(topNote - bottomNote == 8){
            sender.backgroundColor = UIColor.green
        }
        else{
            sender.backgroundColor = UIColor.red
        }
        
    }
    
    @IBAction func majorSixth(sender: UIButton){
        // Button turns green if the interval played is a major sixth, turns red if not
        if(topNote - bottomNote == 9){
            sender.backgroundColor = UIColor.green
        }
        else{
            sender.backgroundColor = UIColor.red
        }
        
    }
    
    @IBAction func minorSeventh(sender: UIButton){
        // Button turns green if the interval played is a minor seventh, turns red if not
        if(topNote - bottomNote == 10){
            sender.backgroundColor = UIColor.green
        }
        else{
            sender.backgroundColor = UIColor.red
        }
        
    }
    
    @IBAction func majorSeventh(sender: UIButton){
        // Button turns green if the interval played is a major seventh, turns red if not
        if(topNote - bottomNote == 11){
            sender.backgroundColor = UIColor.green
        }
        else{
            sender.backgroundColor = UIColor.red
        }
        
    }
    
    @IBAction func octave(sender: UIButton){
        // Button turns green if the interval played is an octave, turns red if not
        if(topNote - bottomNote == 12){
            sender.backgroundColor = UIColor.green
        }
        else{
            sender.backgroundColor = UIColor.red
        }
        
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
