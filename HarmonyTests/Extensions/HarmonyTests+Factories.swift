//
//  HarmonyTests+Factories.swift
//  HarmonyTests
//
//  Created by Riley Testut on 1/8/18.
//  Copyright © 2018 Riley Testut. All rights reserved.
//

import Foundation
import CoreData

@testable import Harmony

extension NSManagedObjectContext
{
    static var harmonyTestsFactoryDefault: NSManagedObjectContext!
}

extension Professor
{
    class func make(name: String = "Michael Shindler", identifier: String = UUID().uuidString, context: NSManagedObjectContext? = .harmonyTestsFactoryDefault) -> Professor
    {
        let professor = Professor(entity: Professor.entity(), insertInto: context)
        professor.name = name
        professor.identifier = identifier
        return professor
    }
}

extension Course
{
    class func make(name: String = "Introduction to Computer Systems", identifier: String = UUID().uuidString, context: NSManagedObjectContext? = .harmonyTestsFactoryDefault) -> Course
    {
        let professor = Professor.make(context: context)
        
        let course = Course(entity: Course.entity(), insertInto: context)
        course.name = name
        course.identifier = identifier
        course.professor = professor
        return course
    }
}

extension Homework
{
    class func make(name: String = "Project 1: Manipulating Bits", identifier: String = UUID().uuidString, dueDate: Date = Date(), fileURL: URL = Bundle(for: HarmonyTestCase.self).url(forResource: "Project1", withExtension: "pdf")!, context: NSManagedObjectContext? = .harmonyTestsFactoryDefault) -> Homework
    {
        let course = Course.make(context: context)
        
        let homework = Homework(entity: Homework.entity(), insertInto: context)
        homework.name = name
        homework.identifier = identifier
        homework.dueDate = dueDate
        homework.fileURL = fileURL
        homework.course = course
        return homework
    }
}