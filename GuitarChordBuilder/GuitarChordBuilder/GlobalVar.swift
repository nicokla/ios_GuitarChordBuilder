
class GlobalVar {
    let instruments=["Acoustic Grand Piano", "Bright Acoustic Piano", "Electric Grand Piano",
                     "Honky-tonk Piano", "Electric Piano 1", "Electric Piano 2", "Harpsichord", "Clavi", "Celesta", "Glockenspiel",
                     "Music Box", "Vibraphone", "Marimba", "Xylophone", "Tubular Bells", "Dulcimer", "Drawbar Organ", "Percussive Organ", "Rock Organ", "Church Organ",
                     "Reed Organ", "Accordion", "Harmonica", "Tango Accordion", "Acoustic Guitar (nylon)", "Acoustic Guitar (steel)",
                     "Electric Guitar (jazz)", "Electric Guitar (clean)", "Electric Guitar (muted)", "Overdriven Guitar",
                     "Distortion Guitar", "Guitar harmonics", "Acoustic Bass", "Electric Bass (finger)",
                     "Electric Bass (pick)", "Fretless Bass", "Slap Bass 1", "Slap Bass 2", "Synth Bass 1", "Synth Bass 2", "Violin",
                     "Viola", "Cello", "Contrabass", "Tremolo Strings", "Pizzicato Strings", "Orchestral Harp", "Timpani", "String Ensemble 1", "String Ensemble 2",
                     "SynthStrings 1", "SynthStrings 2", "Choir Aahs", "Voice Oohs", "Synth Voice", "Orchestra Hit",
                     "Trumpet", "Trombone", "Tuba", "Muted Trumpet", "French Horn", "Brass Section", "SynthBrass 1", "SynthBrass 2",
                     "Soprano Sax", "Alto Sax", "Tenor Sax", "Baritone Sax", "Oboe", "English Horn", "Bassoon", "Clarinet", "Piccolo", "Flute", "Recorder", "Pan Flute",
                     "Blown Bottle", "Shakuhachi", "Whistle", "Ocarina", "Lead 1 (square)", "Lead 2 (sawtooth)",
                     "Lead 3 (calliope)", "Lead 4 (chiff)", "Lead 5 (charang)", "Lead 6 (voice)", "Lead 7 (fifths)", "Lead 8 (bass + lead)", "Pad 1 (new age)", "Pad 2 (warm)",
                     "Pad 3 (polysynth)", "Pad 4 (choir)", "Pad 5 (bowed)", "Pad 6 (metallic)", "Pad 7 (halo)", "Pad 8 (sweep)",
                     "FX 1 (rain)", "FX 2 (soundtrack)", "FX 3 (crystal)", "FX 4 (atmosphere)", "FX 5 (brightness)", "FX 6 (goblins)", "FX 7 (echoes)", "FX 8 (sci-fi)",
                     "Sitar", "Banjo", "Shamisen", "Koto", "Kalimba", "Bag pipe", "Fiddle", "Shanai", "Tinkle Bell", "Agogo", "Steel Drums", "Woodblock", "Taiko Drum",
                     "Melodic Tom", "Synth Drum", "Reverse Cymbal", "Guitar Fret Noise", "Breath Noise", "Seashore", "Bird Tweet", "Telephone Ring", "Helicopter",
                     "Applause", "Gunshot"]
    
    let notesNames=["C-1","C#-1","D-1","Eb-1","E-1","F-1","F#-1","G-1","Ab-1","A-1","Bb-1","B-1",
               "C0","C#0","D0","Eb0","E0","F0","F#0","G0","Ab0","A0","Bb0","B0",
               "C1","C#1","D1","Eb1","E1","F1","F#1","G1","Ab1","A1","Bb1","B1",
               "C2","C#2","D2","Eb2","E2","F2","F#2","G2","Ab2","A2","Bb2","B2",
               "C3","C#3","D3","Eb3","E3","F3","F#3","G3","Ab3","A3","Bb3","B3",
               "C4","C#4","D4","Eb4","E4","F4","F#4","G4","Ab4","A4","Bb4","B4",
               "C5","C#5","D5","Eb5","E5","F5","F#5","G5","Ab5","A5","Bb5","B5",
               "C6","C#6","D6","Eb6","E6","F6","F#6","G6","Ab6","A6","Bb6","B6",
               "C7","C#7","D7","Eb7","E7","F7","F#7","G7","Ab7","A7","Bb7","B7",
               "C8","C#8","D8","Eb8","E8","F8","F#8","G8","Ab8","A8","Bb8","B8",
               "C9","C#9","D9","Eb9","E9","F9","F#9","G9"]
    

    let scales=["Major","Minor","Harmonic","Dorian","Phrygian","Phrygian major"]
    
    var instru1_n:Int
    var instru2_n:Int
    var scale_n:Int
    var volume:Int
    var arpeggio:Bool
    var audioUnit: AudioUnitMIDISynth!
    var sequence: SynthSequence!
    
    let vMaj=[0,2,4,5,7,9,11]
    let vMin=[0,2,3,5,7,8,10]
    let vMinH=[0,2,3,5,7,8,11]
    let vMinD=[0,2,3,5,7,9,10]
    let vMinP=[0,1,3,5,7,8,10]
    let vMajP=[0,1,4,5,7,8,10]
    let vAll:Array<Array<Int>>
    var vCurrent:Array<Int>=[]
    var origine=48

    init() {
        instru1_n=24 // Guitar
        instru2_n=24 // Guitar
        scale_n=0
        audioUnit =
            AudioUnitMIDISynth(instru1_n: instru1_n,
                               instru2_n: instru2_n)
        sequence = SynthSequence()
        volume=100
        vAll=[vMaj,vMin,vMinH,vMinD,vMinP,vMajP]
        vCurrent=vAll[0]
        arpeggio=true
    }
}

var globalVar = GlobalVar()



