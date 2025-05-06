import Foundation
import Just
import CryptoKit

/// https://doc.dandanplay.com/open/
public class DandanPlayClient {
    
    public var baseURL = URL(string: "https://api.dandanplay.net")!
    
    private let appID: String
    
    private let appSecret: String
    
    public init(appID: String, appSecret: String) {
        self.appID = appID
        self.appSecret = appSecret
    }
    
    public func match(fileHash: String, completion: @escaping (Result<MatchResponse, Error>) -> Void) {
        var params = [String: Any]()
        params["fileName"] = "empty"
        params["fileHash"] = fileHash
        params["fileSize"] = 0
        params["videoDuration"] = 0
        params["matchMode"] = "hashOnly"
        
        let url = baseURL.appendingPathComponent("api/v2/match")
        request(.post, url: url, data: params, completion: completion)
    }
    
    public func comment(episodeId: Int, withRelated: Bool, chConvert: Int, completion: @escaping (Result<CommentsResponse, Error>) -> Void) {
        let url = baseURL.appendingPathComponent("api/v2/comment/\(episodeId)")
        var params = [String: Any]()
        params["withRelated"] = withRelated
        params["chConvert"] = chConvert
        request(.get, url: url, params: params, completion: completion)
    }
    
    public func loadComments(episodeId: Int, withRelated: Bool, chConvert: Int) async throws -> CommentsResponse {
        try await withCheckedThrowingContinuation { continuation in
            comment(episodeId: episodeId, withRelated: withRelated, chConvert: chConvert) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }
    }
    
    public func searchEpisode(anime: String, episode: String?, completion: @escaping (Result<SearchEpisodeResponse, Error>) -> Void) {
        let url = baseURL.appendingPathComponent("api/v2/search/episodes")
        var params = [String: Any]()
        params["anime"] = anime
        if let episode = episode {
            params["episode"] = episode
        }
        request(.get, url: url, params: params, completion: completion)
    }
}

extension DandanPlayClient {
    
    func request<T: Codable>(_ method: HTTPMethod,
                     url: URLComponentsConvertible,
                     params: [String: Any] = [:],
                     data: [String: Any] = [:],
                     json: Any? = nil,
                     headers: [String: String] = [:],
                     files: [String: HTTPFile] = [:],
                     requestBody: Data? = nil,
                     progressHandler: ((HTTPProgress) -> Void)? = nil,
                     completion: @escaping (Result<T, Error>) -> Void) {
            
        let time = String(Int64(Date().timeIntervalSince1970))
        var httpheaders = headers
        httpheaders["Accept"] = "application/json"
        httpheaders["Accept-Encoding"] = "gzip"
        httpheaders["X-AppId"] = appID
        httpheaders["X-Timestamp"] = time
        httpheaders["X-Signature"] = generateSignature(appID: appID, appSecret: appSecret, path: url.urlComponents!.path, timestamp: time)
        
        Just.request(method, url: url, params: params, data: data, json: json,
                     headers: httpheaders, files: files, requestBody: requestBody, asyncProgressHandler: { progress in
            DispatchQueue.main.async {
                progressHandler?(progress)
            }
        }, asyncCompletionHandler: { response in
            DispatchQueue.main.async {
                self.handleResponse(response,
                                    method: method,
                                    url: url,
                                    params: params,
                                    data: data,
                                    json: json,
                                    headers: headers,
                                    requestBody: requestBody,
                                    progressHandler: progressHandler,
                                    completion: completion)
            }
        })
    }
    
    private func generateSignature(appID: String, appSecret: String, path: String, timestamp: String) -> String {
        let data = appID + timestamp + path + appSecret
        return Data(SHA256.hash(data: data.data(using: .utf8)!)).base64EncodedString()
    }
    
    
    func handleResponse<T: Codable>(_ response: HTTPResult,
                        method: HTTPMethod,
                        url: URLComponentsConvertible,
                        params: [String: Any] = [:],
                        data: [String: Any] = [:],
                        json: Any? = nil,
                        headers: [String: String] = [:],
                        requestBody: Data? = nil,
                        progressHandler: ((HTTPProgress) -> Void)? = nil,
                        completion: @escaping (Result<T, Error>) -> Void) {
        
        if let err = response.error {
            completion(.failure(err))
            return
        }
        
        if response.json == nil, response.text != nil {
            completion(.failure(DandanPlayError.serverError(response)))
        } else {
            if let content = response.content {
                do {
                    let result = try JSONDecoder().decode(T.self, from: content)
                    completion(.success(result))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            } else {
                completion(.failure(DandanPlayError.jsonDecodeError(response)))
            }
        }
    }
    
}
