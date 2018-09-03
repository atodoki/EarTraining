//
//  Conductor.swift
//  EarTraining
//
//  Created by Ariel Todoki on 4/13/18.
//  Copyright © 2018 Ariel Todoki. All rights reserved.
//

import AudioKit

/**
 Instrument options.
 ````
 case piano
 case clarinet
 case french_horn
 case pizz_strings
 ````
 */
enum Instrument {
    /// Uses the piano sound .wav file.
    case piano
    
    /// Uses the clarinet sound .wav file.
    case clarinet
    
    /// Uses the french horn sound .wav file.
    case french_horn
    
    /// Uses the pizzicato string sound .wav file.
    case pizz_strings
}

/**
 Note options
 ````
 case root
 case third
 case fifth
 case seventh
 ````
 */
enum Note {
    /// Note that is the root of the chord when playing a chord, or the notes when playing sequential notes.
    case root
    
    /// Note that is the third of the chord.
    case third
    
    /// Note that is the fifth of the chord.
    case fifth
    
    /// Note that is the seventh of the chord.
    case seventh
}

/// This is a class created to handle the AudioKit tools used in the app.
class Conductor {
    
    /// Static instance of the Conductor class.
    static let sharedInstance = Conductor()
    
    /// AKAppleSampler used for the root of the chord or notes played sequentially.
    var sampler1 = AKAppleSampler()
    /// AKAppleSampler used for the third of the chord.
    var sampler2 = AKAppleSampler()
    /// AKAppleSampler used for the fifth of the chord.
    var sampler3 = AKAppleSampler()
    /// AKAppleSampler used for the seventh of the chord.
    var sampler4 = AKAppleSampler()
    
    /// AKTimePitch for sampler1.
    var timePitch1: AKTimePitch!
    /// AKTimePitch for sampler2.
    var timePitch2: AKTimePitch!
    /// AKTimePitch for sampler3.
    var timePitch3: AKTimePitch!
    /// AKTimePitch for sampler4.
    var timePitch4: AKTimePitch!
    
    /// AKMicrophone for tracker.
    var mic: AKMicrophone!
    /// AKFrequencyTracker to get the frequency sung into the microphone.
    var tracker: AKFrequencyTracker!
    /// AKBooster for the output to be silent when taking input from the microphone.
    var silence: AKBooster!
    
    /// AKMixer for all of the samplers to be able to play at the same time.
    var mixer: AKMixer!
    
    /**
     Initializes the samplers to load the piano wav file, set the timePitch rate to 2.0, initialize the microphone, tracker, silence, and mixer, set the mixer volume to 4, set the AudioKit output to mixer, and calls `startAudioEngine()`.
     */
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
            mixer.volume = 8
            
            AudioKit.output = mixer
        }catch{
            AKLog("Could not find file.")
        }
        
        startAudioEngine()
    }
    
    /**
     Calls `AudioKit.start()`.
     - Note: Should only be used in the `init()` function.
     */
    internal func startAudioEngine() {
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit did not start!")
        }
        
    }
    
    /**
     Calls `AudioKit.stop()`.
     - Note: Only use when exiting the application. Do not continuously start and stop AudioKit.
     */
    internal func stopAudioEngine() {
        do {
            try AudioKit.stop()
        } catch {
            AKLog("Something went wrong.")
        }
        
    }
    
    /**
     Enables audio input.
     */
    func setMic(){
        AKSettings.audioInputEnabled = true
       
    }
    
    /**
     Disables audio input.
     */
    func closeMic(){
        AKSettings.audioInputEnabled = false
    }
    
    /**
     Gets the frequency sung into the microphone.
     - Returns: A ***Double*** that is the frequency.
     */
    func listenFreq() -> Double{
        return tracker.frequency
    }
    
    /**
    Returns the amplitude that is sung into the microphone.
     - Returns: A ***Double*** that is the amplitude.
    */
    func listenAmp() -> Double{
        return tracker.amplitude
    }
    
    /**
     Call this function to change the instrument sound.
     - Parameters:
        - instr: The instrument you want to change to. Use the Instrument enumerated type.
    */
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
    
    /**
     Call this function to change the pitch of a note.
     - Parameters:
        - pitch: use a Double to specify the pitch you want to change the note to.
        - noteType: Use one of the Note enumerated values such as .root, .third, .fifth, or .seventh.
     */
    func changePitch(pitch: Double, noteType: Note){
        switch noteType {
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
    
    /**
     Plays the note passed into the function.
     - Parameters:
        - noteType: Use on of the Note enumerated values such as .root, .third, .fifth, or .seventh.
     */
    func play(noteType: Note){
        
        switch noteType {
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
