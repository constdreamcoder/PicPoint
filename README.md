# PicPoint - 사진 스팟 공유 앱

<p>
    <img src="https://github.com/constdreamcoder/SwiftPrac/assets/95998675/b854d0e1-0e53-446f-901d-05eb958de02e" align="center" width="100%"/>
</p>

<br/>

## PicPoint

- 서비스 소개: 자신만의 사진 스팟 공유 앱
- 개발 인원: 1인
- 개발 기간: 24.04.12 ~ 24.05.05(총 23일)
- 개발 환경
  - 최소버전: iOS 16
  - Portrait Orientation 지원
  - 라이트 모드 지원

<br/>

## 주요 기능

- 회원 인증: 회원 가입 / 로그인 / 회원 탈퇴 / 로그아웃
- 프로필 조회 / 수정
- Direct Message 기능
- 게시글
  - 게시글 작성 / 삭제
  - 게시글 조회
  - 게시글 후원(결제 기능)
  - 게시글 댓글 작성 / 삭제
  - 연관 게시글 추천 기능
- 게시글 좋아요 / 좋아요 취소
- 후원 내역 조회
- 유저 팔로우 / 언팔로우
- 해쉬태그

<br/>

## 기술 소개

- MVVM 패턴
  - UI 로직과 비지니스 로직의 분리 목적으로 도입
  - ViewModel 프로토콜 정의하여 구조적으로 일관된 뷰모델 구성
- RxSwift
  - Input/Output 패턴을 활용해 데이터의 단방향 흐름 구성
- Repository 패턴
  - Realm 구성 시 Repository 패턴을 활용해 비지니스 로직과 데이터 계층을 분리 및 추상화
- Router 패턴
  - Alamofire의 URLRequestConvertible 프로토콜를 준수하는 커스텀 TargetType 구성으로 Router 패턴 구현
  - 커스텀 TargetType 구성을 통한으로 API 호출의 Endpoint 관리를 중앙화
- Alamofire
  - EventMonitor 프로토콜 채택하여 이벤트 실시간 모니터링
  - RequestInterceptor 프로토콜을 채택하여 토큰 만료시 자동 갱신 구성
  - 커스텀 Session 구성으로 커스텀 EventMonitor와 커스텀 RequestInterceptor 적용
- RxDatasoure
  - 프로젝트 반응형 구조 구성에 따른 데이터 바인딩을 위해 도입
  - Section별 다양한 타입의 Cell 대응
  - 열거형을 통한 Section 분리 구성
- SnapKit
  - DSL를 활용한 AutoLayout 코드 간소화 및 가독성 향상
- Modern CollectionView
  - 기기의 다양한 해상도 대응을 위해 UICollectionViewCompositionalLayout 활용
- MapKit
  - CLLocationManager 클래스 상속을 통한 커스텀 LocationManger 구성
  - MKLocalSearchCompleter를 활용한 장소 실시간 검색 구성
  - reverseGeocodeLocation(\_:completionHandler:) 메서드를 통한 주소 검색 구성
- IAMPort
  - 다양한 PG사를 통한 결제를 위해 도입
  - 게시글별 후원 수단으로 활용
- NWPathMonitor
  - NWPathMonitor 실시간 네트워크 연결 상태 모니터링 구성
  - 네트워크 단절 감지 시 상위 계층의 또 다른 window 구성으로 사용자에서 연결 상태 전달
- LocalizedError
  - 열거형에 LocalizedError 프로토콜을 채택하여 Status Code에 따른 오류 코드 및 오류 메세지 재정의
- SocketIO
  - Direct Message 기능 구현을 위한 소켓 통신 구성에 활용
- RealmSwift
  - Direct Message 기능에 채팅 내역 저장에 활용
- Property Wrapper
  - Property Wrapper를 활용한 UserDefaults 코드 간소화
- Kingfisher
  - Header를 통한 이미지 다운로드, 캐싱, 표시에 활용
- PHAsset
  - PHAsset를 이용한 커스텀 Gallery 구성

<br/>

## 구현 내용

