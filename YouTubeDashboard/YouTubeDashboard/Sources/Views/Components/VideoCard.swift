import SwiftUI

struct VideoCard: View {
    let video: YouTubeVideoItem
    
    var body: some View {
        NavigationLink(destination: VideoDetailView(video: video)) {
            HStack(spacing: 12) {
            // Thumbnail
            if let thumbnailURL = getThumbnailURL() {
                AsyncImage(url: URL(string: thumbnailURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            ProgressView()
                        )
                }
                .frame(width: 120, height: 68)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            // Video Info
            VStack(alignment: .leading, spacing: 6) {
                Text(video.snippet.title)
                    .font(.headline)
                    .lineLimit(2)
                    .foregroundColor(.primary)
                
                Text(formatDate(video.snippet.publishedAt))
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                // Statistics
                if let stats = video.statistics {
                    HStack(spacing: 12) {
                        if let viewCount = Int(stats.viewCount) {
                            Label(formatNumber(viewCount), systemImage: "eye.fill")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        if let likeCount = stats.likeCount, let likes = Int(likeCount) {
                            Label(formatNumber(likes), systemImage: "hand.thumbsup.fill")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
        )
        .buttonStyle(PlainButtonStyle())
        }
    }
    
    private func getThumbnailURL() -> String? {
        if let high = video.snippet.thumbnails.high {
            return high.url
        } else if let medium = video.snippet.thumbnails.medium {
            return medium.url
        } else if let `default` = video.snippet.thumbnails.default {
            return `default`.url
        }
        return nil
    }
    
    private func formatDate(_ dateString: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        guard let date = dateFormatter.date(from: dateString) else {
            return dateString
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    private func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? "0"
    }
}

#Preview {
    let sampleVideo = YouTubeVideoItem(
        id: YouTubeVideoId(videoId: "test123"),
        snippet: YouTubeVideoSnippet(
            title: "샘플 비디오 제목",
            description: "설명",
            publishedAt: "2024-01-01T00:00:00Z",
            thumbnails: YouTubeThumbnails(
                default: YouTubeThumbnail(url: "https://example.com/thumb.jpg", width: 120, height: 90),
                medium: nil,
                high: nil
            ),
            channelTitle: "채널명"
        ),
        statistics: YouTubeVideoStatistics(viewCount: "1000", likeCount: "50", commentCount: "10")
    )
    
    return VideoCard(video: sampleVideo)
        .padding()
}

