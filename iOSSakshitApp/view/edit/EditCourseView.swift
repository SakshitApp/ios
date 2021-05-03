//
//  EditCourseView.swift
//  iOSSakshitApp
//
//  Created by Punit Chhajer on 31/03/21.
//

import SwiftUI
import URLImage
import shared

struct EditCourseView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    
    var course: String?
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ZStack(alignment: .bottomTrailing) {
                        if let url = URL(string: viewModel.image ?? "") {
                                
                            URLImage(url: url) { () -> Image in
                                Image(systemName: "photo.fill")
                            } inProgress: { (pregress) -> Image in
                                Image(systemName: "photo.fill")
                            } failure: { (error, retry) -> Image in
                                Image(systemName: "photo.fill")
                            } content: { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                            .frame(height: 200)
                            .clipped()
                            .foregroundColor(.black)
                        } else {
                            Image(systemName: "photo.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .padding([.top, .bottom, .leading], 8)
                                .foregroundColor(.black)
                                .clipped()
                        }
                        ButtonView(text: "Upload", type: .filled(25), action: {
//                            viewModel.signUp()
                        }).frame(width: 100)
                        .padding()
                    }
                    VStack {
                    TextFieldView(title: "Title", text: $viewModel.title)
                        .padding([.top, .horizontal], 10)
                    TextFieldView(title: "Summery", text: $viewModel.summery)
                        .padding([.top, .horizontal], 10)
                    TextFieldView(title: "Description", text: $viewModel.desciption)
                        .padding([.top, .horizontal], 10)
                    Dropdown(title: "Category", options: viewModel.categoriesAll)
                        .padding([.top, .horizontal], 10)
                    Dropdown(title: "Language", options: viewModel.languagiesAll)
                        .padding([.top, .horizontal], 10)
                    TextFieldView(title: "Price", text: $viewModel.price)
                        .padding([.top, .horizontal], 10)
                    }
                    
                    Text("Lessons").bold().frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding([.top, .horizontal], 10)
                    if let lessons = viewModel.data?.lessons {
                        ForEach(lessons, id: \.uuid) { item in
                            ZStack {
                                NavigationLink(destination: EditLessonView(viewModel: EditLessonView.ViewModel(repository: CourseRepository(), courseId: viewModel.data?.uuid, lessonId: item.uuid))) {
                                    CourseStatusRow(url: URL(string: item.image ?? ""), title: item.title ?? "<title>", subtitle: item.description_ ?? "<answer>", status: "Questions: \(item.question.count) Likes: \(item.likes) Review: \(item.review.count)") {
//                                        viewModel.delete(course: item)
                                    }
                                }
                            }
                        }
                    }
                    NavigationLink(destination: EditLessonView(viewModel: EditLessonView.ViewModel(repository: CourseRepository(), courseId: viewModel.data?.uuid))) {
                        Text("+ Add New Lesson")
                    }
                    .padding()
                    ButtonView(text: "Save", type: .filled(25)) {
                        
                    }
                    .padding([.horizontal], 10)
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
        .navigationBarTitle("Edit Course")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//struct EditCourseView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditCourseView()
//    }
//}
extension EditCourseView {
    
    class ViewModel: ObservableObject {
        let repository: CourseRepository
        @Published var loading = false
        @Published var error:String? = ""
        @Published var data: EditCourse? = nil
        @Published var image: String? = nil
        @Published var title: String = ""
        @Published var summery: String = ""
        @Published var desciption: String = ""
        @Published var categories = [shared.Category]()
        @Published var languagies = [shared.Language]()
        @Published var categoriesAll = [String]()
        @Published var languagiesAll = [String]()
        @Published var price: String = ""
        
        init(repository: CourseRepository, courseId: String? = nil) {
            self.repository = repository
            self.load(courseId: courseId)
        }
        
        func load(courseId: String? = nil) {
            self.loading = true
            repository.getDraftCourse(id: courseId, completionHandler: { (course, error) in
                self.loading = false
                if let course = course {
                    self.data = course
                    self.image = course.image
                    self.title = course.title ?? ""
                    self.summery = course.summery ?? ""
                    self.desciption = course.description_ ?? ""
                    self.categories = course.categories
                    self.languagies = course.languages
                    self.categoriesAll = course.categoriesAll.map({ (category) -> String in
                        (category.name ?? "")
                    })
                    self.languagiesAll = course.languagesAll.map({ (language) -> String in
                        (language.name ?? "")
                    })
                    self.price = "\(course.price)"
                } else {
                    self.error = error?.localizedDescription ?? "Error"
                }
            })
        }
        
        func save(course: EditCourse) {
            self.loading = true
            repository.updateDraft(draft: course, completionHandler: { (_, error) in
                if let error = error {
                    self.error = error.localizedDescription
                } else {
                    self.load()
                }
            })
        }
        
        func save() {
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