### 1. RxSwift + Input/Output pattern을 이용한 게시글 등록 유효성 검사

  |<img src="https://github.com/constdreamcoder/SwiftPrac/assets/95998675/c5cdc8ad-016e-4ba6-bd13-d41760b08ea7" align="center" width="200">|<img src="https://github.com/constdreamcoder/SwiftPrac/assets/95998675/fb87d27d-03f1-4b86-863b-9f405cffb0c4" align="center" width="200">|<img src="https://github.com/constdreamcoder/SwiftPrac/assets/95998675/71b507ca-d7e8-49ee-9844-362b9101aeca" align="center" width="200">|
  |:--:|:--:|:--:|
  |업로드할 사진|위치선택|추천 방문 시간대|

  |<img src="https://github.com/constdreamcoder/SwiftPrac/assets/95998675/776537a7-2ce4-46b4-9cca-7bcc36f61486" align="center" width="200">|<img src="https://github.com/constdreamcoder/SwiftPrac/assets/95998675/0bf38dcd-ebb0-4e11-be2e-24e4d1343c9b" align="center" width="200">|
  |:--:|:--:|
  |방문일|제목, 본문|

- 각 이벤트를 Input으로 전달

- transform 메서드 내부에서 유효성 검사 후 Output 결과 전달
  <details>
  <summary><b>Input/Output pattern</b></summary>
  <div markdown="1">

  ```swift
  final class AddPostViewModel: ViewModelType {
      var disposeBag = DisposeBag()

      struct Input {
          let titleText: ControlEvent<String>
          // ...
      }

      struct Output {
      let registerButtonValid: Driver<Bool>
      // ...
      }

      func transfor(input: Input) -> Output {

          return Output(
              registerButtonValid: registerButtonValid.asDriver(onErrorJustReturn: false)
              // ...
          )
      }
  }
  ```

  </div>
  </details>

<br/>

- 게시글 등록 시 과도한 네트워크 호출 방지를 위해 **.debounce(.seconds(1), scheduler: MainScheduler.instance) 사용**

  <details>
  <summary><b>.debounce(.seconds(1), scheduler: MainScheduler.instance)</b></summary>
  <div markdown="1">

  ```swift
  input.rightBarButtonItemTap
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .map {
              //...
            }
            .subscribe(with: self) {
              // ...
            }
            .disposed(by: disposeBag)
  ```

  </div>
  </details>

<br/>

### 2. Alamofire RequestInterceptor를 통한 JWT 갱신

<img src="https://github.com/constdreamcoder/SwiftPrac/assets/95998675/27ae90f6-5265-4d2b-a1ce-d87e83d992a6" align="center"/>

<br/>

- RequestInterceptor를 상속받아 UserDefaults에 저장된 Access Token의 유효성 검증 후, 필요 시 토큰 갱신
    <details>
    <summary><b>RequestInterceptor 구현</b></summary>
    <div markdown="1">

    ```swift
    final class TokenRefresher: RequestInterceptor {
        
        func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
                // 네트워크 요청전 Header에 Access 토큰 추가
            var urlRequest = urlRequest
            let token = UserDefaults.standard.accessToken
            urlRequest.setValue(token, forHTTPHeaderField: HTTPHeader.authorization.rawValue)
            
            completion(.success(urlRequest))
        }
    
        func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
                // Access 토큰인 만료되지 않은 경우
            guard let response = request.task?.response as? HTTPURLResponse,
                response.statusCode == 419
            else {
                completion(.doNotRetryWithError(error))
                return
            }
                    
            // Access 토큰이 만료된 경우        
            let refreshToken = UserDefaults.standard.refreshToken
            if !refreshToken.isEmpty {
                UserManager.refreshToken { [weak self] response in
                    guard let self else { return }
                    switch response {
                    case .success(let refreshedAccessToken):
                        UserDefaults.standard.accessToken = refreshedAccessToken
                        completion(.retry)
                    case .failure(let error):
                        print("failure")
                        print(error.errorCode, error.errorDesc)
                        if error.errorCode == 418 || error.errorCode == 401 {
                            NotificationCenter.default.post(name: .refreshTokenExpired, object: nil, userInfo: ["showReloginAlert": true])
                        }
                        completion(.doNotRetryWithError(error))
                    }
                }
            }
            
        }
    }
    ```

    </div>
    </details>

<br/>

### 3. LocalizedError 프로토콜 채택을 통한 에러 타입 추상화

