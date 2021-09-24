//
//  StudentView.swift
//  SwiftUI-CoreData
//
//  Created by Phuc Bui  on 9/24/21.
//

import SwiftUI

struct StudentView: View {
    
    @StateObject var student: Student
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(student.name ?? "")
                .font(.title)
            HStack {
                Text("Date of birth: ")
                    .font(.caption)
                Spacer()
                Text("\(Self.dateFormatter.string(from: student.dateOfBirth ?? Date() ))")
                    .font(.caption)
            }
        }
    }
}



