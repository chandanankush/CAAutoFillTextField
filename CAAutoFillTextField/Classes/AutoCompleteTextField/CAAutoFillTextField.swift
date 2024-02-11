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
    private var latestTableHeight: CGFloat = 5.0
    
    lazy var txtField: UITextField = {
        let txtFieldObj = UITextField(frame: CGRectMake(0, 0, 3, 22))
        txtFieldObj.borderStyle = .roundedRect
        txtFieldObj.autocorrectionType = .no
        txtFieldObj.textAlignment = .left
        txtFieldObj.contentVerticalAlignment = .center
        txtFieldObj.autoresizingMask = .flexibleWidth
        txtFieldObj.returnKeyType = .done
        txtFieldObj.font = UIFont.systemFont(ofSize: 17.0)
        txtFieldObj.textColor = .black
        txtFieldObj.delegate = self
        return txtFieldObj
    }()
    
    lazy var autoCompleteTableView: UITableView = {
        let autoCompleteTableViewObj = UITableView(frame: CGRectMake(0, 0, 3, latestTableHeight), style:.plain)
        autoCompleteTableViewObj.isScrollEnabled = true
        autoCompleteTableViewObj.isHidden = true
        autoCompleteTableViewObj.autoresizingMask = .flexibleWidth
        autoCompleteTableViewObj.estimatedRowHeight = tableCellHeight
        autoCompleteTableViewObj.delegate = self
        autoCompleteTableViewObj.dataSource = self
        return autoCompleteTableViewObj
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.addSubview(txtField)
        self.addSubview(self.autoCompleteTableView)
    }

    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(txtField)
        self.addSubview(self.autoCompleteTableView)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.txtField.frame = self.bounds
        self.autoCompleteTableView.frame = CGRectMake(txtField.frame.origin.x + 2, txtField.frame.origin.y + txtField.frame.size.height, frame.size.width - 2, latestTableHeight)
        
        debugPrint("self frame", frame)
        debugPrint("txtField frame", self.txtField.frame)
        debugPrint("autoCompleteTableView frame", self.autoCompleteTableView.frame)
    }
    
    func updateTableViewFrame() {
        var tableRect: CGRect
        var baseViewRect: CGRect
        if autoCompleteArray.count >= 3 {
            latestTableHeight = (tableCellHeight * 3) + 30
            tableRect = CGRectMake(autoCompleteTableView.frame.origin.x,
                                   autoCompleteTableView.frame.origin.y,
                                   autoCompleteTableView.frame.size.width,
                                   tableCellHeight * 3)
            baseViewRect = CGRectMake(self.frame.origin.x, 
                                      self.frame.origin.y,
                                      self.frame.size.width,
                                      latestTableHeight)
        }

        else if autoCompleteArray.count == 2 || autoCompleteArray.count == 1 {
            latestTableHeight = (tableCellHeight * 2)
            tableRect = CGRectMake(autoCompleteTableView.frame.origin.x,
                                   autoCompleteTableView.frame.origin.y,
                                   autoCompleteTableView.frame.size.width,
                                   latestTableHeight)
            baseViewRect = CGRectMake(self.frame.origin.x,
                                      self.frame.origin.y,
                                      self.frame.size.width,
                                      (tableCellHeight * 2) + 30)
        }

        else {
            latestTableHeight = 5
            tableRect = CGRectMake(autoCompleteTableView.frame.origin.x,
                                   autoCompleteTableView.frame.origin.y,
                                   autoCompleteTableView.frame.size.width, latestTableHeight)
            baseViewRect = CGRectMake(self.frame.origin.x,
                                      self.frame.origin.y,
                                      self.frame.size.width,
                                      40)
        }
    
        UIView.animate(withDuration: 0.5, delay: 0.5, options: [.curveEaseInOut], animations: {
           // self.frame = baseViewRect
            self.autoCompleteTableView.frame = tableRect
        }, completion: { _ in
            //debugPrint("Animation finished!")
        })

        if autoCompleteArray.count == 0 {
            self.autoCompleteTableView.isHidden = true
        } else {
            self.autoCompleteTableView.isHidden = false
        }
        self.autoCompleteTableView.reloadData()
    }
   
    // Take string from Search Textfield and compare it with autocomplete array
    func searchAutocompleteEntriesWithSubstring(substring:String) {
        autoCompleteArray.removeAll()
        let filteredData = dataSourceArray.filter { $0.objName.lowercased().contains(substring.lowercased())}
        autoCompleteArray.append(contentsOf: filteredData)
        updateTableViewFrame()
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
        let object:CAAutoCompleteObject = autoCompleteArray[indexPath.row]
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
