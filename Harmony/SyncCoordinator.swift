//
//  SyncCoordinator.swift
//  Harmony
//
//  Created by Riley Testut on 5/17/17.
//  Copyright © 2017 Riley Testut. All rights reserved.
//

import Foundation
import CoreData

public final class SyncCoordinator
{
    public let service: Service
    public let persistentContainer: NSPersistentContainer
    
    public let recordController: RecordController
    
    private let operationQueue: OperationQueue
    
    public init(service: Service, persistentContainer: NSPersistentContainer)
    {
        self.service = service
        self.persistentContainer = persistentContainer
        self.recordController = RecordController(persistentContainer: persistentContainer)
        
        self.operationQueue = OperationQueue()
        self.operationQueue.name = "com.rileytestut.Harmony.SyncCoordinator.operationQueue"
        self.operationQueue.qualityOfService = .utility
    }
}

public extension SyncCoordinator
{
    func start(completionHandler: @escaping (Result<Void>) -> Void)
    {
        self.recordController.start { (result) in
            if let error = result.values.first
            {
                completionHandler(.failure(SyncError(code: .databaseCorrupted(error))))
            }
            else
            {
                completionHandler(.success)
            }
        }
    }
    
    @discardableResult func sync(completionHandler: @escaping (Result<[Result<Void>]>) -> Void) -> (Foundation.Operation & ProgressReporting)
    {
        let syncRecordsOperation = SyncRecordsOperation(changeToken: UserDefaults.standard.harmonyChangeToken, service: self.service, recordController: self.recordController)
        syncRecordsOperation.resultHandler = { (result) in
            do
            {
                let (_, changeToken) = try result.value()
                UserDefaults.standard.harmonyChangeToken = changeToken
                                
                completionHandler(.success([]))
            }
            catch
            {
                completionHandler(.failure(error))
            }
        }
        self.operationQueue.addOperation(syncRecordsOperation)
        
        return syncRecordsOperation
    }
}
