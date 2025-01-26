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
    
    public init(job: Job) {
        self._editJobViewModel = .init(wrappedValue: .init(job: job))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Group {
                    imageView
                    tipView
                    titleView
                }
                .onTapGesture {
                    editJobViewModel.isShowingLogoDetails = true
                }
                statusView
                locationView
                extraInfoView
                recruiterInfoView
                notesView
                notificationAndReminders
            }
            .padding(.bottom)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .sheet(isPresented: $editJobViewModel.isShowingLogoDetails) {
            LogoOptionsView(logoOptionsViewModel: editJobViewModel.getLogoOptionsViewModel())
        }
        .alert("Important Notice", isPresented: $editJobViewModel.isShowingWarnings) {
            Button("Go!", role: .none) {
                openURL(URL(string: "https://www.\(editJobViewModel.companyWebsite)")!)
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Websites might not be accurate. You can edit them by tapping the logo above")
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
        AsyncImage(url: URL(string: editJobViewModel.job.logoURL)) { phase in
            switch phase {
            case .empty, .failure(_):
                defaultImage
            case let .success(image):
                image
                    .cornerRadius(8)
                    .shadow(radius: 2)
                    .padding(.top, 10)
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
            Text(editJobViewModel.job.company)
                .font(.title)
            Text(editJobViewModel.job.title)
                .font(.body)
                .foregroundStyle(Color(UIColor.secondaryLabel))
            
            Button(action: {
                if editJobViewModel.count < 1 {
                    editJobViewModel.setupWebsiteWarning()
                } else {
                    openURL(URL(string: "https://www.\(editJobViewModel.job.companyWebsite)")!)
                }
            },label: {
                Label("Visit website", systemImage: "safari")
                    .font(.subheadline)
                    .foregroundColor(.accentColor)
            })
            .padding(.top, 6)
            .padding(.bottom, 32)
            .disabled(editJobViewModel.job.companyWebsite.isEmpty)
        }
    }
    
    private var statusView: some View {
        HStack {
            Text("Status")
                .padding(.leading)
            Spacer()
            Picker("Status", selection: $editJobViewModel.job.jobApplicationStatus) {
                ForEach(JobApplicationStatus.allCases, id: \.id) { status in
                    Text(status.status).tag(status)
                }
            }
        }
        .cellBackground()
    }
    
    private var locationView: some View {
        VStack {
            HStack {
                Text("Location")
                    .padding(.leading)
                Spacer()
                Picker("Location", selection: $editJobViewModel.job.locationType.animation()) {
                    ForEach(LocationType.allCases, id: \.self) { type in
                        Text(type.type).tag(type)
                    }
                }
            }
            if !editJobViewModel.isLocationOnSite() {
                Divider()
                TextField("Add Location", text: $editJobViewModel.job.location)
                    .cellPadding()
                Divider()
                WorkingDaysView(workingDays: $editJobViewModel.job.workingDays,
                                workingDaysToSave: editJobViewModel.workingDaysToSave)
                .cellPadding()
            }
        }
        .cellBackground()
    }
    
    private var extraInfoView: some View {
        VStack {
            HStack {
                Text("Salary")
                Menu {
                    Picker("currency", selection: $editJobViewModel.job.currencyType) {
                        ForEach(CurrencyType.allCases) {
                            Text($0.symbol)
                        }
                    }
                } label: {
                    Text(editJobViewModel.job.currencyType.symbol)
                }
                Spacer()
                TextField("Amount", text: $editJobViewModel.job.salary)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numberPad)
            }
            .cellPadding()
            Divider()
            HStack {
                TextField("Link to job posting", text: $editJobViewModel.job.jobURLPosting)
                    .textCase(.lowercase)
                    .autocapitalization(.none)
                Spacer()
                Button(action: {
                    openURL(URL(string: editJobViewModel.job.jobURLPosting)!)
                }, label: {
                    Image(systemName: "arrow.up.forward.app.fill")
                        .imageScale(.large)
                        .foregroundStyle(Color.accentColor)
                })
                .disabled(editJobViewModel.job.jobURLPosting.isEmpty)
                .buttonStyle(.plain)
            }
            .cellPadding()
        }
        .cellBackground()
    }
    
    private var recruiterInfoView: some View {
        VStack(alignment: .leading) {
            customSectionHeader(title: "RECRUITER'S INFO")
            VStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            editJobViewModel.isShowingRecruiterDetails
                                .toggle()
                        }
                    }, label: {
                        Image(systemName: "info.circle")
                            .imageScale(.medium)
                            .foregroundStyle(Color.accentColor)
                    })
                    .buttonStyle(.plain)
                    
                    TextField("Recruiter's name", text: $editJobViewModel.job.recruiterName)
                    Spacer()
                    Button(action: {
                        // TODO: action to add to calendar
                    }, label: {
                        Image(systemName: "phone.circle.fill")
                            .foregroundStyle(Color.accentColor)
                            .imageScale(.large)
                    })
                    .disabled(editJobViewModel.job.recruiterNumber.isEmpty)
                    
                    Button(action: {
                        EmailHelper
                            .shared
                            .askUserForTheirPreference(
                                email: editJobViewModel.job.recruiterEmail,
                                subject:
                                    "Interview at \(editJobViewModel.job.company) follow up",
                                body:
                                    "Hi, \(editJobViewModel.job.recruiterName)")
                    },label: {
                        Image(systemName: "envelope.circle.fill")
                            .foregroundStyle(Color.accentColor)
                            .imageScale(.large)
                    })
                    .buttonStyle(.plain)
                    .disabled(editJobViewModel.job.recruiterEmail.isEmpty)
                }
                .cellPadding()
                
                if editJobViewModel.isShowingRecruiterDetails {
                    Divider()
                    TextField( "Phone number", text: $editJobViewModel.job.recruiterNumber)
                        .keyboardType(.numberPad)
                        .cellPadding()
                    Divider()
                    TextField("Email", text: $editJobViewModel.job.recruiterEmail)
                        .keyboardType(.emailAddress)
                        .cellPadding()
                }
            }
            .cellBackground()
        }
    }
    
    private var notesView: some View {
        VStack(alignment: .leading) {
            customSectionHeader(title: "YOUR NOTES")
            
            TextField("Notes", text: $editJobViewModel.job.notes, axis: .vertical)
                .lineLimit(5...10)
                .cellPadding()
                .cellBackground()
        }
    }
    
    // TODO: FINISH UI
    private var notificationAndReminders: some View {
        VStack(alignment: .leading) {
            customSectionHeader(title: "NOTIFICATIONS AND CALENDAR EVENTS")
            HStack(alignment: .center, spacing: 10) {
                Button(action: {
                    editJobViewModel.notificationManager.deleteNotification(
                        identifier: &editJobViewModel.job.localNotificationID!)
                }, label: {
                    Text(editJobViewModel.job.localNotificationID!.isEmpty ? "Add Reminder" : "Delete Reminder")
                    .frame(maxWidth: .infinity)
                })
                .buttonStyle(.borderedProminent)
                Button(action: {
                    // TODO: Button to add calendar event
                },
                       label: {
                    Text("Add To Calendar")
                        .frame(maxWidth: .infinity)
                })
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
}
