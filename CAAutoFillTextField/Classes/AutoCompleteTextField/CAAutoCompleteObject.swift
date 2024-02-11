//
//  CAAutoCompleteObject
//  Chandan_Controls
//
//  Created by Singh, Chandan F. on 16/05/16.
//  Copyright © 2016 Chandan SIngh. All rights reserved.
//

import Foundation

class CAAutoCompleteObject {

    var objName:String!
    var objID:Int
    var isSelectable:Bool
    var isDefaultSelected:Bool

    required init(objName:String, AndID obID:Int) {
        self.objName = objName
        self.objID = obID
        self.isSelectable = true
        self.isDefaultSelected = false
    }

    func dealloc() {
        self.objName = nil
    }
}
