import Foundation

// MARK: - YouTube API Response Models
struct YouTubeChannelResponse: Decodable {
    let items: [YouTubeChannelItem]
}

struct YouTubeChannelItem: Decodable {
    let statistics: YouTubeStatistics
}

struct YouTubeStatistics: Decodable {
    let subscriberCount: String
    let viewCount: String
    let videoCount: String
}

