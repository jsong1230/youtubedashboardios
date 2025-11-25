import SwiftUI
import Charts

struct VideoStatsChart: View {
    let videos: [YouTubeVideoItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("최근 비디오 조회수")
                .font(.headline)
                .padding(.horizontal)
            
            if videos.isEmpty {
                Text("비디오 데이터가 없습니다.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                Chart {
                    ForEach(Array(videos.prefix(5).enumerated()), id: \.element.id.videoId) { index, video in
                        BarMark(
                            x: .value("비디오", "\(index + 1)"),
                            y: .value("조회수", getViewCount(video))
                        )
                        .foregroundStyle(Color.blue.gradient)
                        .annotation(position: .top) {
                            Text(formatNumber(getViewCount(video)))
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .frame(height: 200)
                .padding()
            }
        }
        .padding(.vertical)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
    
    private func getViewCount(_ video: YouTubeVideoItem) -> Int {
        return Int(video.statistics?.viewCount ?? "0") ?? 0
    }
    
    private func formatNumber(_ number: Int) -> String {
        if number >= 1000000 {
            return String(format: "%.1fM", Double(number) / 1000000.0)
        } else if number >= 1000 {
            return String(format: "%.1fK", Double(number) / 1000.0)
        } else {
            return "\(number)"
        }
    }
}

#Preview {
    let sampleVideos = [
        YouTubeVideoItem(
            id: YouTubeVideoId(videoId: "1"),
            snippet: YouTubeVideoSnippet(
                title: "비디오 1",
                description: "",
                publishedAt: "2024-01-01T00:00:00Z",
                thumbnails: YouTubeThumbnails(default: nil, medium: nil, high: nil),
                channelTitle: "채널"
            ),
            statistics: YouTubeVideoStatistics(viewCount: "100000", likeCount: "1000", commentCount: "100")
        ),
        YouTubeVideoItem(
            id: YouTubeVideoId(videoId: "2"),
            snippet: YouTubeVideoSnippet(
                title: "비디오 2",
                description: "",
                publishedAt: "2024-01-02T00:00:00Z",
                thumbnails: YouTubeThumbnails(default: nil, medium: nil, high: nil),
                channelTitle: "채널"
            ),
            statistics: YouTubeVideoStatistics(viewCount: "50000", likeCount: "500", commentCount: "50")
        )
    ]
    
    return VideoStatsChart(videos: sampleVideos)
        .padding()
}

