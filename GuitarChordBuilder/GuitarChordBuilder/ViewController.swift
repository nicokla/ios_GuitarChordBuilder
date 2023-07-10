//
//  ViewController.swift
//  GuitarChordBuilder
//
//  Created by Nicolas Klarsfeld on 5/14/18.
//  Copyright © 2018 Nicolas Klarsfeld. All rights reserved.
//

import UIKit

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }}

class Coord{
    var a:Int //ligne
    var b:Int //colonne
    init(a1:Int, b1:Int){
        a=a1
        b=b1
    }
}

enum displayType{
    case note, fret, roman
}

class Config{
    var displayTypePianoIndex:Int=0
    var displayTypeGuitareIndex:Int=0
    
    var originePiano:Int=36
    var decalageGuitare:Int=0
    
    var notesPiano:Set<Int>=Set<Int>()
    var coordGuitareAppuyees:Array<Coord> =
        [Coord(a1: 0, b1: 0),
         Coord(a1: 1, b1: 0),
         Coord(a1: 2, b1: 0),
         Coord(a1: 3, b1: 0),
         Coord(a1: 4, b1: 0),
         Coord(a1: 5, b1: 0)]

    init(){}
}

class ViewController: UIViewController {
    var colorBelow:[[UIColor]]=Array(repeating: Array(repeating: UIColor.white, count: 21), count: 6)
    let romanList=["I","IIb","II","IIIb","III","IV","Vb","V","VIb","VI","VIIb","VII"]

    let vertClair:UIColor = UIColor(red:207.0/255.0,green:1.0,blue:162.0/255.0,alpha:1.0)
    let monJaune:UIColor = UIColor(red:254.0/255.0,green:222/255,blue:109.0/255.0,alpha:1.0)
    let displayTypePiano:Array<displayType>=[.note,.roman]
    var displayTypePianoIndex:Int=0
    let displayTypeGuitare:Array<displayType>=[.fret,.note,.roman]
    var displayTypeGuitareIndex:Int=0
    let ll=[40,45,50,55,59,64]
    //var notes:Array<Int>=[0,0,0,0,0,0]
    //var buttonsTag:Array<Int>=[36,48,60,72,84,96]
    var coordGuitareAppuyees:Array<Coord> = // abs
        [Coord(a1: 0, b1: 0),
         Coord(a1: 1, b1: 0),
         Coord(a1: 2, b1: 0),
         Coord(a1: 3, b1: 0),
         Coord(a1: 4, b1: 0),
         Coord(a1: 5, b1: 0)]
    var dic=Dictionary<Int,UIButton>()
    var dic2=Dictionary<Int,Array<Coord>>()
    var originePiano:Int=36
    var decalageGuitare:Int=0
    var notesPiano=Set<Int>()
    
    func updateColorButtonPiano(){
        for ligne in 0...2{
            for colonne in 0...11{
                let c = Coord(a1: ligne, b1: colonne)
                buttonOfCoordPiano(a: c).backgroundColor=UIColor.white
            }
        }

        for note in notesPiano{
            let c=noteToCoordPiano(a: note)
            if dedansPiano(a: c){
                buttonOfCoordPiano(a: c).backgroundColor=vertClair
            }
        }
        
        for c in coordGuitareAppuyees{
            let cRel = coordGuitareAbsToRel(a: c)
            let note = coordGuitareToNote(a:cRel)
            let coordPiano = noteToCoordPiano(a: note)
            if dedansPiano(a: coordPiano) && c.b != -1 { // dedansGuitare(a: cRel)
                buttonOfCoordPiano(a: coordPiano).backgroundColor=UIColor.green
            }
        }
    }
    
    func dedansPiano(a:Coord)->Bool{
        return a.a<=2 && a.a>=0 && a.b>=0 && a.b<=11
    }
    
    func dedansGuitare(a:Coord)->Bool{
        return a.a<=5 && a.a>=0 && a.b>=0 && a.b<=11
    }
    
    func updateColorButtonGuitare(ligne:Int){
        var c = Coord(a1: ligne, b1: 0)
        for i in 0...11{
            buttonOfCoordGuitare(a: Coord(a1: ligne, b1: i)).backgroundColor =
                colorBelow[ligne][i+decalageGuitare]
        }
        c=coordGuitareAbsToRel(a: coordGuitareAppuyees[ligne])
        if(dedansGuitare(a: c)){ // button to display
            buttonOfCoordGuitare(a: c).backgroundColor=UIColor.green
        }
    }
    
    func updateColorButtonGuitareAll(){
        for i in 0...5{
            updateColorButtonGuitare(ligne:i)
        }
    }
    
    
    func coordGuitareRelToAbs(a:Coord) -> Coord{
        return Coord(a1: a.a, b1: a.b+decalageGuitare)
    }
    func coordGuitareAbsToRel(a:Coord) -> Coord{
        return Coord(a1: a.a, b1: a.b-decalageGuitare)
    }

