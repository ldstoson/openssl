## 목표 : Tomcat을 https 로 서비스 하기 위한 자체서명 SSL/TLS 인증서 생성
##       단일 도메인(멀티도메인)용 자체서명 키와 인증서 파일 생성
## 참고 : 
##	https://www.baeldung.com/openssl-self-signed-cert
##  https://gist.github.com/fntlnz/cf14feb5a46b2eda428e000157447309
## ----------------------------------------------------------------------------------
## 환경 : 
## 	openssl 3.2.0 이 설치된 Windows x64 환경에서 실행한다.(Linux 환경이나 다른 버전일 경우에는 일부 명령을 수정해야 할 수 있다.)
## 	openssl version : OpenSSL 3.2.0 23 Nov 2023 (Library: OpenSSL 3.2.0 23 Nov 2023)
## ----------------------------------------------------------------------------------


## -----------------------------------------------------------------------------------
## (방법1-성공) openssl로 Root CA 없이 서버(도메인)  인증서 만들기

echo 1 ----- 기존 파일 일괄 삭제 ----- 
del openssl.asianaidt.com.*

echo 2 ----- RSA 개인키 생성 -----
openssl genrsa -out openssl.asianaidt.com.key -verbose 2048

echo 3 ----- 자체 서명 인증서 생성 -----
openssl req -new -x509 -sha256 -key openssl.asianaidt.com.key -out openssl.asianaidt.com.crt -days 365 -config openssl_without_san.cnf -section req -extensions v3_req -verbose
openssl req -new -x509 -sha256 -key openssl.asianaidt.com.key -out openssl.asianaidt.com.crt -days 365 -config openssl_with_san.cnf -section req -extensions v3_req -verbose

# (주의)아래와 같이 -section req -extensions v3_req 를 생략하면 주체 대체 이름이 설정되지 않는다
# openssl req -new -x509 -sha256 -key openssl.asianaidt.com.key -out openssl.asianaidt.com.crt -days 365 -config openssl_with_san.cnf -verbose


echo 4 ----- 인증서 정보 확인하기 -----
openssl x509 -in openssl.asianaidt.com.crt
openssl x509 -in openssl.asianaidt.com.crt -text
openssl x509 -in openssl.asianaidt.com.crt -text -noout
openssl x509 -in openssl.asianaidt.com.crt -dates -noout
openssl x509 -in openssl.asianaidt.com.crt -pubkey -noout
openssl x509 -in openssl.asianaidt.com.crt -subject -noout

echo 5 ----- 인증서 검증 ----- 
openssl verify openssl.asianaidt.com.crt


echo 7 ----- 키/인증서를 %TOMCAT_HOME%\conf 에 복사 -----
xcopy openssl.asianaidt.com.key C:\OpenSSLEdu\bin\apache-tomcat-10.1.17\conf\ /Y
xcopy openssl.asianaidt.com.crt C:\OpenSSLEdu\bin\apache-tomcat-10.1.17\conf\ /Y
xcopy keystore.p12 C:\OpenSSLEdu\bin\apache-tomcat-10.1.17\conf\ /Y
## ----------------------------------------------------------------------------------

## -----------------------------------------------------------------------------------
## (방법2-성공) Root CA 없이 서버(도메인) openssl 로 키와 인증서를 직접 한 번에 만들기
## (참고)개인키와 인증서를 동시에 만들려면 아래와 같이 명령 축약 가능
openssl req -newkey rsa:2048 -noenc -keyout openssl.asianaidt.com.key -keyform PEM -x509 -sha256 -out openssl.asianaidt.com.crt -outform PEM -days 365 -config openssl_with_san.cnf -section req -extensions v3_req -verbose



## -----------------------------------------------------------------------------------
## (방법3-성공) Root CA 없이 서버(도메인) keytool 로 키쌍을 키 저장소 안에 직접 한 번에 만들기
## 이 방법으로 만들면 키 파일을 확보할 수 없어 Spring Boot API App은 서비스할 수 있다.
## 참고 : https://www.baeldung.com/spring-boot-https-self-signed-certificate
## 1 pkcs12 키 저장소 내에 개인키와 인증서 쌍을 직접 만들기
keytool -genkeypair -alias openssl.asianaidt.com -keyalg RSA -keysize 2048 -storetype PKCS12 -keystore keystore.p12 -validity 365 -keypass "openssledu" -storepass "openssledu" -dname "CN=openssl.asianaidt.com, C=KR" -ext "SAN=DNS:openssl.asianaidt.com" -ext "KeyUsage=nonRepudiation,digitalSignature,keyEncipherment" -ext "ExtendedKeyUsage=serverAuth"

## 2 키 저장소 복사
xcopy keystore.p12 C:\OpenSSLEdu\bin\apache-tomcat-10.1.17\conf\ /Y

## 3 키 저장소 조회
keytool -list -keystore keystore.p12 -storepass openssledu

## 4 인증서 파일 추출
keytool -exportcert -alias openssl.asianaidt.com -keystore keystore.p12 -file openssl.asianaidt.com.crt -storepass openssledu
# ----------------------------------------------------------------------------------
