//
//  ChromaticScalesViewController.swift
//  EarTraining
//
//  Created by Ariel Todoki on 4/11/18.
//  Copyright © 2018 Ariel Todoki. All rights reserved.
//

import UIKit
import AudioKit
import AudioKitUI

class ChromaticScalesViewController: UIViewController {

    @IBOutlet var scaleButtons: [UIButton]!
    @IBOutlet var instrumentButtons: [UIButton]!
    
    let noteFrequency = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    let noteCents = [0.0, 100.0, 200.0, 300.0, 400.0, 500.0, 600.0, 700.0, 800.0, 900.0, 1000.0, 1100.0]
    
    
    let chromatic = [0,1,2,3,4,5,6,7,8,9,10,11,12]
    let wholeTone = [0,2,4,6,8,10,12]
    let whOctatonic = [0,2,3,5,6,8,9,11,12]
    let hwOctatonic = [0,1,3,4,6,7,9,10,12]
    
    var scaleList = [[Int]]()
    
    
    var scaleType = 0
    var firstNote = 0
    
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
        
        // Do any additional setup after loading the view.
        scaleList.append(chromatic)
        scaleList.append(wholeTone)
        scaleList.append(whOctatonic)
        scaleList.append(hwOctatonic)
        
        scaleType = Int(arc4random_uniform(4))
        firstNote = Int(arc4random_uniform(12))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AudioKit.start()
        
        playScale(scale: scaleList[scaleType])
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AudioKit.stop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playScale(scale: Array<Int>){
        
        for i in scale{
            let noteIndex = firstNote+i
            
            timePitch.pitch = (noteIndex > 11 ? noteCents[noteIndex%12] + 1200.0 : noteCents[noteIndex])
            sampler.play()
            
            sleep(1)
        }
        
    }
    
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
    
    @IBAction func playAgain(sender: UIButton){
        
        playScale(scale: scaleList[scaleType])
        
    }
    
    @IBAction func next(sender: UIButton){
        // Reset interval button background color
        for b in scaleButtons{
            b.backgroundColor = UIColor.white
            b.alpha = 1.0
            b.isEnabled = true
        }
        
        scaleType = Int(arc4random_uniform(4))
        firstNote = Int(arc4random_uniform(12))
        
        
    }
    
    @IBAction func piano(sender: UIButton){
        try! sampler.loadWav("../\(soundNames[0])")
        closeInstButtons()
    }
    
    @IBAction func clarinet(sender: UIButton){
        try! sampler.loadWav("../\(soundNames[1])")
        closeInstButtons()
    }
    
    @IBAction func frenchHorn(sender: UIButton){
        try! sampler.loadWav("../\(soundNames[2])")
        closeInstButtons()
    }
    
    @IBAction func string(sender: UIButton){
        try! sampler.loadWav("../\(soundNames[3])")
        closeInstButtons()
    }
    
    @IBAction func chromatic(sender: UIButton){
        checkAnswer(button: sender, scale: 0)
    }
    
    @IBAction func wholeTone(sender: UIButton){
        checkAnswer(button: sender, scale: 1)
    }
    
    @IBAction func whOctatonic(sender: UIButton){
        checkAnswer(button: sender, scale: 2)
    }
    
    @IBAction func hwOctatonic(sender: UIButton){
        checkAnswer(button: sender, scale: 3)
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
