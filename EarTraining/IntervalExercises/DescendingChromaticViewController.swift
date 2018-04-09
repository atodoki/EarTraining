//
//  DescendingChromaticViewController.swift
//  EarTraining
//
//  Created by Ariel Todoki on 4/7/18.
//  Copyright © 2018 Ariel Todoki. All rights reserved.
//

import UIKit
import AudioKit
import AudioKitUI

class DescendingChromaticViewController: UIViewController {

    @IBOutlet var intervalButtons: [UIButton]!
    @IBOutlet var exerciseNumLabel: UILabel!
    
    let noteFrequency = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    let noteNameSharps = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
    let noteNameFlats = ["C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"]
    
    var bNoteOctave = 4
    var tNoteOctave = 4
    
    var bottomNote = 0
    var topNote = 0
    var intervalSize = 0
    var exerciseNum = 1;
    
    let sampler = AKSampler()
    var timePitch: AKTimePitch!
    
    let noteCents = [0.0, 100.0, 200.0, 300.0, 400.0, 500.0, 600.0, 700.0, 800.0, 900.0, 1000.0, 1100.0]
    
    let octaveChange = [-6000.0,-3600.0,-2400.0,-1200.0,0,1200.0,2400.0]
    
    let soundNames = ["Kawai-K11-GrPiano-C4", "Ensoniq-SQ-1-Clarinet-C4", "Ensoniq-SQ-1-French-Horn-C4", "Alesis-Fusion-Pizzicato-Strings-C4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        try! sampler.loadWav("../\(soundNames[0])")
        
        timePitch = AKTimePitch(sampler)
        timePitch.rate = 2.0
        timePitch.pitch = 0.0
        timePitch.overlap = 8.0
        
        AudioKit.output = timePitch
        
        setInterval()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AudioKit.start()
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AudioKit.stop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Defined Functions
    
    func setInterval(){
        topNote = Int(arc4random_uniform(12)) // random number 0<n<12-1
        intervalSize = Int(arc4random_uniform(11))+1 // random number 1<n<11
        bottomNote = topNote - intervalSize // random number chromatic interval from top note
        tNoteOctave = Int(arc4random_uniform(3))+3
        bNoteOctave = (bottomNote < 0 ? tNoteOctave - 1 : tNoteOctave)
        bottomNote += 12
    }
    
    func playInterval(){
        timePitch.pitch = noteCents[topNote] + octaveChange[tNoteOctave]
        sampler.play()
        sleep(1)
        
        timePitch.pitch = noteCents[bottomNote%12] + octaveChange[bNoteOctave]
        sampler.play()
    }
    
    func checkAnswer(sender: UIButton, interval: Int){
        if(intervalSize == interval){
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
        playInterval()
    }
    
    @IBAction func next(sender: UIButton){
        // Reset interval button background color
        for b in intervalButtons{
            b.backgroundColor = UIColor.white
            b.alpha = 1.0
            b.isEnabled = true
        }
        
        setInterval()
        
        exerciseNum += 1
        
        exerciseNumLabel.text = "Exercise #\(exerciseNum)"
        
    }
    
    
    @IBAction func minorSecond(sender: UIButton){
        // Button turns green if the interval played is a minor second, turns red if not
        checkAnswer(sender: sender, interval: 1)
    }
    
    @IBAction func majorSecond(sender: UIButton){
        // Button turns green if the interval played is a major second, turns red if not
        checkAnswer(sender: sender, interval: 2)
        
    }
    
    @IBAction func minorThird(sender: UIButton){
        // Button turns green if the interval played is a minor third, turns red if not
        checkAnswer(sender: sender, interval: 3)
        
    }
    
    @IBAction func majorThird(sender: UIButton){
        // Button turns green if the interval played is a major third, turns red if not
        checkAnswer(sender: sender, interval: 4)
        
    }
    
    @IBAction func perfectFourth(sender: UIButton){
        // Button turns green if the interval played is a perfect fourth, turns red if not
        checkAnswer(sender: sender, interval: 5)
        
    }
    
    @IBAction func tritone(sender: UIButton){
        // Button turns green if the interval played is a tritone, turns red if not
        checkAnswer(sender: sender, interval: 6)
        
    }
    
    @IBAction func perfectFifth(sender: UIButton){
        // Button turns green if the interval played is a perfect fifth, turns red if not
        checkAnswer(sender: sender, interval: 7)
        
    }
    
    @IBAction func minorSixth(sender: UIButton){
        // Button turns green if the interval played is a minor sixth, turns red if not
        checkAnswer(sender: sender, interval: 8)
        
    }
    
    @IBAction func majorSixth(sender: UIButton){
        // Button turns green if the interval played is a major sixth, turns red if not
        checkAnswer(sender: sender, interval: 9)
        
    }
    
    @IBAction func minorSeventh(sender: UIButton){
        // Button turns green if the interval played is a minor seventh, turns red if not
        checkAnswer(sender: sender, interval: 10)
        
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