    // all following use relative guitare coord (same for piano coord)
    func noteToCoordPiano(a:Int) -> Coord{
        let b=a-originePiano
        return Coord(a1: b/12, b1: b%12)
    }
    func noteToCoordGuitare(a:Int)->Array<Coord>{
        var l:Array<Coord>=[]
        for x in dic2[a]!{
            let r=x.b - decalageGuitare
            if r >= 0 && r <= 20{
                l += [Coord(a1: x.a, b1: r)]
            }
        }
        return l
    }
    func coordPianoToNote(a:Coord)->Int{
        return originePiano + 12*a.a + a.b
    }
    func coordGuitareToNote(a:Coord)->Int{
        return ll[a.a]+a.b+decalageGuitare
    }
    
    func coordGuitareToTag(a:Coord)->Int{
        return 36 + a.a*12 + a.b
    }
    func coordPianoToTag(a:Coord)->Int{
        return a.a*12 + a.b
    }
    func tagToCoordGuitare(a:Int)->Coord{
        return Coord(a1: a/12 - 3, b1: a%12)
    }
    func tagToCoordPiano(a:Int)->Coord{
        return  Coord(a1: a/12, b1: a%12)
    }

    func buttonOfCoordPiano(a:Coord)->UIButton{
        let tag=coordPianoToTag(a: a)
        return dic[tag]!
    }
    func buttonOfCoordGuitare(a:Coord)->UIButton{
        let tag=coordGuitareToTag(a: a)
        return dic[tag]!
    }
    
