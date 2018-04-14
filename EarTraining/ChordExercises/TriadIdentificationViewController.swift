//
//  BasicChordIdentificationViewController.swift
//  EarTraining
//
//  Created by Ariel Todoki on 3/2/18.
//  Copyright © 2018 Ariel Todoki. All rights reserved.
//

import UIKit
import AudioKit

class TriadIdentificationViewController: UIViewController {
    
    @IBOutlet var intervalButtons: [UIButton]!
    @IBOutlet var instrumentButtons: [UIButton]!
    @IBOutlet var exerciseNumLabel: UILabel!
    
    //let noteFrequency = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    let noteCents = [0.0, 100.0, 200.0, 300.0, 400.0, 500.0, 600.0, 700.0, 800.0, 900.0, 1000.0, 1100.0]
    
    //let diatonicIntervals = [2,4,5,7,9,11,12]
    let majChord = [4,7]
    let minChord = [3,7]
    let dimChord = [3,6]
    let augChord = [4,8]
    
    var chordList = [[Int]]()
    
    var chordType = 0
    var root = 0
    var third = 0
    var fifth = 0

    var exerciseNum = 1
    
//    var samplerRoot = AKAppleSampler()
//    var samplerThird = AKAppleSampler()
//    var samplerFifth = AKAppleSampler()
//
//    //var player: AKSampler!
//
//    var tpRoot: AKTimePitch!
//    var tpThird: AKTimePitch!
//    var tpFifth: AKTimePitch!
//
//    var mixer = AKMixer()
    
    var conductor = Conductor.sharedInstance
    
    let soundNames = ["Kawai-K11-GrPiano-C4", "Ensoniq-SQ-1-Clarinet-C4", "Ensoniq-SQ-1-French-Horn-C4", "Alesis-Fusion-Pizzicato-Strings-C4"]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chordList.append(majChord)
        chordList.append(minChord)
        chordList.append(dimChord)
        chordList.append(augChord)
        
        
//        try! samplerRoot.loadWav("../\(soundNames[0])")
//        try! samplerThird.loadWav("../\(soundNames[0])")
//        try! samplerFifth.loadWav("../\(soundNames[0])")
//
//
//        tpRoot = AKTimePitch(samplerRoot)
//        tpRoot.rate = 2.0
//
//        tpThird = AKTimePitch(samplerThird)
//        tpThird.rate = 2.0
//
//        tpFifth = AKTimePitch(samplerFifth)
//        tpFifth.rate = 2.0

        setChord()
        
//        mixer.connect(input: tpRoot)
//        mixer.connect(input: tpThird)
//        mixer.connect(input: tpFifth)
//
//        AudioKit.output = mixer

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        do {
//            try AudioKit.start()
//        } catch {
//            AKLog("AudioKit did not start!")
//        }
        
        playChord()
        
        
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        do {
//            try AudioKit.stop()
//        } catch {
//            AKLog("AudioKit did not stop!")
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChord(){
        chordType = Int(arc4random_uniform(4))
        root = Int(arc4random_uniform(12))
        third = root + chordList[chordType][0]
        fifth = root + chordList[chordType][1]
        
        conductor.changePitch(pitch: noteCents[root], note: .root)
        conductor.changePitch(pitch: third > 11 ? noteCents[third%12] + 1200.0 : noteCents[third], note: .third)
        conductor.changePitch(pitch: fifth > 11 ? noteCents[fifth%12] + 1200.0 : noteCents[fifth], note: .fifth)
        
//        tpRoot.pitch = noteCents[root]
//        tpThird.pitch = (third > 11 ? noteCents[third%12] + 1200.0 : noteCents[third])
//        tpFifth.pitch = (fifth > 11 ? noteCents[fifth%12] + 1200.0 : noteCents[fifth])
    }
    
    func playChord(){
        conductor.play(note: .root)
        conductor.play(note: .third)
        conductor.play(note: .fifth)
//        try! samplerRoot.play()
//        try! samplerThird.play()
//        try! samplerFifth.play()
    }
    
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
//        try! samplerRoot.loadWav("../\(soundNames[0])")
//        try! samplerThird.loadWav("../\(soundNames[0])")
//        try! samplerFifth.loadWav("../\(soundNames[0])")
        closeInstButtons()
    }
    
    @IBAction func clarinet(sender: UIButton){
        conductor.changeInstrument(instr: .clarinet)
//        try! samplerRoot.loadWav("../\(soundNames[1])")
//        try! samplerThird.loadWav("../\(soundNames[1])")
//        try! samplerFifth.loadWav("../\(soundNames[1])")
        closeInstButtons()
    }
    
    @IBAction func frenchHorn(sender: UIButton){
        conductor.changeInstrument(instr: .french_horn)
//        try! samplerRoot.loadWav("../\(soundNames[2])")
//        try! samplerThird.loadWav("../\(soundNames[2])")
//        try! samplerFifth.loadWav("../\(soundNames[2])")
        closeInstButtons()
    }
    
    @IBAction func string(sender: UIButton){
        conductor.changeInstrument(instr: .pizz_strings)
//        try! samplerRoot.loadWav("../\(soundNames[3])")
//        try! samplerThird.loadWav("../\(soundNames[3])")
//        try! samplerFifth.loadWav("../\(soundNames[3])")
        closeInstButtons()
    }
    
    
    @IBAction func playAgain(sender: UIButton){
        
        playChord()
        
    }
    
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
    
    @IBAction func majChord(sender: UIButton){
        checkAnswer(button: sender, chord: 0)
    }
    
    @IBAction func minChord(sender: UIButton){
        checkAnswer(button: sender, chord: 1)
    }
    
    @IBAction func dimChord(sender: UIButton){
        checkAnswer(button: sender, chord: 2)
    }
    
    @IBAction func augChord(sender: UIButton){
        checkAnswer(button: sender, chord: 3)
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