- 프로젝트 내 에러 처리 과정
    1. Status Code(Int 타입 RawValue)를 통한 에러 방출
    2. LocalizedError 프로토콜 채택으로 errorDescription 변수를 통한 에러 메세지 정의
    3. 에러 방출 시, errorMessage에 정의된 에러 메세지를 error.localizedDescription 을 통해 외부에서 alert 혹은 log로서 활용

    <details>
    <summary><b>LocalizedError 채택</b></summary>
    <div markdown="1">

    ```swift
    // 공통 에러 정의
    enum CommonNetworkError: Int, LocalizedError {
        case invalidSesacKey = 420
        case excessiveCalls = 429
        case invalidURL = 444
        case serveError = 500
        case unknownError = 999
        
        var errorDescription: String? {
            switch self {
            // case별 에러 메세지 정의
            }
        }
    }

    // 좋아요 API 에러 정의
    enum LikeUnlikePostNetworkError: Int, LocalizedError {
        case badRequest = 400
        case unauthorizedAccessToken = 401
        case forbidden = 403
        case noPostForLikeUnlike = 410
        case expiredAccessToken = 419
        
        var errorDescription: String? {
            switch self {
                // case별 에러 메세지 정의
            }
        }
    }

    // 좋아요 이벤트
    likeTrigger
        .flatMap {
            LikeManager.like(
                params: LikeParams(postId: $0),
                body: LikeBody(like_status: true)
            )
            .catch { error in
            // error.localizedDescription을 통한 에러 메세지 전달
                print(error.errorCode, error.errorDesc)
                return Single<String>.never()
            }
        }
    ```

    </div>
    </details>

<br/>

### 4. 네트워크 연결 단절 대응

<img src="https://github.com/constdreamcoder/SwiftPrac/assets/95998675/c2c56e87-e60a-483d-b669-dd231767463d" align="center" width="200"/>

<br/>

- 네트워크 연결 단절 감지 과정
    
    1. 앱 시동 시 SceneDelegate에서 네트워크 연결 상태 실시간 확인 시작
    
    2. 네트워크 연결 단절 시, 새로운 window를 생성하여 기존 window 위에 네트워크 연결 상태 관한 에러 사항 표시
    
    <details>
    <summary><b>실시간 네트워크 연결 상태 확인</b></summary>
    <div markdown="1">

    ```swift
    // 네트워크 연결 상태 모니터링 객체 정의
    final class NetworkMonitor {
        private let queue = DispatchQueue.global(qos: .background)
        private let monitor: NWPathMonitor
        
        init() {
            monitor = NWPathMonitor()
        }
        
        func startMonitoring(statusUpdateHandler: @escaping (NWPath.Status) -> Void) {
                // 네트워크 연결 상태 실시간 확인
            monitor.pathUpdateHandler = { path in
                DispatchQueue.main.async {
                    statusUpdateHandler(path.status)
                }
            }
            monitor.start(queue: queue)
        }
        
        func stopMonitoring() {
            monitor.cancel()
        }
    }

    // SceneDelegate.swift
    var window: UIWindow?
    var errorWindow: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

            networkMonitor.startMonitoring(statusUpdateHandler: { [weak self] connectionStatus in
            guard let self else { return }
            switch connectionStatus {
            // 네트워크 연결 상태가 원할한 경우, 에러 표시용 window를 화면에서 제거
            case .satisfied:
                removeNetworkErrorWindow()
            // 네트워크 연결 상태가 원할하지 않을 경우, 기존 window 위에 에러 사항 표시용 window 생성
            case .unsatisfied:
                loadNetworkErrorWindow(on: scene)
            default:
                break
            }
        })
    }

    extension SceneDelegate {
            // 네트워크 에러 사항 표시를 위한 새로운 window 생성 정의
        private func loadNetworkErrorWindow(on scene: UIScene) {
            if let windowScene = scene as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                // 기존 window level을 statusBar로 생성해줌으로써 기존 window보다 상위에 표시
                window.windowLevel = .statusBar 
                window.makeKeyAndVisible()
                
                let noNetworkView = NoNetworkView(frame: window.bounds)
                window.addSubview(noNetworkView)
                self.errorWindow = window
            }
        }
        
        // 네트워크 연결 상태 복귀로 인한 window 제거 정의
        private func removeNetworkErrorWindow() {
            errorWindow?.resignKey()
            errorWindow?.isHidden = true
            errorWindow = nil
        }
    }
    ```

    </div>
    </details>
        
<br/>

### 5. 네트워크 요청/응답 로그 구성

