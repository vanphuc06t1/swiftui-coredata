//
//  StudentDataManager.swift
//  SwiftUI-CoreData
//
//  Created by Phuc Bui  on 9/24/21.
//

import Foundation
import CoreData

/// Class Base
///
class CoreDataManager {
    
    // MARK: - Properties
    
    private let modelName: String
    private let writeContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    
    lazy var mainContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    public lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        }
        return container
    }()

    // MARK: - Initializers
    
    init(modelName: String) {
        self.modelName = modelName
        self.writeContext.persistentStoreCoordinator = storeContainer.persistentStoreCoordinator
    }
    
    // MARK: - Public methods
    
    func saveContext () {
        guard mainContext.hasChanges else { return }
        
        do {
            try mainContext.save()
        } catch let nserror as NSError {
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
      
    func newDerivedContext() -> NSManagedObjectContext {
        let context = self.storeContainer.newBackgroundContext()
        return context
    }
    
}

//MARK: - StudentDataServiceProtocol
protocol StudentDataServiceProtocol : class {
    
    var studentsFetchRequest: NSFetchRequest<Student>  { get }
    var context: NSManagedObjectContext { get }
    
    func updateStudent()
    func deleteStudent(student: Student)
    func saveStudent(name: String, dateOfBirth: Date)
}

class StudentDataManager: StudentDataServiceProtocol {
    
    //MARK: - Properties
    private let coreDataManager: CoreDataManager
    
    init() {
        self.coreDataManager = CoreDataManager(modelName: "ApplicationDatabase")
    }
    
    var studentsFetchRequest: NSFetchRequest<Student> {
        let fetchRequest: NSFetchRequest<Student> = Student.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        //fetchRequest.returnsObjectsAsFaults = false
        return fetchRequest
    }
    
    var context: NSManagedObjectContext {
        coreDataManager.mainContext
    }
    
    func updateStudent() {
        coreDataManager.saveContext()
    }
    
    func saveStudent(name: String, dateOfBirth: Date) {
        let student = Student(context: coreDataManager.mainContext)
        student.name = name
        student.dateOfBirth = dateOfBirth
        
        coreDataManager.saveContext()
    }
    
    func deleteStudent(student: Student) {
        coreDataManager.mainContext.delete(student)
        
        coreDataManager.saveContext()
    }
    
    
}
