//
//  HomeView.swift
//  iOSSakshitApp
//
//  Created by Punit Chhajer on 31/03/21.
//

import SwiftUI
import shared

struct ExpertHomeView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    var body: some View {
        ZStack(alignment: .top) {
            ZStack(alignment: .bottomTrailing) {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.list, id: \.uuid) { item in
                        ZStack {
                            NavigationLink(destination: EditCourseView(viewModel: EditCourseView.ViewModel(repository: CourseRepository(), courseId: item.uuid))) {
                                CourseStatusRow(url: URL(string: item.image ?? ""), title: item.title ?? "<title>", subtitle: item.summery ?? "<summery>", status: "Status: \(item.state.name) Likes: \(item.likes) Subscribers: \(item.subscriber) Review: \(item.review.count)", state: item.state) {
                                    viewModel.delete(course: item)
                                } onActivate: { (state) in
                                    viewModel.changeState(course: item, state: state)
                                }
                            }
                        }
                    }
                }
            }
                NavigationLink(destination: EditCourseView(viewModel: EditCourseView.ViewModel(repository: CourseRepository()))) {
    
                Text("+")
                    .font(.system(size: 18))
                    .foregroundColor(Color("InvertColor"))
                    .frame(width: 25, height: 25, alignment: .center)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 50).foregroundColor(Color("AccentColor")))
                    .padding()
                }
            }
            if (viewModel.loading) {
                LinearProgressView()
                    .frame(height: 5, alignment: .center)
            } else {
                EmptyView().frame(height: 5, alignment: .center)
            }
        }
        .snackBar(text: $viewModel.error)
    }
}

struct ExpertHomeView_Previews: PreviewProvider {
    static var previews: some View {
        ExpertHomeView(viewModel: ExpertHomeView.ViewModel(repository: CourseRepository()))
    }
}

extension ExpertHomeView {
    
    class ViewModel: ObservableObject {
        let repository: CourseRepository
        @Published var loading = false
        @Published var error:String? = nil
        @Published var list = [EditCourse]()
        
        init(repository: CourseRepository) {
            self.repository = repository
            self.load(forceRefresh: true)
        }
        
        func load(forceRefresh: Bool = false) {
            self.loading = true
            repository.getCourses(forceReload: forceRefresh, completionHandler: { (courses, error) in
                self.loading = false
                if let courses = courses {
                    self.list = courses
                } else {
                    self.error = error?.localizedDescription ?? "Error"
                }
            })
        }
        
        func delete(course: EditCourse) {
            self.loading = true
            repository.delete(draft: course, completionHandler: { (_, error) in
                if let error = error {
                    self.error = error.localizedDescription
                } else {
                    self.load()
                }
            })
        }
        
        func changeState(course: EditCourse, state: CourseState) {
            self.loading = true
            repository.updateDraft(draft: course, completionHandler: { (course, error) in
                if let _ = course {
                    self.load()
                } else {
                    self.error = error?.localizedDescription ?? "Error"
                }
            })
        }
    }
}