- 네트워크 통신마다 어떤 데이터를 주고 받는지 로그 구성

    <details>
    <summary><b>EventMonitor 프로토콜 채택으로 구성한 로그 클래스 코드</b></summary>
    <div markdown="1">

    ```swift
    final class EventLogger: EventMonitor {
        let queue = DispatchQueue(label: "NetworkLogger")
        
        func requestDidFinish(_ request: Request) {
            print("[요청 완료]\n")
            
            print("[요청 헤더]")
            print("URL: \(request.request?.url?.absoluteString ?? "")")
            print("Method: \(request.request?.httpMethod ?? "")")
            print("Headers: \(request.request?.allHTTPHeaderFields ?? [:])\n")
            
            print("[요청 바디]")
            if let body = request.request?.httpBody?.toPrettyPrintedString {
                print("Body: \(body)\n\n")
            } else { print("보낸 Body가 없습니다.\n\n")}
        }
        
        func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
            switch response.result {
            case .success(_):
                print("서버 연결 성공")
            case .failure(_):
                print("서버 연결 실패")
                print("올바른 URL인지 확인해보세요.")
            }
            
            print("[응답 완료]\n")
            
            print("[상태 코드]")
            print("\(response.response?.statusCode ?? 0)\n")
            
            if let statusCode = response.response?.statusCode {
                switch statusCode {
                case 400..<500:
                    print("오류 발생 : RequestError\n" + "잘못된 요청입니다. request를 재작성 해주세요.")
                case 500:
                    print("오류 발생 : ServerError\n" + "Server에 문제가 발생했습니다.")
                default:
                    break
                }
            }
            
            print("[응답 데이터]")
            if let response = response.data?.toPrettyPrintedString {
                print(response)
            } else { print("데이터가 없거나, Encoding에 실패했습니다.")}
        }
        
        
        func request(_ request: Request, didFailTask task: URLSessionTask, earlyWithError error: AFError) {
            print("URLSessionTask가 Fail 했습니다.")
        }
        
        func request(_ request: Request, didFailToCreateURLRequestWithError error: AFError) {
            print("URLRequest를 만들지 못했습니다.")
        }
        
        func requestDidCancel(_ request: Request) {
            print("request가 cancel 되었습니다")
        }
    }

    ```

    </div>
    </details>

    - 네트워크 요청 로그
    
        <img src="https://github.com/constdreamcoder/SwiftPrac/assets/95998675/46eef451-4085-48f3-b6ea-408060b3b13f" align="center"/>
    
    - 네트워크 응답 로그
    
        <img src="https://github.com/constdreamcoder/SwiftPrac/assets/95998675/09851846-9432-4c6d-9409-7c5298da10fd" align="center"/>

<br/>

### 6. 커스텀 UICollectionViewLayout 구성으로 핀터레스트 UI 구현
        
<img src="https://github.com/constdreamcoder/SwiftPrac/assets/95998675/ad4bf231-9d31-4e3e-8a7e-96dac00c30d8" align="center" width="200"/>

- 각 사진의 가로/세로 비율에 따른 다이나믹한 셀의 크기를 가지고 있는 핀터레스트 UI 구현을 위해 커스컴 UICollectionViewLayout 구성

  <details>
  <summary><b>커스텀 UICollectionViewLayout 코드</b></summary>
  <div markdown="1">

  ```swift
  protocol PinterestLayoutDelegate: AnyObject {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
    }

    final class PinterestLayout: UICollectionViewLayout {
        weak var delegate: PinterestLayoutDelegate?
        
        private let numberOfColumns = 2
        private let cellPadding: CGFloat = 6
        
        private var cache: [UICollectionViewLayoutAttributes] = []
        
        private var contentHeight: CGFloat = 0
        
        private var contentWidth: CGFloat {
            guard let collectionView = collectionView else {
                return 0
            }
            let insets = collectionView.contentInset
            return collectionView.bounds.width - (insets.left + insets.right)
        }
        
        override var collectionViewContentSize: CGSize {
            return CGSize(width: contentWidth, height: contentHeight)
        }
    }

    extension PinterestLayout {
        override func prepare() {
            
            cache.removeAll()
            contentHeight = 0
            
            guard
                cache.isEmpty,
                let collectionView = collectionView
            else { return }
            
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            var xOffset: [CGFloat] = []
            for column in 0..<numberOfColumns {
                xOffset.append(CGFloat(column) * columnWidth)
            }
            var column = 0
            var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
            
            for item in 0..<collectionView.numberOfItems(inSection: 0) {
                let indexPath = IndexPath(item: item, section: 0)
                
                let photoHeight = delegate?.collectionView(
                    collectionView,
                    heightForPhotoAtIndexPath: indexPath) ?? 180
                let height = cellPadding * 2 + photoHeight
                let frame = CGRect(x: xOffset[column],
                                y: yOffset[column],
                                width: columnWidth,
                                height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                cache.append(attributes)
                
                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] = yOffset[column] + height
                
                column = column < (numberOfColumns - 1) ? (column + 1) : 0
            }
        }
    }

    extension PinterestLayout {
        override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
            
            for attributes in cache {
                if attributes.frame.intersects(rect) {
                    visibleLayoutAttributes.append(attributes)
                }
            }
            return visibleLayoutAttributes
        }
        
        override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            return cache[indexPath.item]
        }
    }
  ```
  
  </div>
  </details>

