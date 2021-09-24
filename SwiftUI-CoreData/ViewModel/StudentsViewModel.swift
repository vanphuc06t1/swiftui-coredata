//
//  StudentsViewModel.swift
//  SwiftUI-CoreData
//
//  Created by Phuc Bui  on 9/24/21.
//

import Foundation
import CoreData

protocol StudentsViewModelProtocol : class {
    
    var selectedStudent: Student? { get set}

    func updateStudent()
    func deleteStudent(student: Student)
    func saveStudent(name: String, dateOfBirth: Date)
}

class StudentsViewModel : NSObject, NSFetchedResultsControllerDelegate, ObservableObject, StudentsViewModelProtocol {
    
    var selectedStudent: Student?
    
    @Published var students : [Student] = []
    
    private let fetchedResultsController: NSFetchedResultsController<Student>
    
    let studentDataService : StudentDataServiceProtocol
    
    init(studentDataService: StudentDataServiceProtocol) {
        self.studentDataService = studentDataService
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: studentDataService.studentsFetchRequest, managedObjectContext: studentDataService.context, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        setupFetchResultsController()
    }
    
    func updateStudent() {
        studentDataService.updateStudent()
    }
    
    func deleteStudent(student: Student) {
        studentDataService.deleteStudent(student: student)
    }
    
    func saveStudent(name: String, dateOfBirth: Date) {
        studentDataService.saveStudent(name: name, dateOfBirth: dateOfBirth)
    }
    
    // MARK: - Private methods
    private func setupFetchResultsController() {
      fetchedResultsController.delegate = self
      try? fetchedResultsController.performFetch()
      students = fetchedResultsController.fetchedObjects ?? []
    }

    // MARK: - NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        students = fetchedResultsController.fetchedObjects ?? []
    }
    
    
}
