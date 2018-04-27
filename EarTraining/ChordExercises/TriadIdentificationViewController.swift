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
    let octaveChange = [0,0,-2400.0,-1200.0,0,1200.0,2400.0]
    
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
    
    var rootOctave = 4
    var thirdOctave = 4
    var fifthOctave = 4

    var exerciseNum = 1
    
    
    var conductor = Conductor.sharedInstance
    
    let soundNames = ["Kawai-K11-GrPiano-C4", "Ensoniq-SQ-1-Clarinet-C4", "Ensoniq-SQ-1-French-Horn-C4", "Alesis-Fusion-Pizzicato-Strings-C4"]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chordList.append(majChord)
        chordList.append(minChord)
        chordList.append(dimChord)
        chordList.append(augChord)
        

        conductor.closeMic()
        setChord()


    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
   
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        
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
        
        rootOctave = Int(arc4random_uniform(3) + 3)
        thirdOctave = third > 11 ? rootOctave + 1 : rootOctave
        fifthOctave = fifthOctave > 11 ? rootOctave + 1 : rootOctave
        
        conductor.changePitch(pitch: noteCents[root] + octaveChange[rootOctave], note: .root)
        conductor.changePitch(pitch: noteCents[third%12] + octaveChange[thirdOctave], note: .third)
        conductor.changePitch(pitch: noteCents[fifth%12] + octaveChange[fifthOctave], note: .fifth)
        
    }
    
    func playChord(){
        conductor.play(note: .root)
        conductor.play(note: .third)
        conductor.play(note: .fifth)

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