    func lookForButton(_ v: UIView) {
        if v is UIButton {
            //print(vv) // just testing: do your real stuff here
            let w = v as! UIButton
            w.layer.cornerRadius = 5
            w.layer.borderWidth = 1
            w.layer.borderColor = UIColor.black.cgColor
            w.isUserInteractionEnabled=true
            dic[w.tag]=w
            if(w.tag>=0){//<=107
                w.addTarget(self,action: #selector(outButton),for: .touchUpInside)
                w.addTarget(self,action: #selector(helloButton),for: .touchDown)
            }else if w.tag == -4 {
                w.addTarget(self,action: #selector(playButtonActionOut),for: .touchUpInside)
                w.addTarget(self,action: #selector(playButtonAction),for: .touchDown)
                w.setBackgroundColor(color: monJaune, forState: UIControlState.normal)
            }
            if(w.tag<0){
                w.setBackgroundColor(color: UIColor.yellow, forState: UIControlState.highlighted)
            }
            
            
        } else {
            let subs = v.subviews
            //if subs.count != 0 {
            for vv in subs{
                lookForButton(vv)
            }
            //}
        }
    }
    
    @IBAction func leftGuitare(_ sender: Any) {
        if(decalageGuitare >= 1){
            decalageGuitare-=1
            updateNamesGuitare()
            updateColorButtonGuitareAll()
        }
    }
    @IBAction func rightGuitare(_ sender: Any) {
        if(decalageGuitare <= 8){
            decalageGuitare+=1
            updateNamesGuitare()
            updateColorButtonGuitareAll()
        }
    }
    @IBAction func leftPiano(_ sender: Any) {
        if originePiano >= 1{
            originePiano-=1
            updateNamesPiano()
            updateColorButtonPiano()
            if(displayTypeGuitare[displayTypeGuitareIndex] == .roman){
                updateNamesGuitare()
            }
        }
    }
    @IBAction func rightPiano(_ sender: Any) {
        if(originePiano<=91){
            originePiano+=1
            updateNamesPiano()
            updateColorButtonPiano()
            if(displayTypeGuitare[displayTypeGuitareIndex] == .roman){
                updateNamesGuitare()
            }
        }
    }
    
    @IBAction func upPiano(_ sender: Any) {
        if(originePiano<=80){
            originePiano+=12
            updateNamesPiano()
            updateColorButtonPiano()
        }
    }
    
    @IBAction func downPiano(_ sender: Any) {
        if(originePiano>=12){
            originePiano-=12
            updateNamesPiano()
            updateColorButtonPiano()
        }
    }
    
    //MARK: - Actions and Selectors
    @IBAction func playButtonAction(sender: UIButton) {
        var l:Array<Int>=[]
        for i in 0...5 {
            let c=coordGuitareAppuyees[i]
            if(c.b>=0){
                l.append(
                    coordGuitareToNote(a: coordGuitareAbsToRel(a: c)))
            }
        }
        globalVar.audioUnit.playChord(n:UInt32(0), v:l, vol:100)
    }
    
    @IBAction func playButtonActionOut(sender:UIButton) {
        var l:Array<Int>=[]
        for i in 0...5 {
            l.append(
                coordGuitareToNote(a: coordGuitareAbsToRel(a: coordGuitareAppuyees[i])))
        }
        globalVar.audioUnit.stopChord(n:UInt32(0), v:l)
    }

    
    @IBAction func helloButton(sender:UIButton){
        let n:Int = (Int)(sender.tag)
        let colonne = n % 12
        var ligne = n / 12

        if(ligne<=2){ // piano
            let coordRel = Coord(a1: ligne,b1: colonne)
            let note=coordPianoToNote(a: coordRel)

            globalVar.audioUnit.playPatch1On(n:UInt32(note), vol: globalVar.volume)

            if(notesPiano.contains(note)){
                notesPiano.remove(note)
                let l=noteToCoordGuitare(a: note)
                for c in l{
                    let cAbs=coordGuitareRelToAbs(a: c)
                    colorBelow[cAbs.a][cAbs.b]=UIColor.white
                }
            }else{
                notesPiano.insert(note)
                let l=noteToCoordGuitare(a: note)
                for c in l{
                    let cAbs=coordGuitareRelToAbs(a: c)
                    colorBelow[cAbs.a][cAbs.b]=vertClair
                }
            }
            updateColorButtonGuitareAll()
            updateColorButtonPiano()

        }else{ // guitare
            ligne=ligne-3
            let coordRel = Coord(a1: ligne,b1: colonne)
            //let oldNote = coordGuitareToNote(a:coordGuitareAppuyees[ligne])

            if coordGuitareAppuyees[ligne].b == coordGuitareRelToAbs(a: coordRel).b{
                coordGuitareAppuyees[ligne].b = -1
            }else{
                coordGuitareAppuyees[ligne] = coordGuitareRelToAbs(a: coordRel)
            }
            updateColorButtonGuitare(ligne: ligne)
            
            updateColorButtonPiano()

            globalVar.audioUnit.playPatch1On(n:UInt32(coordGuitareToNote(a: coordRel)), vol: globalVar.volume)
        }
    }
    
    @IBAction func outButton(sender:UIButton){
        globalVar.audioUnit.playPatch1Off()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        lookForButton(self.view)
        
        for note in 0...127{//40...84
            dic2[note] = []
        }
        for i in 0...5{
            for j in 0...20{
                dic2[coordGuitareToNote(a: Coord(a1: i,b1: j))]! +=
                    [Coord(a1: i,b1: j)]
            }
        }
        
        updateColorButtonGuitareAll()
        updateColorButtonPiano()

        updateNamesPiano()
        updateNamesGuitare()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    //let romanList=["I","IIb","II","IIIb","III","IV","Vb","V","VIb","VI","VIIb","VII"]
    func updateNamesPiano(){
        let type=displayTypePiano[displayTypePianoIndex]
        switch(type){
        case .note:
            for tag in 0...35{
                let c = tagToCoordPiano(a: tag)
                let n = coordPianoToNote(a: c)
                let b = dic[tag]
                b?.setTitle(globalVar.notesNames[n], for: .normal)
            }
        case .fret:
            print(1) // do nothing
        case .roman:
            for tag in 0...35{
                let c = tagToCoordPiano(a: tag)
                let n = coordPianoToNote(a: c)
                let b = dic[tag]
                b?.setTitle(romanList[(1200+n-originePiano)%12], for: .normal)
            }
        }

    }
    func updateNamesGuitare(){
        let type=displayTypeGuitare[displayTypeGuitareIndex]
        switch(type){
        case .note:
            for tag in 36...107{
                let c = tagToCoordGuitare(a: tag)
                //let n = coordGuitareToNote(a: c)
                let b = dic[tag]
                let n = coordGuitareToNote(a: c)
                b?.setTitle(globalVar.notesNames[n], for: .normal)
            }
        case .fret:
            for tag in 36...107{
                let c = tagToCoordGuitare(a: tag)
                //let n = coordGuitareToNote(a: c)
                let b = dic[tag]
                let c2 = coordGuitareRelToAbs(a: c)
                b?.setTitle(String(c2.b), for: .normal)
            }
        case .roman:
            for tag in 36...107{
                let c = tagToCoordGuitare(a: tag)
                //let n = coordGuitareToNote(a: c)
                let b = dic[tag]
                let n = coordGuitareToNote(a: c)
                b?.setTitle(romanList[(1200+n-originePiano)%12], for: .normal)
            }
        }
    }
    /*
     let displayTypePiano:Array<displayType>=[.note,.roman]
     var displayTypePianoIndex:Int=0
     let displayTypeGuitare:Array<displayType>=[.fret,.note,.roman]
     var displayTypeGuitareIndex:Int=0
     */
    @IBAction func nameGuitare(_ sender: Any) {
        displayTypeGuitareIndex += 1
        displayTypeGuitareIndex %= 3
        updateNamesGuitare()
    }
    @IBAction func namePiano(_ sender: Any) {
        displayTypePianoIndex += 1
        displayTypePianoIndex %= 2
        updateNamesPiano()
    }
    
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue){
        
    }

    
}

