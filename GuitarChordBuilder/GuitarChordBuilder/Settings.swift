import UIKit

class Settings: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var myLabel = UILabel()
    
    @IBOutlet weak var instru1: UIPickerView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    //MARK: Properties
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instru1.dataSource = self
        instru1.delegate = self
        
        instru1.selectRow(globalVar.instru1_n, inComponent:0, animated:true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == instru1 {
            return globalVar.instruments.count
        }
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == instru1 {
            return globalVar.instruments[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == instru1 {
            globalVar.instru1_n=row
            globalVar.audioUnit.patch1=UInt32(row)
            globalVar.audioUnit =
                AudioUnitMIDISynth(instru1_n: globalVar.instru1_n,
                                   instru2_n: globalVar.instru1_n)
            print("\(globalVar.audioUnit.patch1)")
            self.view.endEditing(false)
        } 
    }
    
}