<br/>

### 7. SocketIO를 통한 채팅 기능 구현(Direct Message)

- SocketIO를 통 채팅 기능 구현

  <details>
  <summary><b>채팅 소켓 구성 코드</b></summary>
  <div markdown="1">

  ```swift
    final class SocketIOManager {

    static let shared = SocketIOManager()

        private var manager: SocketManager?
        private var socket: SocketIOClient?

        // 수신된 채팅 내역 외부로 반환
        let ReceivedChatDataSubject = PublishSubject<Chat>()

        // 소켓 통신 Manager 생성
        private init() {
            guard let url = URL(string: APIKeys.baseURL) else { return }
            manager = SocketManager(socketURL: url, config: [.log(true), .compress])
        }

        // 소켓 이벤트 리스너 등록
        func setupSocketEventListeners(_ namespace: String) {
            guard let manager else { return }
            socket = manager.socket(forNamespace: "/chats-\(namespace)")
            guard let socket else { return }
            
            socket.on(clientEvent: .connect) { data, ack in
                print("SOCKET IS CONNECTED", data, ack)
            }
            
            socket.on(clientEvent: .disconnect) { data, ack in
                print("SOCKET IS DISCONNECTED", data, ack)
            }
            
            socket.on("chat") { [weak self] dataArray, ack in
                guard let self else { return }
                print("chat received")
                
                if let data = dataArray.first {
                    
                    do {
                        let result = try JSONSerialization.data(withJSONObject: data)
                        let decodedData = try JSONDecoder().decode(Chat.self, from: result)
                        ReceivedChatDataSubject.onNext(decodedData)
                    } catch {
                        print("Chatting Recevied Parsing Error", error.localizedDescription)
                    }
                }
            }
        }

        // 소켓 연결
        func establishConnection() {
            socket?.connect()
        }

        // 소켓 연결 해제
        func leaveConnection() {
            socket?.disconnect()
        }

        // 소켓 이벤트 인스턴스 제거
        func removeAllEventHandlers() {
            print("Clear up all handlers.")
            print("socket handler count", socket?.handlers.count)
            socket?.removeAllHandlers()
        }
    }
  ```
  
  </div>
  </details>

- 프로젝트 내 채팅 소켓 처리 과정

    - 채팅 내역 조회 과정
        
        1. 채팅화면 진입 후, Local DB(Realm)에서 저장된 채팅 내역 조회
        
        2. 가장 마지막 날짜에 전송된 채팅 날짜를 서버에 요청
        
        3. 요청 후, 새로운 데이터(채팅 마지막 내역 이후 작성된 채팅 내역)이 있다면 DB에 저장 후, 채팅 화면(TableView) 갱신
        
        4. 모든 과정이 끝난 이후 , 소켓 연결
        
        |<img src="https://github.com/constdreamcoder/SwiftPrac/assets/95998675/b5a4c574-e5e9-4c5c-a903-9720e55ff4a0" align="center" width="200"/>|
        |:--:|
        |채팅 조회|

    <br/>

    - 채팅 발송 및 수신 과정
        
        - 채팅 송신
            
            1. HTTP 통신을 통해 채팅 내용 서버로 전송
            
            2. 서버에서 전송된 채팅 내용을 소켓 통신을 통해 수신
        
        - 채팅 발신
            
            1. 서버로부터 상대방이 송신한 채팅 내역 소켓 통신을 통해 수신

        |<img src="https://github.com/constdreamcoder/SwiftPrac/assets/95998675/75f3e89d-50eb-4c5c-a4b8-fbdb18ad1b56" align="center" width="400"/>|
        |:--:|
        |채팅 송수신 동작 화면|

