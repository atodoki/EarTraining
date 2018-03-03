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
    
    @IBOutlet var intervalButtons: [UIButton]!
    @IBOutlet var exerciseNumLabel: UILabel!
    
    let noteFrequency = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    let noteNameSharps = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
    let noteNameFlats = ["C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"]
    
    let diatonicIntervals = [2,4,5,7,9,11,12]
    var bNoteOctave = 4.0
    var tNoteOctave = 4.0
    
    var bottomNote = 0
    var topNote = 0
    var randomIndex = 0
    
    var exerciseNum = 1
    
    let oscillator = AKOscillator()
    var envelope: AKAmplitudeEnvelope!
    
    var frequencies = (1...5).map{ $0 * 261.63}
    let mixer = AKMixer()
    var oscillators = [AKOscillator()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        bottomNote = Int(arc4random_uniform(12)) // random number 0<n<12-1
        randomIndex = Int(arc4random_uniform(UInt32(diatonicIntervals.count))) // random number from array diatonicIntervals
        topNote = bottomNote + diatonicIntervals[randomIndex] // random number diatonic interval from bottomNote
        
        
//        oscillator.frequency = 0.0
//        oscillator.amplitude = 0.5
        
        oscillators = frequencies.map { createAndStartOscillator(frequency: $0)}
        
        oscillators[0].amplitude = 1.0
        oscillators[1].amplitude = 0.1
        oscillators[2].amplitude = 0.35
        oscillators[3].amplitude = 0.08
        oscillators[4].amplitude = 0.07
        
        oscillators.forEach{mixer.connect(input: $0)}
        
        envelope = AKAmplitudeEnvelope(mixer)
        envelope.attackDuration = 0.01
        envelope.decayDuration = 0.1
        envelope.sustainLevel = 0.1
        envelope.releaseDuration = 0.3

        
        AudioKit.output = envelope
        //AudioKit.output = oscillator
        
    }
    
    func createAndStartOscillator(frequency: Double) -> AKOscillator {
        let oscillator = AKOscillator(waveform: AKTable(.positiveTriangle))
        oscillator.frequency = frequency
        oscillator.start()
        return oscillator
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AudioKit.start()
        
        oscillator.start()
        envelope.start()
        
        if(topNote > 11){
            tNoteOctave = bNoteOctave + 1
        }
        
        envelope.start()
        
        changeFrequency(frequency: noteFrequency[bottomNote] * pow(2,bNoteOctave))
        //oscillator.frequency = noteFrequency[bottomNote] * pow(2,bNoteOctave)
        sleep(1)
        
        
        envelope.stop()
        sleep(1)
        
        oscillator.start()
        envelope.start()
        changeFrequency(frequency: noteFrequency[topNote%12] * pow(2,tNoteOctave))
       //oscillator.frequency = noteFrequency[topNote%12] * pow(2,tNoteOctave)

        sleep(1)
        
//        for i in cMajScale{
//            oscillator.frequency = noteFrequency[i] * pow(2,octave)
//            sleep(1)
//        }
        envelope.stop()
        sleep(1)
        oscillator.stop()
        
        
    }
    
    func changeFrequency(frequency: Double){
        frequencies = (1...5).map{$0 * frequency}
        for i in (0...4){
            oscillators[i].frequency = frequencies[i]
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AudioKit.stop()
        oscillator.stop()
        envelope.stop()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Actions
    
    @IBAction func playAgain(sender: UIButton){
        changeFrequency(frequency: noteFrequency[bottomNote] * pow(2,bNoteOctave))
        //oscillator.frequency = noteFrequency[bottomNote] * pow(2,bNoteOctave)
        envelope.start()
        oscillator.start()
        sleep(1)
        envelope.stop()
        sleep(1)
        
        envelope.start()
        changeFrequency(frequency: noteFrequency[topNote%12] * pow(2,tNoteOctave))
        //oscillator.frequency = noteFrequency[topNote%12] * pow(2,tNoteOctave)
        sleep(1)
        envelope.stop()
        sleep(1)
        oscillator.stop()
    }
    
    @IBAction func next(sender: UIButton){
        
        // MAKE BUTTON BACKGROUNDS GO BACK TO NORMAL
        for b in intervalButtons{
            b.backgroundColor = UIColor.white
        }
        
        bottomNote = Int(arc4random_uniform(12)) // random number 0<n<12-1
        randomIndex = Int(arc4random_uniform(UInt32(diatonicIntervals.count))) // random number from array diatonicIntervals
        topNote = bottomNote + diatonicIntervals[randomIndex] // random number diatonic interval from bottomNote
        
        if(topNote > 11){
            tNoteOctave = bNoteOctave + 1
        }else {
            tNoteOctave = bNoteOctave
        }
        
        exerciseNum += 1
        
        exerciseNumLabel.text = "Exercise #\(exerciseNum)"
        
//        oscillator.frequency = noteFrequency[bottomNote] * pow(2,bNoteOctave)
//        oscillator.start()
//        sleep(2)
//        oscillator.frequency = noteFrequency[topNote%12] * pow(2,tNoteOctave)
//        sleep(2)
//        oscillator.stop()
        
        
        
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
    
    @IBAction func perfectFifth(sender: UIButton){
        // Button turns green if the interval played is a perfect fifth, turns red if not
        if(topNote - bottomNote == 7){
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
        else {
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
