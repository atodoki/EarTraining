//
//  AscendingDiatonicViewController.swift
//  EarTraining
//
//  Created by Ariel Todoki on 2/7/18.
//  Copyright © 2018 Ariel Todoki. All rights reserved.
//

import UIKit
import AudioKit
import AudioKitUI

class AscendingDiatonicViewController: UIViewController {
    
    var noteFrequency = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    var noteNameSharps = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
    var noteNameFlats = ["C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"]
    
    var cMajScale = [0,2,4,5,7,9,11]
    var bNoteOctave = 4.0
    var tNoteOctave = 4.0
    
    var bottomNote = 0
    var topNote = 0
    
    let oscillator = AKOscillator()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bottomNote = Int(arc4random_uniform(12)) // returns random number 0<n<12-1
        topNote = Int(arc4random_uniform(12)) // returns random number 0<n<12-1
        
//        oscillator.rampTime = 0.2
        oscillator.frequency = 0.0
        oscillator.amplitude = 0.1
        AudioKit.output = oscillator
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AudioKit.start()
        
        oscillator.start()
        
        if(bottomNote > topNote){
            tNoteOctave = bNoteOctave + 1
        }
        
        oscillator.frequency = noteFrequency[bottomNote] * pow(2,bNoteOctave)
        sleep(2)
        oscillator.frequency = noteFrequency[topNote] * pow(2,tNoteOctave)
        sleep(2)
        
//        for i in cMajScale{
//            oscillator.frequency = noteFrequency[i] * pow(2,octave)
//            sleep(1)
//        }
        oscillator.stop()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playAgain(sender: UIButton){
        oscillator.frequency = noteFrequency[bottomNote] * pow(2,bNoteOctave)
        oscillator.start()
        sleep(2)
        oscillator.frequency = noteFrequency[topNote] * pow(2,tNoteOctave)
        sleep(2)
        oscillator.stop()
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
