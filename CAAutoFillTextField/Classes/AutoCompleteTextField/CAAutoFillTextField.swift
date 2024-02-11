//
//  CAAutoFillTextField
//  Chandan_Controls
//
//  Created by Singh, Chandan F. on 16/05/16.
//  Copyright © 2016 Chandan SIngh. All rights reserved.
//

import Foundation
import UIKit

protocol CAAutoFillDelegate {
    func CAAutoTextFillBeginEditing(textField:CAAutoFillTextField!)
    func CAAutoTextFillEndEditing(textField:CAAutoFillTextField!)
    func CAAutoTextFillWantsToEdit(textField:CAAutoFillTextField!) -> Bool
}

class CAAutoFillTextField : UIView {

    private var txtField:UITextField
    private var autoCompleteTableView:UITableView
    
    private var dataSourceArray = [CAAutoCompleteObject]()
    private var autoCompleteArray = [CAAutoCompleteObject]()
    private var tableHeight: CGFloat
    
    private var delegate:CAAutoFillDelegate?
    
    /*
    init(aDecoder:NSCoder) {
        let frame:CGRect = self.frame
        tableHeight = 30.0

        txtField = UITextField(frame:CGRectMake(0, 0, frame.size.width, 30))
        txtField.borderStyle = .roundedRect
        txtField.autocorrectionType = .no
        txtField.textAlignment = .left
        txtField.contentVerticalAlignment = .center
        txtField.autoresizingMask = .flexibleWidth
        txtField.returnKeyType = .done
        txtField.font = UIFont.systemFont(ofSize: 17.0)
        txtField.textColor = .black
        txtField.clipsToBounds = false
        txtField.delegate = self
        self.addSubview(txtField)

        // Autocomplete Table
        self.autoCompleteTableView =
        UITableView(frame:CGRectMake(3, txtField.frame.origin.y + txtField.frame.size.height, frame.size.width - 5, tableHeight), style:.plain)
        self.autoCompleteTableView.delegate = self
        self.autoCompleteTableView.dataSource = self
        self.autoCompleteTableView.isScrollEnabled = true
        self.autoCompleteTableView.isHidden = false
        self.autoCompleteTableView.autoresizingMask = .flexibleWidth
        self.autoCompleteTableView.rowHeight = tableHeight
        self.addSubview(self.autoCompleteTableView)

        
        self.backgroundColor = .clear
    }*/

    required override init(frame:CGRect) {
        
        tableHeight = 30.0

        txtField = UITextField(frame:CGRectMake(0, 0, frame.size.width, 30))
        txtField.borderStyle = .roundedRect
        txtField.autocorrectionType = .no
        txtField.textAlignment = .left
        txtField.contentVerticalAlignment = .center
        txtField.returnKeyType = .done
        txtField.font = UIFont.systemFont(ofSize: 17.0)
        txtField.textColor = .black
        txtField.clipsToBounds = false
        
        // Autocomplete Table
        self.autoCompleteTableView =
        UITableView(frame:CGRectMake(3, txtField.frame.origin.y + txtField.frame.size.height, frame.size.width - 5, tableHeight), style:.plain)
       
        self.autoCompleteTableView.isScrollEnabled = true
        self.autoCompleteTableView.isHidden = false
        self.autoCompleteTableView.rowHeight = tableHeight
        
        super.init(frame: frame)
        
        self.autoCompleteTableView.delegate = self
        self.autoCompleteTableView.dataSource = self
        
        txtField.delegate = self
        self.addSubview(txtField)
        self.addSubview(self.autoCompleteTableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Take string from Search Textfield and compare it with autocomplete array
    func searchAutocompleteEntriesWithSubstring(substring:String) {

        autoCompleteArray.removeAll()
        autoCompleteArray = dataSourceArray.filter { $0.objName.lowercased() == substring.lowercased()}
        self.autoCompleteTableView.isHidden = false
        self.autoCompleteTableView.reloadData()
    }

    func finishedSearching() {
        self.resignFirstResponder()
        autoCompleteArray.removeAll()
        self.autoCompleteTableView.reloadData()
    }

}

extension CAAutoFillTextField: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: UITableViewDelegate methods
    func numberOfSectionsInTableView(tableView:UITableView!) -> Int {
        return 1
    }

    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {

        // Resize auto complete table based on how many elements will be displayed in the table

        var tableRect:CGRect
        var baseViewRect:CGRect
        var returnCount:Int = 0

        if autoCompleteArray.count >= 3 {
            tableRect = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, tableHeight * 3)
            baseViewRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, (tableHeight * 3) + 30)
            returnCount = autoCompleteArray.count
        }

        else if autoCompleteArray.count == 2 || autoCompleteArray.count == 1 {
            tableRect = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, tableHeight * 2)
            baseViewRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, (tableHeight * 2) + 30)
            returnCount = autoCompleteArray.count
        }

        else {
            tableRect = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, 0.0)
            baseViewRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, tableHeight)
            returnCount = autoCompleteArray.count
        }
    
        UIView.animate(withDuration: 0.5, delay: 1.0, options: [.curveEaseInOut], animations: {
            self.autoCompleteTableView.frame = tableRect
            self.frame = baseViewRect
        }, completion: { _ in
            debugPrint("Animation finished!")
        })
        
        

        self.autoCompleteTableView.isHidden = false
        if returnCount == 0 {
            self.autoCompleteTableView.isHidden = true
        }
        return returnCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell! = nil
        let AutoCompleteRowIdentifier:String! = "AutoCompleteRowIdentifier"
        cell = tableView.dequeueReusableCell(withIdentifier: AutoCompleteRowIdentifier)
        if cell == nil {
            cell = UITableViewCell(style:.default, reuseIdentifier:AutoCompleteRowIdentifier)
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
        }
        let object:CAAutoCompleteObject! = autoCompleteArray[indexPath.row]
        cell.textLabel?.text = object.objName
        return cell
    }

    func tableView(_ tableView:UITableView, didSelectRowAt indexPath:IndexPath) {
        let object:CAAutoCompleteObject! = autoCompleteArray[indexPath.row]
        txtField.text = object.objName
        self.finishedSearching()
    }
}


extension CAAutoFillTextField: UITextFieldDelegate{
    
    
    
    func textFieldDidBeginEditing(_ textField:UITextField) {
        delegate?.CAAutoTextFillBeginEditing(textField: self)
    }

    func textFieldDidEndEditing(_ textField:UITextField) {
        delegate?.CAAutoTextFillEndEditing(textField: self)
    }

    func textFieldShouldBeginEditing(_ textField:UITextField) -> Bool {
        var didYES:Bool = false
        if let anyInput = delegate?.CAAutoTextFillWantsToEdit(textField: self) {
            didYES = anyInput
        }
        return didYES
    }

    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

//    private func textField(_ textField:UITextField, shouldChangeCharactersIn range:Range, replacementString string:String) -> Bool {
//        var substring: String? = txtField.text
//        substring = substring?.replacingCharacters(in: range, with: string)
//
//        substring = substring?.stringByReplacingCharactersInRange(range, withString:string)
//        self.searchAutocompleteEntriesWithSubstring(substring)
//
//        return true
//    }
}
