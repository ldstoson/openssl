## 목표 : SSL/TLS Server용  인증서 생성을 위한 Root CA용 개인키/인증서 생성
## 참고 : https://www.openssl.org/docs/man3.0/man1/
## 참고 : https://www.baeldung.com/openssl-self-signed-cert
## 참고 : https://www.ibm.com/docs/en/hpvs/1.2.x?topic=servers-creating-ca-signed-certificates-monitoring-infrastructure
## 참고 : https://www.ibm.com/docs/en/hpvs/1.2.x?topic=reference-openssl-configuration-examples
## 참고 : https://gist.github.com/fntlnz/cf14feb5a46b2eda428e000157447309
## ----------------------------------------------------------------------------------
## openssl 3.0.7 이 설치된 Windows 환경에서 실행한다.(Linux 환경이나 다른 버전일 경우에는 일부 명령을 수정해야 할 수 있다.)
## openssl version : OpenSSL 3.0.7 1 Nov 2022 (Library: OpenSSL 3.0.7 1 Nov 2022)
## ----------------------------------------------------------------------------------



echo 0 ----- 비밀번호 환경변수 설정 -----
echo 1 ----- 기존 파일 일관 삭제 -----
echo 2 ----- 개인키 생성
echo 3 ----- CSR 생성 ----- 
echo 4 ----- 자체서명 인증서 생성 ----- 
echo 5 ----- 인증서 정보 조회 ----- 
echo 6 ----- 인증서 검증 ----- 

set pass=openssledu
del /q RootCA.*
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -out RootCA.key -outform PEM -pass pass:%pass% 
openssl req -new -sha256 -noenc -key RootCA.key -out RootCA.csr -outform PEM -config openssl.cnf -section req -verbose -verify
openssl x509 -req -sha256 -in RootCA.csr -inform PEM -signkey RootCA.key -keyform PEM -out RootCA.crt -outform PEM -extfile openssl.cnf -extensions v3_ca -days 365
openssl x509 -in RootCA.crt -text -noout
openssl verify RootCA.crt


## (참고)개인키와 CSR을 동시에 만들려면 아래와 같이 명령 축약 가능
## openssl req -newkey rsa:4096 -noenc -keyout RootCA.key -keyform PEM -out RootCA.csr -outform PEM -config openssl.cnf -section req -verbose -verify
## ----------------------------------------------------------------------------------
