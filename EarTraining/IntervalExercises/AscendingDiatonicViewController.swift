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
    
    //let noteFrequency = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    let noteCents = [0.0, 100.0, 200.0, 300.0, 400.0, 500.0, 600.0, 700.0, 800.0, 900.0, 1000.0, 1100.0]
    
    let diatonicIntervals = [2,4,5,7,9,11,12]

    
    var bottomNote = 0
    var topNote = 0
    var randomIndex = 0
    
    var exerciseNum = 1
    
    
    let sampler = AKSampler()
    var player: AKSampler!
    var timePitch: AKTimePitch!

    let soundNames = ["Kawai-K11-GrPiano-C4", "Ensoniq-SQ-1-Clarinet-C4", "Ensoniq-SQ-1-French-Horn-C4", "Alesis-Fusion-Pizzicato-Strings-C4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        try! sampler.loadWav("../\(soundNames[0])")

        
        timePitch = AKTimePitch(sampler)
        timePitch.rate = 2.0
        timePitch.pitch = 0.0
        timePitch.overlap = 8.0
        
        AudioKit.output = timePitch
        
        
        bottomNote = Int(arc4random_uniform(12)) // random number 0<n<12-1
        randomIndex = Int(arc4random_uniform(UInt32(diatonicIntervals.count))) // random number from array diatonicIntervals
        topNote = bottomNote + diatonicIntervals[randomIndex] // random number diatonic interval from bottomNote
        
        
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AudioKit.start()
        
        sampler.play()
        timePitch.pitch = noteCents[bottomNote]
        
        sleep(1)
       
        if(topNote > 11){
            timePitch.pitch = noteCents[topNote%12] + 1200.0
        } else{
            timePitch.pitch = noteCents[topNote]
        }
        sampler.play()
        
        
    }
    

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AudioKit.stop()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkAnswer(sender: UIButton, interval: Int){
        if(topNote - bottomNote == interval){
            sender.backgroundColor = UIColor.green
            for b in intervalButtons{
                //b.alpha = 0.5
                b.isEnabled = false
            }
        }
        else{
            sender.backgroundColor = UIColor.red
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func piano(sender: UIButton){
        try! sampler.loadWav("../\(soundNames[0])")
    }
    
    @IBAction func clarinet(sender: UIButton){
        try! sampler.loadWav("../\(soundNames[1])")
    }
    
    @IBAction func frenchHorn(sender: UIButton){
        try! sampler.loadWav("../\(soundNames[2])")
    }
    
    @IBAction func string(sender: UIButton){
        try! sampler.loadWav("../\(soundNames[3])")
    }
    
    @IBAction func playAgain(sender: UIButton){
        sampler.play()
        timePitch.pitch = noteCents[bottomNote]
        sleep(1)
        
        if(topNote > 11){
            timePitch.pitch = noteCents[topNote%12] + 1200.0
        } else{
            timePitch.pitch = noteCents[topNote]
        }
        sampler.play()
        
    }
    
    @IBAction func next(sender: UIButton){
        
        // MAKE BUTTON BACKGROUNDS GO BACK TO NORMAL
        for b in intervalButtons{
            b.backgroundColor = UIColor.white
            b.isEnabled = true
        }
        
        bottomNote = Int(arc4random_uniform(12)) // random number 0<n<12-1
        randomIndex = Int(arc4random_uniform(UInt32(diatonicIntervals.count))) // random number from array diatonicIntervals
        topNote = bottomNote + diatonicIntervals[randomIndex] // random number diatonic interval from bottomNote
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
