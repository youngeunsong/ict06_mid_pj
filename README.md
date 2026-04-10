# ict06_mid_pj (맛침내)
ICT06 1팀의 중간 팀 프로젝트 '맛침내' 깃허브 저장소.
깃허브에 업로드되지 않은 보안 관련 사항은 공유 구글 드라이브 및 노션 문서를 확인해주세요.

- [ict06_mid_pj (맛침내)](#ict06-mid-pj------)
  * [프로젝트 첫 설치 및 실행 가이드](#------------------)
    + [사용 소프트웨어 및 버전](#-------------)
    + [프로젝트 실행 단계](#----------)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>


## 프로젝트 첫 설치 및 실행 가이드

### 사용 소프트웨어 및 버전
프로젝트 실행에 앞서 아래와 같은 버전의 프로그램을 설치해주세요. 
- DBeaver : dbeaver-ce-25.3.1-x86_64-setup.exe
- STS3: sts-3.9.18
- Oracle: OracleXE112_Win64
- java: jdk-11.0.29_windows-x64_bin.exe
- Tomcat : apache-tomcat-9.0.113-windows-x64
- Git: Git-2.53.0-64-bit
- Python : python-3.14.3-amd64

### 프로젝트 실행 단계
1. **깃 클론** 
`D:\DEV06\workspace_git_ict06` 에서 마우스 우클릭 
-> Open git bash here 
-> `git clone https://github.com/youngeunsong/ict06_mid_pj.git`
    실행하면 ict06_mid_pj 폴더 생성됨.

1. **DB 계정 생성**
 DBeaver에서 아래 쿼리 실행

    ```sql
    -- System 계정에서 실행
    -- 2. 계정생성(ict06_team1_midpj) 및 테이블생성
    --******************* 일반 계정 생성 =>[시스템계정(System)에서 작업 ***********
    --- 1. 계정생성
    -- create user <계정이름> identified by <계정암호> default tablespace users;
    create user ict06_team1_midpj identified by 비밀번호 default tablespace users;
    -- 2. 사용자 권한 부여
    grant connect, resource to ict06_team1_midpj;
    grant create view to ict06_team1_midpj;

    - - grant connect, resource,create view to ict06_team1_midpj;

    -- 3. 락 해제
    -- alter user <계정이름> account unlock;
    alter user ict06_team1_midpj account unlock;

    -- 실행결과
    --ict06_team1_midpj이(가) 생성되었습니다.
    --Grant을(를) 성공했습니다.
    --ict06_team1_midpj이(가) 변경되었습니다.
    ```

1. **커넥션풀 추가** 
STS3 > Servers > Tomcat v9.0 Server at localhost-config > context.xml에 다음 내용 추가
    ```xml
    <Resource
    author="Container"
    driverClassName="oracle.jdbc.driver.OracleDriver"
    maxActive="7"
    maxWait="1000"
    name="jdbc/ict06_team1_midpj"
    username="ict06_team1_midpj"
    password="tiger"
    type="javax.sql.DataSource"
    url="jdbc:oracle:thin:@서버컴퓨터Ipv4주소:1521:xe" />
    ```
1. **STS3로 프로젝트 열기**
    - STS3 실행 시 워크스페이스 workspace_spring_ict06 로 런치
    - File > Open Project from File System > Directory : `D:\DEV06\workspace_git_ict06\ict06_mid_pj` 로 설정 (혹은 git clone한 프로젝트가 있는 폴더의 경로)
    - ict06_mid_pj 프로젝트가 임포트됨.  
  
1. **프로젝트 Properties 변경**
    프로젝트를 clone/pull 해 올 때 마다 아래 사항을 확인해주세요. 
    1. ict06_mid_pj 프로젝트명 우클릭 > Properties
    2. Java build path: JRE System Library Edit .. > Workspace default JRE(jdk-11) > Finish > Apply
    3. Java Compiler > JDK Compliance의 드롭박스에서 11 선택 > Apply
    4. Project Facets > Java > 11로 수정, Runtimes > Apache Tomcat v9.0 선택됐는지 확인 > Apply
        - 체크 박스에서 체크 표시: java, javaScript, Dynamic web modules
        ![project_facets](readme_images\project_facets.png)
1. **DEV 브랜치로 전환** 
    D:\DEV06\workspace_git_ict06\ict06_mid_pj 안에서 git bash 실행. 
    -> 내 작업 영역에 원격 dev 브랜치를 동기화
    ```bash
    git checkout -b dev origin/dev # dev 브랜치 생성 및 이동, origin/dev를 내 로컬 dev 브랜치에 동기화
    ```
1. **API 키 다운로드**
    1. 공유드라이브에서 ‘기타’ 폴더 다운로드 (자세한 사항은 노션 문서 참고해주세요)
    1. 압축 해제 후 ‘기타’ 폴더를 C:\DEV06 안으로 옮기기
        - 아래와 같은 구조로 폴더가 위치해야 합니다. 
        ```
        C:/
            ㄴDEV06
                ㄴ기타
                    ㄴsecret 
                        ...
        ```
1. **⚠️application.properties, servlet-context.xml, root-contex.xml의 이미지 업로드 폴더 경로 설정** 
    각 파일의 이미지 업로드 폴더 경로 관련 부분을 프로젝트 설치환경에 맞게 수정해주세요. 
    - 작성 예시
    src/main/resources/application.properties
    ```
    upload.notice.path=C:/DEV06/workspace_git/ex05_member/ict06_mid_pj/upload/notice/
    upload.community.path=C:/DEV06/workspace_git/ex05_member/ict06_mid_pj/upload/community/
    upload.restaurant.path=C:/DEV06/workspace_git/ex05_member/ict06_mid_pj/src/main/webapp/resources/images/admin/restaurant/
    upload.accommodation.path=C:/DEV06/workspace_git/ex05_member/ict06_mid_pj/src/main/webapp/resources/images/admin/accommodation/
    ```

    src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml
    ```xml
    <!-- 외부 업로드 경로 매핑 (톰캣 재배포 유실 방지) -->
	<resources mapping="/upload_community/**" location="file:///C:/DEV06/workspace_git/ex05_member/ict06_mid_pj/upload/community/" />
	<resources mapping="/upload_notice/**" location="file:///C:/DEV06/workspace_git/ex05_member/ict06_mid_pj/upload/notice/" />
	<resources mapping="/upload_restaurant/**" location="file:///C:/DEV06/workspace_git/ex05_member/ict06_mid_pj/src/main/webapp/resources/images/admin/restaurant/" />
	<resources mapping="/upload_accommodation/**" location="file:///C:/DEV06/workspace_git/ex05_member/ict06_mid_pj/src/main/webapp/resources/images/admin/accommodation/" />
    ```

    src/main/webapp/WEB-INF/spring/root-context.xml





