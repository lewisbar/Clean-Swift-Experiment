//
//  OverviewInteractor.swift
//  Clean Swift Experiment
//
//  Created by Lennart Wisbar on 22.01.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol OverviewBusinessLogic
{
    func doSomething(request: Overview.Something.Request)
}

protocol OverviewDataStore
{
    var name: String { get set }
}

class OverviewInteractor: OverviewBusinessLogic, OverviewDataStore
{
    var name = ""
    
    var presenter: OverviewPresentationLogic?
    var worker: OverviewWorker?
    //var name: String = ""
    
    // MARK: Do something
    
    func doSomething(request: Overview.Something.Request)
    {
        worker = OverviewWorker()
        worker?.doSomeWork()
        
        let response = Overview.Something.Response()
        presenter?.presentSomething(response: response)
    }
}