import SwiftUI

struct ChannelInfoCard: View {
    @ObservedObject var viewModel: YouTubeViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Channel Header with Thumbnail
            HStack(spacing: 16) {
                // Channel Thumbnail
                if !viewModel.channelThumbnailURL.isEmpty {
                    AsyncImage(url: URL(string: viewModel.channelThumbnailURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                }
                
                // Channel Title and Custom URL
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.channelTitle)
                        .font(.title2)
                        .fontWeight(.bold)
                        .lineLimit(2)
                    
                    if !viewModel.customUrl.isEmpty {
                        Text(viewModel.customUrl)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
                
                Spacer()
            }
            
            Divider()
            
            // Channel Description
            if !viewModel.channelDescription.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("채널 소개")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text(viewModel.channelDescription)
                        .font(.body)
                        .lineLimit(5)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            // Additional Info
            VStack(alignment: .leading, spacing: 8) {
                if let publishedAt = viewModel.publishedAt {
                    InfoRow(label: "생성일", value: formatDate(publishedAt))
                }
                
                if !viewModel.country.isEmpty {
                    InfoRow(label: "국가", value: getCountryName(viewModel.country))
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    private func getCountryName(_ code: String) -> String {
        let locale = Locale(identifier: "ko_KR")
        return locale.localizedString(forRegionCode: code) ?? code
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    let viewModel = YouTubeViewModel()
    return ChannelInfoCard(viewModel: viewModel)
        .padding()
}

