import Foundation

// MARK: - YouTube API Response Models
struct YouTubeChannelResponse: Decodable {
    let items: [YouTubeChannelItem]?
    let error: YouTubeError?
}

struct YouTubeError: Decodable {
    let code: Int
    let message: String
    let errors: [YouTubeErrorDetail]?
}

struct YouTubeErrorDetail: Decodable {
    let message: String
    let domain: String?
    let reason: String?
}

struct YouTubeChannelItem: Decodable {
    let id: String
    let snippet: YouTubeChannelSnippet?
    let statistics: YouTubeStatistics
}

struct YouTubeChannelSnippet: Decodable {
    let title: String
    let description: String
    let customUrl: String?
    let publishedAt: String
    let thumbnails: YouTubeThumbnails
    let country: String?
}

struct YouTubeThumbnails: Decodable {
    let `default`: YouTubeThumbnail?
    let medium: YouTubeThumbnail?
    let high: YouTubeThumbnail?
    
    enum CodingKeys: String, CodingKey {
        case `default`
        case medium
        case high
    }
}

struct YouTubeThumbnail: Decodable {
    let url: String
    let width: Int?
    let height: Int?
}

struct YouTubeStatistics: Decodable {
    let subscriberCount: String
    let viewCount: String
    let videoCount: String
}

// MARK: - Video List Models
struct YouTubeVideoListResponse: Decodable {
    let items: [YouTubeVideoItem]
}

struct YouTubeVideoItem: Decodable {
    let id: YouTubeVideoId
    let snippet: YouTubeVideoSnippet
    let statistics: YouTubeVideoStatistics?
}

struct YouTubeVideoId: Decodable {
    let videoId: String
}

struct YouTubeVideoSnippet: Decodable {
    let title: String
    let description: String
    let publishedAt: String
    let thumbnails: YouTubeThumbnails
    let channelTitle: String
}

struct YouTubeVideoStatistics: Decodable {
    let viewCount: String
    let likeCount: String?
    let commentCount: String?
}

// MARK: - Videos API Response (for statistics)
struct YouTubeVideosResponse: Decodable {
    let items: [YouTubeVideoDetail]
}

struct YouTubeVideoDetail: Decodable {
    let id: String
    let statistics: YouTubeVideoStatistics
}