<br/>

### 8. Header를 이용한 이미지 다운로드

- Header를 이미지 다운로드를 위해 Kingfisher Extension에 커스텀 메서드 구성
  
  <details>
  <summary><b>Kingfisher 커스텀 메서드 구성 코드</b></summary>
  <div markdown="1">

  ```swift
  extension KingfisherWrapper where Base: UIImageView {
    func setImageWithAuthHeaders(
        with resource: Resource?,
        placeholder: Placeholder? = nil,
        options: KingfisherOptionsInfo? = nil,
        progressBlock: DownloadProgressBlock? = nil,
        completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil
    ) {
            // Header 추가를 위한 URLRequest 구성
            let imageDownloadRequest = AnyModifier { request in
                var requestBody = request
                requestBody.setValue(UserDefaultsManager.accessToken, forHTTPHeaderField: HTTPHeader.authorization.rawValue)
                requestBody.setValue(APIKeys.sesacKey, forHTTPHeaderField: HTTPHeader.sesacKey.rawValue)
                return requestBody
            }
        
            // 이미지 다운로드를 위한 옵션 구성
            let newOptions: KingfisherOptionsInfo = options ?? [] + [.requestModifier(imageDownloadRequest), .cacheMemoryOnly]
            
            self.setImage(
                with: resource,
                placeholder: placeholder,
                options: newOptions,
                progressBlock: progressBlock,
                completionHandler: completionHandler
            )
        }
    }

  ```
  
  </div>
  </details>

<br/>

### 9.  Resizable Image을 이용한 채팅 말풍선 구현

<br/>

### 10. Custom View로 구성

- 공통적인 UI 요소들 Custom View로 정의하여 재활용

<img src="https://github.com/constdreamcoder/SwiftPrac/assets/95998675/e072eeca-03bb-4448-b64a-96cb0e9dd135" align="center" width= "200"/>

<br/>

### 11. Input/Output 패턴 프로토콜로 추상화

- Input/Output 패턴 프로토콜로 추상화
  <details>
  <summary><b>Input/Output 패턴 추상화 코드</b></summary>
  <div markdown="1">

  ```swift
  protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
  }
  ```
  
  </div>
  </details> 
  
<br/> 

## 트러블 슈팅

### 1. Dynamic Island로 인한 기기별 Layout 차이 대응

문제상황

- UICollectionViewFlowLayout으로 Layout 구성 시 각 Cell마다 하단에 약간의 오차 발생하여 스크롤할 때마다 Cell이 화면에서 오차만큼 올라가는 현상 발생

  <details>
  <summary><b>UICollectionViewFlowLayout로 구성했던 코드</b></summary>
  <div markdown="1">

  ```swift
  func createCollectionViewLayout() -> UICollectionViewLayout {
      let layout = UICollectionViewFlowLayout()
      let width = UIScreen.main.bounds.width
      
      // Safe Area Inset 상단 높이 구하기
      let scenes = UIApplication.shared.connectedScenes
      let windowScene = scenes.first as? UIWindowScene
      let window = windowScene?.windows.first
      let topPadding = window?.safeAreaInsets.top ?? 0
      
      // NavigationBar 높이 구하기
      let navBarHeight = navigationController?.navigationBar.bounds.height ?? 0
      
      // TabBar 높이 구하기
      let tabBarHeight = tabBarController?.tabBar.bounds.height ?? 0
      
      // 기기 화면 크기에서 Safe Area Inset 상단, NavigationBar 높이, TabBar 높이만큼 각각 빼어주어 Cell 높이 정의
      let height = UIScreen.main.bounds.height - (topPadding + navBarHeight + tabBarHeight)
      layout.itemSize = CGSize(width: width, height: height)
      layout.minimumLineSpacing = 0
      layout.minimumInteritemSpacing = 0
      layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      
      return layout
  }
  ```
  
  </div>
  </details>

  <img src="https://github.com/constdreamcoder/SwiftPrac/assets/95998675/c19de329-e9d6-4872-b470-0207ab9b9b46" align="center" width="200"/>

