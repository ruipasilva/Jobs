//
//  EditJobView.swift
//  Jobs
//
//  Created by Rui Silva on 23/01/2024.
//

import SwiftUI
import TipKit

struct EditJobView: View {
    @StateObject private var editJobViewModel: EditJobViewModel
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    @Environment(\.colorScheme) var colorScheme // Still to implement in custom cells

    public init(job: Job) {
        self._editJobViewModel = .init(wrappedValue: .init(job: job))
    }

    var body: some View {
        ScrollView {
            LazyVStack {
                Group {
                    imageView
                    tipView
                    titleView
                }
                .onTapGesture {
                    editJobViewModel.isShowingLogoDetails = true
                }
                statusView()
                locationView()
                extraInfoView()
                recruiterInfoView()
                notesView()
                interviewQuestionsView()
                notificationAndReminders()
            }
            .padding(.bottom)
        }
        .sheet(isPresented: $editJobViewModel.isShowingLogoDetails) {
            LogoOptionsView(
                logoOptionsViewModel:
                    editJobViewModel.getLogoOptionsViewModel())
        }
        .alert(
            "Important Notice", isPresented: $editJobViewModel.isShowingWarnings
        ) {
            Button("Go!", role: .none) {
                openURL(
                    URL(
                        string: "https://www.\(editJobViewModel.companyWebsite)"
                    )!)
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(
                "Websites might not be accurate. You can edit them by tapping the logo above"
            )
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .toolbar {
            toolbarTrailing
        }

        // TODO: uncomment when work on maps functionality
        //        .actionSheet(isPresented: $showingSheet) {
        //                    let latitude = 45.5088
        //                    let longitude = -73.554
        //
        //                    let appleURL = "http://maps.apple.com/?daddr=\(latitude),\(longitude)"
        //                    let googleURL = "comgooglemaps://?daddr=\(latitude),\(longitude)&directionsmode=driving"
        //
        //                    let googleItem = ("Google Map", URL(string:googleURL)!)
        //                    var installedNavigationApps = [("Apple Maps", URL(string:appleURL)!)]
        //
        //                    if UIApplication.shared.canOpenURL(googleItem.1) {
        //                        installedNavigationApps.append(googleItem)
        //                    }
        //
        //                    var buttons: [ActionSheet.Button] = []
        //                    for app in installedNavigationApps {
        //                        let button: ActionSheet.Button = .default(Text(app.0)) {
        //                            UIApplication.shared.open(app.1, options: [:], completionHandler: nil)
        //                        }
        //                        buttons.append(button)
        //                    }
        //                    let cancel: ActionSheet.Button = .cancel()
        //                    buttons.append(cancel)
        //
        //                    return ActionSheet(title: Text("Navigate"), message: Text("Select an app..."), buttons: buttons)
        //                }
    }

    private var tipView: some View {
        TipView(editJobViewModel.editTip, arrowEdge: .top)
            .tipBackground(Color(uiColor: .secondarySystemGroupedBackground))
            .padding(.horizontal)
    }

    private var imageView: some View {
        AsyncImage(url: URL(string: editJobViewModel.logoURL)) { phase in
            switch phase {
            case .empty:
                defaultImage
            case let .success(image):
                image
                    .cornerRadius(8)
                    .shadow(radius: 2)
                    .padding(.top, 10)
            case .failure(_):
                defaultImage
            @unknown default:
                defaultImage
            }
        }
    }

    private var defaultImage: some View {
        Image(systemName: "suitcase.fill")
            .resizable()
            .foregroundColor(.mint)
            .frame(width: 64, height: 64)
    }

    private var titleView: some View {
        VStack {
            Text(editJobViewModel.company)
                .font(.title)
            Text(editJobViewModel.title)
                .font(.body)
                .foregroundStyle(Color(UIColor.secondaryLabel))

            Button(
                action: {
                    if editJobViewModel.count < 1 {
                       setupWebsiteWarning()
                    } else {
                        openURL(
                            URL(
                                string:
                                    "https://www.\(editJobViewModel.companyWebsite)"
                            )!)
                    }
                },
                label: {
                    Label("Visit website", systemImage: "safari")
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                        .disabled(editJobViewModel.companyWebsite.isEmpty)
                }
            )
            .padding(.top, 6)
            .padding(.bottom, 32)
        }
    }

    private func statusView() -> some View {
        HStack {
            Text("Status")
                .padding(.leading)
            Spacer()
            Picker("Status", selection: $editJobViewModel.jobApplicationStatus)
            {
                ForEach(JobApplicationStatus.allCases, id: \.id) { status in
                    Text(status.status).tag(status)
                }
            }
        }
        .cellBackground()
    }

    private func locationView() -> some View {
        VStack {
            HStack {
                Text("Location")
                    .padding(.leading)
                Spacer()
                Picker(
                    "Location",
                    selection: $editJobViewModel.locationType.animation()
                ) {
                    ForEach(LocationType.allCases, id: \.self) { type in
                        Text(type.type).tag(type)
                    }
                }
            }
            if !editJobViewModel.isLocationRemote() {
                Divider()
                TextField("Add Location", text: $editJobViewModel.location)
                    .cellPadding()
                Divider()
                WorkingDaysView(
                    workingDaysToSave: $editJobViewModel.workingDaysToSave,
                    workingDays: editJobViewModel.workingDays
                )
                .cellPadding()
            }
        }
        .cellBackground()
    }

    private func extraInfoView() -> some View {
        VStack {
            HStack {
                Text("Salary")
                Menu {
                    Picker(
                        "currency", selection: $editJobViewModel.currencyType
                    ) {
                        ForEach(CurrencyType.allCases) {
                            Text($0.symbol)
                        }
                    }
                } label: {
                    Text(editJobViewModel.currencyType.symbol)
                }
                Spacer()
                TextField("Amount", text: $editJobViewModel.salary)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numberPad)
            }
            .cellPadding()
            Divider()
            HStack {
                TextField("Link to job posting", text: $editJobViewModel.url)
                    .textCase(.lowercase)
                    .autocapitalization(.none)
                Spacer()
                Button(
                    action: {
                        openURL(URL(string: "https://\(editJobViewModel.url)")!)
                    },
                    label: {
                        Image(systemName: "arrow.up.forward.app.fill")
                            .imageScale(.large)
                            .foregroundStyle(Color.accentColor)
                    }
                )
                .disabled(editJobViewModel.url.isEmpty)
                .buttonStyle(.plain)
            }
            .cellPadding()
        }
        .cellBackground()
    }

    private func recruiterInfoView() -> some View {
        VStack(alignment: .leading) {
            customSectionHeader(title: "RECRUITER'S INFO")
            VStack {
                HStack {
                    Button(
                        action: {
                            withAnimation {
                                editJobViewModel.isShowingRecruiterDetails
                                    .toggle()
                            }
                        },
                        label: {
                            Image(systemName: "info.circle")
                                .imageScale(.medium)
                                .foregroundStyle(Color.accentColor)
                        }
                    )
                    .buttonStyle(.plain)

                    TextField(
                        "Recruiter's name",
                        text: $editJobViewModel.recruiterName)
                    Spacer()
                    Button(
                        action: {},
                        label: {
                            Image(systemName: "phone.circle.fill")
                                .foregroundStyle(Color.accentColor)
                                .imageScale(.large)
                        }
                    )
                    .disabled(editJobViewModel.recruiterNumber.isEmpty)

                    Button(
                        action: {
                            EmailHelper
                                .shared
                                .askUserForTheirPreference(
                                    email: editJobViewModel.recruiterEmail,
                                    subject:
                                        "Interview at \(editJobViewModel.company) follow up",
                                    body:
                                        "Hi, \(editJobViewModel.recruiterName)")
                        },
                        label: {
                            Image(systemName: "envelope.circle.fill")
                                .foregroundStyle(Color.accentColor)
                                .imageScale(.large)
                        }
                    )
                    .buttonStyle(.plain)
                    .disabled(editJobViewModel.recruiterEmail.isEmpty)
                }
                .cellPadding()

                if editJobViewModel.isShowingRecruiterDetails {
                    Divider()
                    TextField(
                        "Phone number", text: $editJobViewModel.recruiterNumber
                    )
                    .keyboardType(.numberPad)
                    .cellPadding()
                    Divider()
                    TextField("Email", text: $editJobViewModel.recruiterEmail)
                        .keyboardType(.emailAddress)
                        .cellPadding()
                }
            }
            .cellBackground()
        }
    }

    private func notesView() -> some View {
        VStack(alignment: .leading) {
            customSectionHeader(title: "YOUR NOTES")

            TextField("Notes", text: $editJobViewModel.notes, axis: .vertical)
                .lineLimit(5...10)
                .cellPadding()
                .cellBackground()
        }
    }

    private func interviewQuestionsView() -> some View {
        VStack(alignment: .leading) {
            customSectionHeader(title: "INTERVIEW QUESTIONS")
            VStack(alignment: .leading) {
                ForEach(
                    $editJobViewModel.interviewQuestion.sorted(by: {
                        $0.dateAdded.wrappedValue < $1.dateAdded.wrappedValue
                    }), id: \.id
                ) { $question in
                    HStack {
                        Image(
                            systemName: question.completed
                                ? "checkmark.circle.fill" : "circle"
                        )
                        .symbolEffect(
                            .bounce,
                            value: question.completed ? question.completed : nil
                        )
                        .foregroundStyle(
                            question.completed ? .accent : .secondary
                        )
                        .sensoryFeedback(
                            .impact(weight: .heavy, intensity: 1),
                            trigger: question.completed
                        )
                        .onTapGesture {
                            $question.completed.wrappedValue.toggle()
                        }
                        TextField(
                            "Type your question...", text: $question.question)
                        Spacer()
                        Button(
                            action: {
                                editJobViewModel.interviewQuestion.removeAll {
                                    q in
                                    q == question
                                }
                            },
                            label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.red)
                            })
                    }
                    .cellPadding()
                    Divider()
                }

                Button {
                    withAnimation {
                        let interviewQuestion = InterviewQuestion(
                            completed: false, question: "", dateAdded: .now)
                        editJobViewModel.interviewQuestion.append(
                            interviewQuestion)

                    }
                } label: {
                    Label("Add New", systemImage: "plus")
                }
                .frame(maxWidth: .infinity)
                .cellPadding()
            }
            .cellBackground()
        }
    }

    // TODO: FINISH UI
    private func notificationAndReminders() -> some View {
        VStack(alignment: .leading) {
            customSectionHeader(title: "NOTIFICATIONS AND CALENDAR EVENTS")
            HStack(alignment: .center, spacing: 10) {
                Button(
                    action: {
                        editJobViewModel.notificationManager.deleteNotification(
                            identifier: &editJobViewModel.job.localNotificationID!)
                    },
                    label: {
                        Text(
                            !editJobViewModel.job.localNotificationID!.isEmpty
                                ? "Delete Reminder" : "Add Reminder"
                        )
                        .frame(maxWidth: .infinity)
                    }
                )
                .buttonStyle(.borderedProminent)
                Button(
                    action: {
                    },
                    label: {
                        Text("Add To Calendar")
                            .frame(maxWidth: .infinity)
                    }
                )
                .buttonStyle(.bordered)
            }
            .frame(alignment: .center)
            .cellPadding()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func customSectionHeader(title: String) -> some View {
        Text(title)
            .font(.caption)
            .padding(.leading, 36)
            .foregroundStyle(.secondary)
    }

    private var toolbarTrailing: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Update") {
                editJobViewModel.updateJob()
                dismiss()
            }
        }
    }
    
    private func setupWebsiteWarning() {
        editJobViewModel.count += 1
        editJobViewModel.isShowingWarnings = true
    }
}
