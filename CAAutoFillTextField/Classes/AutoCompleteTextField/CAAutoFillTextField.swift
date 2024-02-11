//
//  CAAutoFillTextField
//  Chandan_Controls
//
//  Created by Singh, Chandan F. on 16/05/16.
//  Copyright © 2016 Chandan SIngh. All rights reserved.
//

import Foundation
import UIKit

public protocol CAAutoFillDelegate: AnyObject {
    func caAutoTextFillBeginEditing()
    func caAutoTextFillEndEditing()
    func caAutoTextCanEdit() -> Bool
}

public class CAAutoFillTextField : UIView {

    private var autoCompleteArray = [CAAutoCompleteObject]()
    private var tableCellHeight: CGFloat = 30
    
    public var dataSourceArray = [CAAutoCompleteObject]()
    public var delegate: CAAutoFillDelegate?
    
    lazy var txtField: UITextField = {
        let txtFieldObj = UITextField(frame:CGRectMake(0, 0, 0, 0))
        txtFieldObj.borderStyle = .roundedRect
        txtFieldObj.autocorrectionType = .no
        txtFieldObj.textAlignment = .left
        txtFieldObj.contentVerticalAlignment = .center
        txtFieldObj.autoresizingMask = .flexibleWidth
        txtFieldObj.returnKeyType = .done
        txtFieldObj.font = UIFont.systemFont(ofSize: 17.0)
        txtFieldObj.textColor = .black
        txtFieldObj.clipsToBounds = false
        txtFieldObj.delegate = self
        return txtFieldObj
    }()
    
    lazy var autoCompleteTableView: UITableView = {
        let autoCompleteTableViewObj = UITableView(frame: CGRectMake(0, 0, 0, 0), style:.plain)
        autoCompleteTableViewObj.isScrollEnabled = true
        autoCompleteTableViewObj.isHidden = false
        autoCompleteTableViewObj.autoresizingMask = .flexibleWidth
        autoCompleteTableViewObj.rowHeight = tableCellHeight
        autoCompleteTableViewObj.delegate = self
        autoCompleteTableViewObj.dataSource = self
        return autoCompleteTableViewObj
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.addSubview(txtField)
        self.addSubview(self.autoCompleteTableView)
        self.backgroundColor = .clear
    }

    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(txtField)
        self.addSubview(self.autoCompleteTableView)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        print("self frame", frame)
        print("txtField frame", self.txtField.frame)
        self.txtField.frame = self.frame
        self.autoCompleteTableView.frame = CGRectMake(txtField.frame.origin.x, txtField.frame.origin.y + txtField.frame.size.height, frame.size.width - 5, 0)
    }
   
    // Take string from Search Textfield and compare it with autocomplete array
    func searchAutocompleteEntriesWithSubstring(substring:String) {
        autoCompleteArray.removeAll()
        autoCompleteArray = dataSourceArray.filter { $0.objName.lowercased() == substring.lowercased()}
        self.autoCompleteTableView.isHidden = false
        
        var tableRect:CGRect
        var baseViewRect:CGRect
        if autoCompleteArray.count >= 3 {
            tableRect = CGRectMake(autoCompleteTableView.frame.origin.x,
                                   autoCompleteTableView.frame.origin.y,
                                   autoCompleteTableView.frame.size.width,
                                   tableCellHeight * 3)
            baseViewRect = CGRectMake(self.frame.origin.x, 
                                      self.frame.origin.y,
                                      self.frame.size.width,
                                      (tableCellHeight * 3) + 30)
        }

        else if autoCompleteArray.count == 2 || autoCompleteArray.count == 1 {
            tableRect = CGRectMake(autoCompleteTableView.frame.origin.x,
                                   autoCompleteTableView.frame.origin.y,
                                   autoCompleteTableView.frame.size.width,
                                   tableCellHeight * 2)
            baseViewRect = CGRectMake(self.frame.origin.x, 
                                      self.frame.origin.y,
                                      self.frame.size.width,
                                      (tableCellHeight * 2) + 30)
        }

        else {
            tableRect = CGRectMake(autoCompleteTableView.frame.origin.x,
                                   autoCompleteTableView.frame.origin.y,
                                   autoCompleteTableView.frame.size.width, 0.0)
            baseViewRect = CGRectMake(self.frame.origin.x, 
                                      self.frame.origin.y,
                                      self.frame.size.width,
                                      tableCellHeight)
        }
    
        UIView.animate(withDuration: 0.5, delay: 1.0, options: [.curveEaseInOut], animations: {
            self.autoCompleteTableView.frame = tableRect
            self.frame = baseViewRect
        }, completion: { _ in
            debugPrint("Animation finished!")
        })

        if autoCompleteArray.count == 0 {
            self.autoCompleteTableView.isHidden = true
        } else {
            self.autoCompleteTableView.isHidden = false
            self.autoCompleteTableView.reloadData()
        }
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

    public func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return autoCompleteArray.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

    public func tableView(_ tableView:UITableView, didSelectRowAt indexPath:IndexPath) {
        let object:CAAutoCompleteObject! = autoCompleteArray[indexPath.row]
        txtField.text = object.objName
        self.finishedSearching()
    }
}


extension CAAutoFillTextField: UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField:UITextField) {
        delegate?.caAutoTextFillBeginEditing()
    }

    public func textFieldDidEndEditing(_ textField:UITextField) {
        delegate?.caAutoTextFillEndEditing()
    }

    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        var didYES = false
        if let anyInput = delegate?.caAutoTextCanEdit() {
            didYES = anyInput
        }
        return didYES
    }

    public func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    public func textField(_ textField:UITextField, shouldChangeCharactersIn range:NSRange, replacementString string:String) -> Bool {
        let currentTextFieldValue: String? = txtField.text
        let substring = (currentTextFieldValue as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        self.searchAutocompleteEntriesWithSubstring(substring: substring)
        return true
    }
}
