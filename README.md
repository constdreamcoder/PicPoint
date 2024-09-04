# PicPoint - 사진 스팟 공유 앱

<p>
    <img src="https://github.com/constdreamcoder/SwiftPrac/assets/95998675/b854d0e1-0e53-446f-901d-05eb958de02e" align="center" width="100%"/>
</p>

<br/>

## PicPoint

- 서비스 소개: 자신만의 사진 스팟 공유 앱
- 개발 인원: 1인
- 개발 기간: 24.04.12 ~ 24.05.05(총 24일)
- 개발 환경
  - 최소버전: iOS 16
  - Portrait Orientation 지원
  - 라이트 모드 지원

<br/>

## 💪 주요 기능

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
- 해시태그

<br/>

## 📱 동작 화면

|회원가입|로그인|로그아웃|회원탈퇴|
|:---:|:---:|:---:|:---:|
|<img src="https://github.com/user-attachments/assets/063466a0-06a3-446c-85cf-6995d3764ede" width="200" height="390"/>|<img src="https://github.com/user-attachments/assets/355ac4f8-db78-4fc9-be3d-9f377509533c" width="200" height="390"/>|<img src="https://github.com/user-attachments/assets/ba0bcba3-a00e-4411-aade-ddcc7d5d19b3" width="200" height="390"/>|<img src="https://github.com/user-attachments/assets/af6147ec-d543-4d94-9929-6123fc37f66f" width="200" height="390"/>|

|게시글 작성|게시글 조회|게시글 상세정보 조회|연관 게시글 추천|해시태크 게시글 검색|
|:---:|:---:|:---:|:---:|:---:|
|<img src="https://github.com/user-attachments/assets/3eb8d2db-5651-4308-8bd2-2855eed1f173" width="200" height="390"/>|<img src="https://github.com/user-attachments/assets/355ac4f8-db78-4fc9-be3d-9f377509533c" width="200" height="390"/>|<img src="https://github.com/user-attachments/assets/e03d6247-03b8-4717-b1d6-e60cd763a527" width="200" height="390"/>|<img src="https://github.com/user-attachments/assets/75001a00-bd16-4ccf-a58b-c5edd035e6b9" width="200" height="390"/>|<img src="https://github.com/user-attachments/assets/5913f9d1-4973-45df-ac1c-e330888d3853" width="200" height="390"/>|

|프로필 조회|프로필 수정|프로필 조회(지도)|유저 팔로우|유저 언팔로우|
|:---:|:---:|:---:|:---:|:---:|
|<img src="https://github.com/user-attachments/assets/1f4f50a6-ac41-4aed-a29e-6e59142e4ba5" width="200" height="390"/>|<img src="https://github.com/user-attachments/assets/b4d36194-3ede-4836-acbb-a507f00fdcbd" width="200" height="390"/>|<img src="https://github.com/user-attachments/assets/1ccdd9a2-ae12-4687-aafa-59d7b2fe082f" width="200" height="390"/>|<img src="https://github.com/user-attachments/assets/b2cc8df6-8b19-4270-8133-fa086eff8b8c" width="200" height="390"/>|<img src="https://github.com/user-attachments/assets/5743d602-5f08-4b12-8244-204fbc3275be" width="200" height="390"/>|

|DM 생성|채팅방 목록 조회|채팅|후원내역 조회|
|:---:|:---:|:---:|:---:|
|<img src="https://github.com/user-attachments/assets/05803ac6-fbad-4034-bb9f-52cd52385b3c" width="200" height="390"/>|<img src="https://github.com/user-attachments/assets/b04ab120-0cfb-44f0-9410-4f89851bac32" width="200" height="390"/>|<img src="https://github.com/user-attachments/assets/d93687dd-7e83-40ef-b38d-b7c7b135b39c" width="400" height="390"/>|<img src="https://github.com/user-attachments/assets/300bba66-f5c6-4b3c-acd5-5bda45db8d11" width="200" height="390"/>|

<br/>

## 🛠 기술 소개

- UIKit, RxSwift, SnapKit
- MVVM, Input/Output, Router, Repository Pattern
- Alamofire, Kingfisher, LocalizedError
- NWPathMonitor, IAMPort, SocketIO, Realm
- RxDatasoure, Modern CollectionView
- MapKit, PHAsset, Custom Property Wrapper

<br/>

## 💻 기술 적용

- **MVVM Input/Ouput** 패턴을 통한 View와 ViewModel간 책임 분리
- **URLRequestConvertible**를 준수하는 **Custom TargetType**을 이용한 네트워크 요청 로직 **Router** 패턴 구성
- **Multipart Form Data** 전송 방식을 통한 이미지 파일 업로드 구현
- 홈 화면에서 효율적인 대량 게시글 데이터 로드를 위한 **Cursor-Based Pagination** 구현
- **EventMonitor** 프로토콜 준수하는 이벤트 모니터 구성으로 네트워크 요청 및 응답을 위한 로깅 구현
- **Interceptor**를 활용한 토큰 갱신 로직 구성
- **NWPathMonitor**를 활용한 실시간 네트워크 연결 상태 모니터링 구성
- **Custom UICollectionViewLayout** 구성으로 핀터레스트 UI 구성
- **Resizable Image**를 활용한 말풍선 UI 구현
- **Type Erasure Wrapper**를 활용한 멀티 섹션 타입의 **CollectionView** 구성(**RxDatasource**)
- **UICollectionViewFlowLayout**을 활용하여 **Dynamic Island**로 인한 기기별 Layout 차이 대응

<br/>

## 💾 구현 내용

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

### 3. 커스텀 UICollectionViewLayout 구성으로 핀터레스트 UI 구현
        
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

### 4. Header를 이용한 이미지 다운로드

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

### 5.  Resizable Image을 이용한 채팅 말풍선 구현

[👉 Resiable Image 구현 블로그 링크](https://picelworld.tistory.com/51)

<details>
<summary><b>말풍선 구성 코드</b></summary>
<div markdown="1">

```swift
final class ChatBubbleImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        let image = UIImage(named: "messageBubble")
        let horizontalInset = (image?.size.width ?? 0.0) * 0.4
        let verticalInset = (image?.size.height ?? 0.0) * 0.4
        self.image = image?.resizableImage(
            withCapInsets: UIEdgeInsets(
                top: verticalInset,
                left: horizontalInset,
                bottom: verticalInset,
                right: horizontalInset),
            resizingMode: .stretch
        ).withRenderingMode(.alwaysTemplate)
    }
}
```

</div>
</details>


<br/>


## 🔥 트러블 슈팅

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



