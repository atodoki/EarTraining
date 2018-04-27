//
//  SeventhIdentificationViewController.swift
//  EarTraining
//
//  Created by Ariel Todoki on 4/25/18.
//  Copyright © 2018 Ariel Todoki. All rights reserved.
//

import UIKit

class SeventhIdentificationViewController: UIViewController {

    @IBOutlet var intervalButtons: [UIButton]!
    @IBOutlet var instrumentButtons: [UIButton]!
    @IBOutlet var exerciseNumLabel: UILabel!
    

    let noteCents = [0.0, 100.0, 200.0, 300.0, 400.0, 500.0, 600.0, 700.0, 800.0, 900.0, 1000.0, 1100.0]
    let octaveChange = [0,0,-2400.0,-1200.0,0,1200.0,2400.0]
    
    let majSChord = [4,7,11]
    let minSChord = [3,7,10]
    let domChord = [4,7,10]
    let hDimChord = [3,6,10]
    let fDimChord = [3,6,9]
    
    
    var chordList = [[Int]]()
    
    var chordType = 0
    
    var root = 0
    var third = 0
    var fifth = 0
    var seventh = 0
    
    var rootOctave = 4
    var thirdOctave = 4
    var fifthOctave = 4
    var seventhOctave = 4
    
    var exerciseNum = 1
    
    var conductor = Conductor.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chordList.append(majSChord)
        chordList.append(minSChord)
        chordList.append(domChord)
        chordList.append(hDimChord)
        chordList.append(fDimChord)
        
        
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
        chordType = Int(arc4random_uniform(5))
        root = Int(arc4random_uniform(12))
        third = root + chordList[chordType][0]
        fifth = root + chordList[chordType][1]
        seventh = root + chordList[chordType][2]
        
        rootOctave = Int(arc4random_uniform(2) + 3)
        thirdOctave = third > 11 ? rootOctave + 1 : rootOctave
        fifthOctave = fifth > 11 ? rootOctave + 1 : rootOctave
        seventhOctave = seventh > 11 ? rootOctave + 1 : rootOctave
        
        conductor.changePitch(pitch: noteCents[root] + octaveChange[rootOctave], note: .root)
        conductor.changePitch(pitch: noteCents[third%12] + octaveChange[thirdOctave], note: .third)
        conductor.changePitch(pitch: noteCents[fifth%12] + octaveChange[fifthOctave], note: .fifth)
        conductor.changePitch(pitch: noteCents[seventh%12] + octaveChange[seventhOctave], note: .seventh)
        
    }
    
    func playChord(){
        conductor.play(note: .root)
        conductor.play(note: .third)
        conductor.play(note: .fifth)
        conductor.play(note: .seventh)
        
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
        
        exerciseNumLabel.text = "Exercise # \(exerciseNum)"
        
        
    }
    
    @IBAction func majSChord(sender: UIButton){
        checkAnswer(button: sender, chord: 0)
    }
    
    @IBAction func minSChord(sender: UIButton){
        checkAnswer(button: sender, chord: 1)
    }
    
    @IBAction func domChord(sender: UIButton){
        checkAnswer(button: sender, chord: 2)
    }
    
    @IBAction func hDimChord(sender: UIButton){
        checkAnswer(button: sender, chord: 3)
    }
    
    @IBAction func fDimChord(sender: UIButton){
        checkAnswer(button: sender, chord: 4)
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
