import SwiftUI

struct RowView: View {
    let imageURL: URL?
    let title: String
    let explanation: String
    let date: Date

    private let avatarSize: CGFloat = 50

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.secondarySystemBackground))

            HStack(alignment: .center, spacing: 12) {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Circle().fill(Color.gray.opacity(0.15))
                            ProgressView()
                                .tint(.secondary)
                        }
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: avatarSize, height: avatarSize)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color(.separator), lineWidth: 0.5)
                            )
                    case .failure:
                        ZStack {
                            Circle().fill(Color.gray.opacity(0.15))
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.secondary)
                                .padding(10)
                        }
                        .frame(width: avatarSize, height: avatarSize)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: avatarSize, height: avatarSize)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    Text(explanation)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)

                    Spacer()
                }
            }
            .padding(12)

            Text(date.formatted(date: .abbreviated, time: .omitted))
                .font(.caption)
                .foregroundStyle(.tertiary)
                .padding(12)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .padding(.horizontal, 8)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(15)
    }
}
