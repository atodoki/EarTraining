//
//  Conductor.swift
//  EarTraining
//
//  Created by Ariel Todoki on 4/13/18.
//  Copyright © 2018 Ariel Todoki. All rights reserved.
//

import AudioKit

enum Instrument {
    case piano, clarinet, french_horn, pizz_strings
}

enum Note {
    case root, third, fifth, seventh
}

class Conductor {
    
    static let sharedInstance = Conductor()
    
    var sampler1 = AKAppleSampler()
    var sampler2 = AKAppleSampler()
    var sampler3 = AKAppleSampler()
    var sampler4 = AKAppleSampler()
    
    var timePitch1: AKTimePitch!
    var timePitch2: AKTimePitch!
    var timePitch3: AKTimePitch!
    var timePitch4: AKTimePitch!
    
    var mic: AKMicrophone!
    var tracker: AKFrequencyTracker!
    var silence: AKBooster!
    var timer: Timer!
    
    
    var mixer: AKMixer!
    
    init() {
        do{
            try sampler1.loadWav("Kawai-K11-GrPiano-C4")
            timePitch1 = AKTimePitch(sampler1)
            timePitch1.rate = 2.0

            try sampler2.loadWav("Kawai-K11-GrPiano-C4")
            timePitch2 = AKTimePitch(sampler2)
            timePitch2.rate = 2.0
            
            try sampler3.loadWav("Kawai-K11-GrPiano-C4")
            timePitch3 = AKTimePitch(sampler3)
            timePitch3.rate = 2.0
            
            try sampler4.loadWav("Kawai-K11-GrPiano-C4")
            timePitch4 = AKTimePitch(sampler4)
            timePitch4.rate = 2.0
            
            mic = AKMicrophone()
            tracker = AKFrequencyTracker(mic)
            silence = AKBooster(tracker, gain: 0)
            AudioKit.output = silence
            
            mixer = AKMixer(timePitch1, timePitch2, timePitch3, timePitch4)
            mixer.volume = 3
            
            AudioKit.output = mixer
        }catch{
            AKLog("Could not find file.")
        }
        
        startAudioEngine()
    }
    
    internal func startAudioEngine() {
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit did not start!")
        }
        
    }
    
    internal func stopAudioEngine() {
        do {
            try AudioKit.stop()
        } catch {
            AKLog("Something went wrong.")
        }
        
    }
    
    func setMic(){
        AKSettings.audioInputEnabled = true
       
    }
    
    func closeMic(){
        AKSettings.audioInputEnabled = false
    }
    
    func listenFreq() -> Double{
        return tracker.frequency
    }
    
    func listenAmp() -> Double{
        return tracker.amplitude
    }
    
    func changeInstrument(instr: Instrument){
        switch instr {
        case .piano:
            do{
                try sampler1.loadWav("Kawai-K11-GrPiano-C4")
                try sampler2.loadWav("Kawai-K11-GrPiano-C4")
                try sampler3.loadWav("Kawai-K11-GrPiano-C4")
                try sampler4.loadWav("Kawai-K11-GrPiano-C4")
            }catch{
                AKLog("Could not find file.")
            }
            
        case .clarinet:
            do{
                try sampler1.loadWav("Ensoniq-SQ-1-Clarinet-C4")
                try sampler2.loadWav("Ensoniq-SQ-1-Clarinet-C4")
                try sampler3.loadWav("Ensoniq-SQ-1-Clarinet-C4")
                try sampler4.loadWav("Ensoniq-SQ-1-Clarinet-C4")
            }catch{
                AKLog("Could not find file.")
            }
        case .french_horn:
            do{
                try sampler1.loadWav("Ensoniq-SQ-1-French-Horn-C4")
                try sampler2.loadWav("Ensoniq-SQ-1-French-Horn-C4")
                try sampler3.loadWav("Ensoniq-SQ-1-French-Horn-C4")
                try sampler4.loadWav("Ensoniq-SQ-1-French-Horn-C4")
            }catch{
                AKLog("Could not find file.")
            }
            
        case .pizz_strings:
            do{
                try sampler1.loadWav("Alesis-Fusion-Pizzicato-Strings-C4")
                try sampler2.loadWav("Alesis-Fusion-Pizzicato-Strings-C4")
                try sampler3.loadWav("Alesis-Fusion-Pizzicato-Strings-C4")
                try sampler4.loadWav("Alesis-Fusion-Pizzicato-Strings-C4")
            }catch{
                AKLog("Could not find file.")
            }
            
        }
    }
    
    func changePitch(pitch: Double, note: Note){
        switch note {
        case .root:
            timePitch1.pitch = pitch
        case .third:
            timePitch2.pitch = pitch
        case .fifth:
            timePitch3.pitch = pitch
        case .seventh:
            timePitch4.pitch = pitch
        }
    }
    
    
    func play(note: Note){
        
        switch note {
        case .root:
            do {
                try sampler1.play()
            } catch {
                AKLog("Did not play")
            }
        case .third:
            do {
                try sampler2.play()
            } catch {
                AKLog("Did not play")
            }
        case .fifth:
            do {
                try sampler3.play()
            } catch {
                AKLog("Did not play")
            }
        case .seventh:
            do {
                try sampler4.play()
            } catch {
                AKLog("Did not play")
            }
        }
        
        
    }
    
    
    
    
    
}
