import Foundation
import SwiftUI
import Combine

@MainActor
class YouTubeViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var subscriberCount: Int = 0
    @Published var viewCount: Int = 0
    @Published var videoCount: Int = 0
    @Published var lastUpdated: Date?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // Channel Info
    @Published var channelTitle: String = ""
    @Published var channelDescription: String = ""
    @Published var customUrl: String = ""
    @Published var publishedAt: Date?
    @Published var channelThumbnailURL: String = ""
    @Published var country: String = ""
    
    // Recent Videos
    @Published var recentVideos: [YouTubeVideoItem] = []
    @Published var isLoadingVideos: Bool = false
    
    // MARK: - API Configuration
    private var apiKey: String {
        EnvLoader.shared.get("YOUTUBE_API_KEY") ?? ""
    }
    
    private var channelId: String {
        EnvLoader.shared.get("YOUTUBE_CHANNEL_ID") ?? ""
    }
    
    private let baseURL = "https://www.googleapis.com/youtube/v3/channels"
    
    // MARK: - Initializer
    init() {
        // Auto-fetch on app launch
        Task {
            await fetchStats()
            await fetchRecentVideos()
        }
    }
    
    // MARK: - Fetch Stats Function
    func fetchStats() async {
        isLoading = true
        errorMessage = nil
        
        guard let url = buildURL() else {
            errorMessage = "잘못된 URL입니다."
            isLoading = false
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            let decoder = JSONDecoder()
            let channelResponse = try decoder.decode(YouTubeChannelResponse.self, from: data)
            
            // Check for API errors
            if let error = channelResponse.error {
                let errorReason = error.errors?.first?.reason ?? ""
                let errorMsg = error.errors?.first?.message ?? error.message
                if errorReason == "quotaExceeded" {
                    errorMessage = "API 할당량을 초과했습니다. 내일 다시 시도해주세요."
                } else {
                    errorMessage = "API 오류 (코드: \(error.code)): \(errorMsg)"
                }
                isLoading = false
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                errorMessage = "서버 오류 (코드: \(httpResponse.statusCode))"
                isLoading = false
                return
            }
            
            guard let items = channelResponse.items, let channel = items.first else {
                errorMessage = "채널 정보를 찾을 수 없습니다."
                isLoading = false
                return
            }
            
            // Update published properties on main thread
            subscriberCount = Int(channel.statistics.subscriberCount) ?? 0
            viewCount = Int(channel.statistics.viewCount) ?? 0
            videoCount = Int(channel.statistics.videoCount) ?? 0
            
            // Update channel info
            if let snippet = channel.snippet {
                channelTitle = snippet.title
                channelDescription = snippet.description
                customUrl = snippet.customUrl ?? ""
                country = snippet.country ?? ""
                
                // Parse published date
                let dateFormatter = ISO8601DateFormatter()
                publishedAt = dateFormatter.date(from: snippet.publishedAt)
                
                // Get thumbnail URL (prefer high, fallback to medium, then default)
                if let highThumbnail = snippet.thumbnails.high {
                    channelThumbnailURL = highThumbnail.url
                } else if let mediumThumbnail = snippet.thumbnails.medium {
                    channelThumbnailURL = mediumThumbnail.url
                } else if let defaultThumbnail = snippet.thumbnails.default {
                    channelThumbnailURL = defaultThumbnail.url
                }
            }
            
            lastUpdated = Date()
            isLoading = false
            
        } catch let decodingError as DecodingError {
            errorMessage = "데이터 파싱 오류: \(decodingError.localizedDescription)"
            isLoading = false
        } catch {
            errorMessage = "네트워크 오류: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    // MARK: - Fetch Recent Videos Function
    func fetchRecentVideos() async {
        isLoadingVideos = true
        
        guard let searchURL = buildVideoListURL() else {
            isLoadingVideos = false
            return
        }
        
        do {
            // Step 1: Get video list from search API
            let (searchData, searchResponse) = try await URLSession.shared.data(from: searchURL)
            
            guard let httpResponse = searchResponse as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                isLoadingVideos = false
                return
            }
            
            let decoder = JSONDecoder()
            let videoListResponse = try decoder.decode(YouTubeVideoListResponse.self, from: searchData)
            
            // Step 2: Get statistics for all videos at once
            let videoIds = videoListResponse.items.map { $0.id.videoId }.joined(separator: ",")
            
            guard let statsURL = buildVideoStatsURL(videoIds: videoIds) else {
                recentVideos = videoListResponse.items
                isLoadingVideos = false
                return
            }
            
            let (statsData, statsResponse) = try await URLSession.shared.data(from: statsURL)
            
            guard let statsHttpResponse = statsResponse as? HTTPURLResponse,
                  statsHttpResponse.statusCode == 200 else {
                recentVideos = videoListResponse.items
                isLoadingVideos = false
                return
            }
            
            let statsResponse_decoded = try decoder.decode(YouTubeVideosResponse.self, from: statsData)
            
            // Combine video info with statistics
            var videosWithStats: [YouTubeVideoItem] = []
            for video in videoListResponse.items {
                if let videoDetail = statsResponse_decoded.items.first(where: { $0.id == video.id.videoId }) {
                    // Create new video item with statistics
                    let videoWithStats = YouTubeVideoItem(
                        id: video.id,
                        snippet: video.snippet,
                        statistics: videoDetail.statistics
                    )
                    videosWithStats.append(videoWithStats)
                } else {
                    videosWithStats.append(video)
                }
            }
            
            recentVideos = videosWithStats
            isLoadingVideos = false
            
        } catch {
            isLoadingVideos = false
            // Silently fail for videos - don't show error to user
        }
    }
    
    // MARK: - Helper Functions
    private func buildURL() -> URL? {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "part", value: "snippet,statistics"),
            URLQueryItem(name: "id", value: channelId),
            URLQueryItem(name: "key", value: apiKey)
        ]
        return components?.url
    }
    
    private func buildVideoListURL() -> URL? {
        var components = URLComponents(string: "https://www.googleapis.com/youtube/v3/search")
        components?.queryItems = [
            URLQueryItem(name: "part", value: "snippet"),
            URLQueryItem(name: "channelId", value: channelId),
            URLQueryItem(name: "order", value: "date"),
            URLQueryItem(name: "type", value: "video"),
            URLQueryItem(name: "maxResults", value: "10"),
            URLQueryItem(name: "key", value: apiKey)
        ]
        return components?.url
    }
    
    private func buildVideoStatsURL(videoIds: String) -> URL? {
        var components = URLComponents(string: "https://www.googleapis.com/youtube/v3/videos")
        components?.queryItems = [
            URLQueryItem(name: "part", value: "statistics"),
            URLQueryItem(name: "id", value: videoIds),
            URLQueryItem(name: "key", value: apiKey)
        ]
        return components?.url
    }
}

