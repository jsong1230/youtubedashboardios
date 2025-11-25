import SwiftUI

struct VideoDetailView: View {
    let video: YouTubeVideoItem
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Thumbnail
                if let thumbnailURL = getThumbnailURL() {
                    AsyncImage(url: URL(string: thumbnailURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay(ProgressView())
                    }
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                
                // Video Title
                Text(video.snippet.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                // Channel Info
                HStack {
                    Text(video.snippet.channelTitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(formatDate(video.snippet.publishedAt))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                Divider()
                    .padding(.horizontal)
                
                // Statistics
                if let stats = video.statistics {
                    VStack(spacing: 16) {
                        HStack(spacing: 20) {
                            StatItem(
                                icon: "eye.fill",
                                label: "조회수",
                                value: formatNumber(Int(stats.viewCount) ?? 0),
                                color: .blue
                            )
                            
                            if let likeCount = stats.likeCount, let likes = Int(likeCount) {
                                StatItem(
                                    icon: "hand.thumbsup.fill",
                                    label: "좋아요",
                                    value: formatNumber(likes),
                                    color: .red
                                )
                            }
                            
                            if let commentCount = stats.commentCount, let comments = Int(commentCount) {
                                StatItem(
                                    icon: "message.fill",
                                    label: "댓글",
                                    value: formatNumber(comments),
                                    color: .green
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Divider()
                    .padding(.horizontal)
                
                // Description
                VStack(alignment: .leading, spacing: 8) {
                    Text("설명")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text(video.snippet.description.isEmpty ? "설명이 없습니다." : video.snippet.description)
                        .font(.body)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal)
                
                // Open in YouTube Button
                Button(action: {
                    openInYouTube()
                }) {
                    HStack {
                        Image(systemName: "play.rectangle.fill")
                        Text("YouTube에서 보기")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.top)
            }
            .padding(.vertical)
        }
        .navigationTitle("비디오 상세")
        .navigationBarTitleDisplayMode(.inline)
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
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    private func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? "0"
    }
    
    private func openInYouTube() {
        let videoId = video.id.videoId
        let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(videoId)")!
        let youtubeAppURL = URL(string: "youtube://watch?v=\(videoId)")!
        
        // Try to open in YouTube app first
        if UIApplication.shared.canOpenURL(youtubeAppURL) {
            UIApplication.shared.open(youtubeAppURL)
        } else {
            // Fallback to web browser
            UIApplication.shared.open(youtubeURL)
        }
    }
}

struct StatItem: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationView {
        VideoDetailView(video: YouTubeVideoItem(
            id: YouTubeVideoId(videoId: "test123"),
            snippet: YouTubeVideoSnippet(
                title: "샘플 비디오 제목",
                description: "이것은 비디오 설명입니다. 여기에 더 많은 내용이 들어갈 수 있습니다.",
                publishedAt: "2024-01-01T00:00:00Z",
                thumbnails: YouTubeThumbnails(
                    default: YouTubeThumbnail(url: "https://example.com/thumb.jpg", width: 120, height: 90),
                    medium: nil,
                    high: nil
                ),
                channelTitle: "채널명"
            ),
            statistics: YouTubeVideoStatistics(viewCount: "100000", likeCount: "5000", commentCount: "500")
        ))
    }
}

