//Copyright (c) 2012 The Board of Trustees of The University of Alabama
//All rights reserved.
//    
//Redistribution and use in source and binary forms, with or without
//modification, are permitted provided that the following conditions
//are met:
//
//1. Redistributions of source code must retain the above copyright
//notice, this list of conditions and the following disclaimer.
//2. Redistributions in binary form must reproduce the above copyright
//notice, this list of conditions and the following disclaimer in the
//documentation and/or other materials provided with the distribution.
//3. Neither the name of the University nor the names of the contributors
//may be used to endorse or promote products derived from this software
//without specific prior written permission.
//
//THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
//"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
//LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
//FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
//THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
//INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
//HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
//STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
//OF THE POSSIBILITY OF SUCH DAMAGE.

import Foundation

enum DataSources {
    case TestData
    case Webservice
    case LocalDB
    case None
}


//MARK: Protocol
@objc protocol DepotInterface{
    func getString() -> String
    func getAsyncString(name: String, response: ((String) -> Void))
}

//MARK: Class
private let _sharedDepot = DepotSingleton()

class DepotSingleton {
    //Singleton Access
    class var sharedDepot: DepotSingleton {
        return _sharedDepot
    }
    
    //Variables
    private var dataSourceType: DataSources = DataSources.None
    private var dataSource: DepotInterface?
    
    //Init and Init Helpers
    private init() {
        self.dataSource = dataSourceForType(self.dataSourceType)
    }
    
    //
    func dataSourceForType(source: DataSources) -> DepotInterface?{
        switch source {
        case DataSources.TestData:
            return TestData.sharedInstance
        case DataSources.LocalDB:
            return LocalDBData.sharedInstance
        case DataSources.Webservice:
            return WebserviceData.sharedInstance
        default:
            return nil
        }
    }
    
    func setNewDataSource(source: DataSources) {
        self.dataSource = dataSourceForType(source)
    }
    
    //MARK: Molecules
    func getString() -> String? {
        return self.dataSource?.getString()
    }
    
    func getAsyncString(name: String, response: ((String) -> Void)) {
        return self.dataSource!.getAsyncString(name, response: response)
    }
}