<br/>

문제 원인 파악

<img src="https://github.com/constdreamcoder/SwiftPrac/assets/95998675/7c220f44-36a3-4f5e-a3ca-761f26bf7786" align="center" width="500"/>

- iPhone 14 Pro부터 도입된 Dynamic Island로 인해 Status bar의 높이와 Safe Area Insets의 top에서 차이가 발생하여 홈 화면 피드 구성 시 Collection View Layout으로는 오차가 항상 발생하였던 것
    - **Status bar(상태 표시줄)의 높이는 54포인트**
    - **Safe Area Insets (portrait): top: 59, bottom: 34, left: 0, right: 0**

해결방법

- Modern CollectionView인 UICollectionViewCompositionalLayout으로 대응

  <details>
  <summary><b>UICollectionViewCompositionalLayout으로 대응</b></summary>
  <div markdown="1">

  ```swift
  extension HomeViewController: UICollectionViewConfiguration {
        func createCollectionViewLayout() -> UICollectionViewLayout {
        
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            
            return UICollectionViewCompositionalLayout(section: section)
        }
    }
  ```
  
  </div>
  </details>
  
<br/>

### 2. RxDataSource 활용한 여러 타입의 Section 구현

문제상황

- 다중 타입의 Section 정의한 후, dataSource를 구성할 때 각 Section의 공통 타입인 SectionModelType을 dataSource의 제네릭 타입으로 사용 불가

<img src="https://github.com/constdreamcoder/SwiftPrac/assets/95998675/3061940f-41aa-4262-8c7e-314fd2ec05c4" align="center"/>

<br/>

문제 원인 파악

- SectionTypeModel의 경우, Associated Type으로 구성되어져 있는 프로토콜이기 때문에, Item의 타입이 구체적이지 않아 컴파일 시 변수의 할당 크기 등을 결정할 수 없어 컴파일 오류가 발생한 것
  <details>
  <summary><b>SectionModelType 프로토콜 정의</b></summary>
  <div markdown="1">

  ```swift
  public protocol SectionModelType {
    associatedtype Item

    var items: [Item] { get }

    init(original: Self, items: [Item])
  }
  ```

  </div>
  </details>

해결방법 - Type Erasure Wrapper

- 기존 Section 클래스를 감싸는 Type Erasure Wrapper 클래스를 만들어서 기존 타입을 없앤 후, Section 구성
    <details>
    <summary><b>Type Erasure Wrapper</b></summary>
    <div markdown="1">

    ```swift
    import RxDataSources

    class AnySectionModel: SectionModelType {
        var items: [Item]
        
        init<S: SectionModelType>(_ sectionModel: S) {
            self.items = sectionModel.items
        }
        
        required init(original: AnySectionModel, items: [Item]) {
            self.items = items
        }
    }

    extension AnySectionModel {
        typealias Item = Any
    }
    ```

    </div>
    </details>
    
<br/>
   
### 3. 소켓 이벤트 인스턴스의 축적

문제상황

- 채팅화면에서 나갈 때, 소켓 연결이 해제됨과 동시에 Socket 이벤트 인스턴스들이 해제되지 않고 축적되는 현상 발생
    
    <img src="https://github.com/constdreamcoder/SwiftPrac/assets/95998675/8cbfde01-4d39-430e-967c-5003819f5fc1">
    
    <img src="https://github.com/constdreamcoder/SwiftPrac/assets/95998675/5739a145-8b68-41bf-869c-e2a15863a723">
    
    <img src="https://github.com/constdreamcoder/SwiftPrac/assets/95998675/90c8ebcf-9b27-40d1-a684-754e3f0bd81c">
    

문제 원인 파악

- 소켓 연결 해제와 동시에 모든 이벤트 인스턴스들이 삭제되지 않아 남아 있음

해결방법

- 소켓 연결 해제와 동시에 모든 이벤트 인스턴스들을 삭제해줌으로써 문제 해결
    <details>
    <summary><b>소켓 이벤트 인스턴스 삭제 코드</b></summary>
    <div markdown="1">

    ```swift
    func removeAllEventHandlers() {
        print("Clear up all handlers.")
        print("socket handler count", socket?.handlers.count)
        socket?.removeAllHandlers() // 소켓 이벤트 인스턴스 삭제
    }
    ```

    </div>
    </details>
