import SwiftUI

struct StatsSummaryCard: View {
    let videos: [YouTubeVideoItem]
    
    var averageViews: Int {
        guard !videos.isEmpty else { return 0 }
        let totalViews = videos.compactMap { Int($0.statistics?.viewCount ?? "0") }.reduce(0, +)
        return totalViews / videos.count
    }
    
    var totalLikes: Int {
        videos.compactMap { Int($0.statistics?.likeCount ?? "0") }.reduce(0, +)
    }
    
    var totalComments: Int {
        videos.compactMap { Int($0.statistics?.commentCount ?? "0") }.reduce(0, +)
    }
    
    var topVideo: YouTubeVideoItem? {
        videos.max { video1, video2 in
            let views1 = Int(video1.statistics?.viewCount ?? "0") ?? 0
            let views2 = Int(video2.statistics?.viewCount ?? "0") ?? 0
            return views1 < views2
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("비디오 통계 요약")
                .font(.headline)
                .padding(.bottom, 4)
            
            if videos.isEmpty {
                Text("비디오 데이터가 없습니다.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                VStack(spacing: 12) {
                    // Average Views
                    HStack {
                        Image(systemName: "eye.fill")
                            .foregroundColor(.blue)
                        Text("평균 조회수")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(formatNumber(averageViews))
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    
                    Divider()
                    
                    // Total Likes
                    HStack {
                        Image(systemName: "hand.thumbsup.fill")
                            .foregroundColor(.red)
                        Text("총 좋아요")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(formatNumber(totalLikes))
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    
                    Divider()
                    
                    // Total Comments
                    HStack {
                        Image(systemName: "message.fill")
                            .foregroundColor(.green)
                        Text("총 댓글")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(formatNumber(totalComments))
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    
                    if let topVideo = topVideo,
                       let topViews = Int(topVideo.statistics?.viewCount ?? "0") {
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("최고 조회수 비디오")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(topVideo.snippet.title)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .lineLimit(2)
                            Text("\(formatNumber(topViews))회 조회")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
    
    private func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? "0"
    }
}

#Preview {
    let sampleVideos = [
        YouTubeVideoItem(
            id: YouTubeVideoId(videoId: "1"),
            snippet: YouTubeVideoSnippet(
                title: "샘플 비디오 1",
                description: "",
                publishedAt: "2024-01-01T00:00:00Z",
                thumbnails: YouTubeThumbnails(default: nil, medium: nil, high: nil),
                channelTitle: "채널"
            ),
            statistics: YouTubeVideoStatistics(viewCount: "100000", likeCount: "1000", commentCount: "100")
        )
    ]
    
    return StatsSummaryCard(videos: sampleVideos)
        .padding()
}

