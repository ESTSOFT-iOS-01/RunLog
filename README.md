<div align=center>

# RunLog
** 야외 운동 시 거리와 걸음수를 측정하고 기록을 공유하여 재미를 더하는 서비스 **
사용자의 야외 운동 데이터를 기반으로 거리, 걸음 수를 측정하고 경로를 시각적으로 표현해줍니다. 나아가, 이 기록을 바탕으로 무빙트랙 영상까지 자동 생성해 누구나 쉽게 공유하고 재미를 느낄 수 있는 서비스입니다.

[📑 RunLog FigJam 📑](https://www.figma.com/board/zYmssJJqQJ7GctcqUV3Jo4/%EB%B8%8C%EB%A0%88%EC%9D%B8%EC%8A%A4%ED%86%A0%EB%B0%8D?node-id=64-408&t=b1natT9ZZemZOsmq-0)


## 🍎 Developers
<img width="160px" src="https://avatars.githubusercontent.com/u/68256612?v=4"/> | <img width="160px" src="https://avatars.githubusercontent.com/u/80318425?v=4"/> | <img width="160px" src="https://avatars.githubusercontent.com/u/132960058?v=4"/> | <img width="160px" src="https://avatars.githubusercontent.com/u/55975937?v=4"/> |
|:-----:|:-----:|:-----:|:-----:|
|[신승재](https://github.com/Monfi98) | [김도연](https://github.com/doyeonk429) | [도민준](https://github.com/aado97) | [심근웅](https://github.com/GeunwoongSim) |
|팀장 👑|팀원 👨🏻‍💻|팀원 👨🏻‍💻|팀원 👨🏻‍💻|
|`로그 캘린더`</br>`로그 타임라인` | `마이페이지` </br> `로그 수정` | `상세 로그 조회` </br> `무빙 트랙` | `홈 화면` </br> `실시간 운동 정보`|
</div>
<br/>

## 🎥 주요 기능 시연 영상

<table>
  <tr>
    <td align="center">타이머</td>
    <td align="center">통계</td>
    <td align="center">투두리스트</td>
    <td align="center">세팅</td>
  </tr>
  <tr>
    <td>
      <img src="" width="200">
    </td>
    <td>
      <img src="" width="200">
    </td>
    <td>
      <img src="" width="200">
    </td>
    <td>
      <img src="" width="200">
    </td>
  </tr>
</table>

## 🛠️ Development Environment 🛠️
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)
![Xcode](https://img.shields.io/badge/Xcode-007ACC?style=for-the-badge&logo=Xcode&logoColor=white)

## 🥞 Stacks 🥞
| Name          | Description   |
| ------------  | ------------- |
| <img src="https://img.shields.io/badge/Swift-F05138?style=flat&logo=Swift&logoColor=white"> | iOS 앱의 UI를 구축하고 사용자 인터페이스를 관리하는 기본 프레임워크.|
| <img src="https://img.shields.io/badge/-Git-F05032?style=flat&logo=git&logoColor=white"> | 분산 버전 관리 시스템으로, 코드 히스토리 관리와 협업을 효율적으로 지원.|
| <img src="https://img.shields.io/badge/-Notion-000000?style=flat&logo=notion&logoColor=white"> | 작업 관리 및 문서화를 위한 통합 협업 도구.|
| <img src="https://img.shields.io/badge/-figma-5856D6?style=flat&logo=figma&logoColor=white"> | 피그마 |
| <img src="https://img.shields.io/badge/Swift-252323?style=flat&logo=Swift&logoColor=white"> | iOS 로컬 데이터 관리를 위한 DB 프레임워크.|

## 💻 Convention 💻

## 🌲 Branch Convention 🌲
1. **기본 브랜치 설정**
- main : 배포 가능한 안정적인 코드가 유지되는 브랜치
- develop: 기본 브랜치로, 기능을 개발하는 브랜치

2. **작업 순서**
   1. 작업할 이슈 작성
   2. 적합한 Assignees, Label, Project, Milestone 할당
   3. **자동 생성 브랜치에서 작업 수행**
   4. **원격 저장소에 작업 브랜치 푸시**
   5. **Pull Request 생성**
   - `develop` 브랜치 대상으로 Pull Request 생성
   - 리뷰어의 리뷰를 받은 후 PR을 승인 받고 `develop` 브랜치에 자동 병합


## 🧑‍💻 Code Convention 🧑‍💻
**저희는 Swift Style Guide을 따릅니다.**
[StyleShare](https://github.com/StyleShare/swift-style-guide?tab=readme-ov-file#%EB%93%A4%EC%97%AC%EC%93%B0%EA%B8%B0-%EB%B0%8F-%EB%9D%84%EC%96%B4%EC%93%B0%EA%B8%B0)

**네이밍 규칙**

- **변수/상수**: 카멜케이스 (예: `userName`)
- **클래스/구조체**: 파스칼케이스 (예: `UserProfile`)
- **함수/메서드**: 동사로 시작하며 카멜케이스 (예: `fetchData()`)

 **코드 스타일**

- **명시적 타입 선언**: 가능하면 타입 명시 (예: `var name : String = “name”`)
- **옵셔널 처리**: `guard`나 `if let`을 사용하여 안전하게 언래핑
- **함수 파라미터**: 간결하고 직관적인 이름 사용
---
## 💬 Issue Convention 💬
> 모든 이슈에 대한 템플릿
```
## 💡 Issue
<!-- 이슈에 대해 간단하게 설명해 주세요 -->

## 🔥 Tasks
<!-- 해야 할 작업들을 나열해 주세요 -->
```
---
## 🫷 PR Convention 🫸
```markdown
<!-- PR 제목 컨벤션: [이슈 라벨] 작업한 내용 요약 -->

## 💡 PR 유형
<!-- 해당하는 유형에 "x"를 입력하세요. -->
- [ ] Feature: 기능 추가
- [ ] Hotfix: 작은 버그 수정
- [ ] Bugfix: 큰 버그 수정
- [ ] Refactor: 코드 개선
- [ ] Chore: 환경 설정

## ✏️ 변경 사항
<!-- 이 PR에서 작업한 내용을 간단히 요약해주세요. -->

## 🚨 관련 이슈
<!-- 관련된 이슈 번호를 적어주세요. 여러 개인 경우 쉼표로 구분하세요. -->
- close #

## 🧪 테스트
<!-- 이 PR에서 테스트한 내용을 설명해주세요. -->
- [ ] 목표한 구현 정상 동작 확인

## 🎨 스크린샷
<!-- UI 변경사항이 있는 경우 스크린샷을 첨부해주세요. -->
<!-- img src "이부분에 gif파일 넣어주세요" -->
|기능|스크린샷|
|:--:|:--:|
|GIF|<img src = "" width ="250">|

## ✅ 체크리스트
<!-- 꼭 모두 체크하고 PR을 생성해주세요. -->
- [ ] 코드/커밋이 정해진 컨벤션을 잘 따르고 있나요?
- [ ] PR의 Assignees와 Reviewers를 설정했나요?
- [ ] 불필요한 코드가 없고, 정상적으로 동작하는지 확인했나요?
- [ ] 관련 이슈 번호를 작성했나요?

## 🔥 추가 설명
<!-- 리뷰어가 알아야 할 추가적인 정보가 있다면 여기에 적어주세요. -->
<!-- 코드 리뷰를 받고 싶은 코드나, 설명하고 싶은 코드가 있다면 적어주세요. -->
```
---
## 🙏 Commit Convention 🙏

- `feature` : 새로운 기능이 추가되는 경우
- `docs` :  문서에 변경 사항이 있는 경우
- `refactor` : 코드 리팩토링하는 경우 (기능 변경 없이 구조 개선)

```swift
// Format
[#Issue Number]: [Description]

// Example
[feature]: 로그인 기능 구현
```
---
## 📁 Foldering Convention 📁
```markdown
📦 RunLog
```
