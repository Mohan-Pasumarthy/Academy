//
//  GoldmanSacksView.swift
//  GoldmanSacs
//
//  Created by Mohan Pasumarthy on 24/04/26.
//

import SwiftUI

struct GoldmanSacksView: View {
    @StateObject private var viewModel = GoldmanSacksViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if viewModel.items.isEmpty {
                    Text("No Items ....")
                } else {
                    List {
                        ForEach(viewModel.items) { item in
                            let imageURL = URL(string: item.hdurl ?? item.url ?? "")
                            let title = item.title ?? "Untitled"
                            let explanation = item.explanation ?? ""
                            let parsedDate: Date = {
                                guard let ds = item.date else { return Date() }
                                let df = DateFormatter()
                                df.locale = Locale(identifier: "en_US_POSIX")
                                df.dateFormat = "yyyy-MM-dd"
                                return df.date(from: ds) ?? Date()
                            }()
                            RowView(
                                imageURL: imageURL,
                                title: title,
                                explanation: explanation,
                                date: parsedDate
                            )
                            .listRowSeparator(.hidden)
                           .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        }
                    }
                }
            }
            .navigationBarTitle("Goldman Sacks")
        }
    }
}

// struct RowView: View {
//     let imageURL: URL?          // <- use URL instead of a system image name
//     let title: String
//     let explanation: String
//     let date: Date
    
//     // Avatar size you can tweak
//     private let avatarSize: CGFloat = 50

//     var body: some View {
//         ZStack(alignment: .bottomTrailing) {

//             // Main content
//             HStack(alignment: .center, spacing: 12) {
//                 // Image at leading, centered vertically
//                 AsyncImage(url: imageURL) { phase in
//                     switch phase {
//                     case .empty:
//                         // Placeholder while loading
//                         ZStack {
//                             Circle().fill(Color.gray.opacity(0.15))
//                             ProgressView()
//                                 .tint(.secondary)
//                         }
//                     case .success(let image):
//                         image
//                             .resizable()
//                             .aspectRatio(contentMode: .fill)
//                             .frame(width: avatarSize, height: avatarSize)
//                             .clipShape(Circle())
//                             .overlay(
//                                 Circle().stroke(Color(.separator), lineWidth: 0.5)
//                             )
//                     case .failure:
//                         // Fallback on failure
//                         ZStack {
//                             Circle().fill(Color.gray.opacity(0.15))
//                             Image(systemName: "person.crop.circle.fill")
//                                 .resizable()
//                                 .scaledToFit()
//                                 .foregroundColor(.secondary)
//                                 .padding(10)
//                         }
//                         .frame(width: avatarSize, height: avatarSize)
//                     @unknown default:
//                         EmptyView()
//                     }
//                 }
//                 .frame(width: avatarSize, height: avatarSize)
//                 // Title and explanation beside image, at top
//                 VStack(alignment: .leading, spacing: 4) {
//                     Text(title)
//                         .font(.headline)
//                         .foregroundStyle(.primary)
//                         .lineLimit(1)
                    
//                     Text(explanation)
//                         .font(.subheadline)
//                         .foregroundStyle(.secondary)
//                         .lineLimit(2)
                    
//                     Spacer()
//                 }
//             }
//             .padding(12)

//             Text(date.formatted(date: .abbreviated, time: .omitted))
//                 .font(.caption)
//                 .foregroundStyle(.tertiary)
//                 .padding(12)
//         }
//         .frame(maxWidth: .infinity)
//         .frame(height: 120) // Fixed height for consistent layout
//         .padding(.horizontal, 8)
//         .background(Color(.secondarySystemBackground))
//         .cornerRadius(15)
//     }
// }

#Preview {
//    GoldmanSacksView()
//    VStack(spacing: 12) {
//        RowView(
//            imageURL: URL(string: "https://apod.nasa.gov/apod/image/2601/AuroraFireworksstormRoiLevi1024.jpg"),
//            title: "Goldman Sacks",
//            explanation: "Quarterly results exceeded expectations with strong performance in the investment banking division.",
//            date: .now
//        )
//        RowView(
//            imageURL: URL(string: "https://picsum.photos/300"),
//            title: "Market Update",
//            explanation: "Tech sector continues to rally as investors rotate into growth equities.",
//            date: .now.addingTimeInterval(-86_400)
//        )
//    }
//    .padding()
//    .background(Color(.systemBackground))
}
