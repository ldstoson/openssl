REM 목표 : 자체서명 SSL/TLS 인증서 생성
REM ----------------------------------------------------------------------------------
REM 환경 : 
REM 	openssl 3.2.0 이 설치된 Windows x64 환경에서 실행한다.(Linux 환경이나 다른 버전일 경우에는 일부 명령을 수정해야 할 수 있다.)
REM 	openssl version : OpenSSL 3.2.0 23 Nov 2023 (Library: OpenSSL 3.2.0 23 Nov 2023)
REM ----------------------------------------------------------------------------------


REM -----------------------------------------------------------------------------------
REM (방법1-성공) openssl로 Root CA 없이 서버(도메인)  인증서 만들기

echo 1 ----- delete existing file ----- 
del openssl.asianaidt.com.*

echo 2 ----- generate private key -----
openssl genrsa -out openssl.asianaidt.com.key -verbose 2048

echo 3 ----- generate site certificate -----
REM (주의) 주체 대체 이름 정보가 없어 https  서비스 불가 예시
REM openssl req -new -x509 -sha256 -key openssl.asianaidt.com.key -out openssl.asianaidt.com.crt -days 365 -config openssl_without_san.cnf -section req -extensions v3_req -verbose

REM 주체 대체 이름 정보가 있어 https  서비스 정상 예시
openssl req -new -x509 -sha256 -key openssl.asianaidt.com.key -out openssl.asianaidt.com.crt -days 365 -config openssl_with_san.cnf -section req -extensions v3_req -verbose

REM (주의)아래와 같이 -section req -extensions v3_req 를 생략하면 주체 대체 이름이 설정되지 않는다
REM openssl req -new -x509 -sha256 -key openssl.asianaidt.com.key -out openssl.asianaidt.com.crt -days 365 -config openssl_with_san.cnf -verbose


echo 4 ----- display certificate info -----
openssl x509 -in openssl.asianaidt.com.crt
openssl x509 -in openssl.asianaidt.com.crt -text
openssl x509 -in openssl.asianaidt.com.crt -text -noout
openssl x509 -in openssl.asianaidt.com.crt -dates -noout
openssl x509 -in openssl.asianaidt.com.crt -pubkey -noout
openssl x509 -in openssl.asianaidt.com.crt -subject -noout

echo 5 ----- verify certificate  ----- 
openssl verify openssl.asianaidt.com.crt


echo 7 ----- copy private key, certificate file  -----
xcopy openssl.asianaidt.com.key C:\OpenSSLEdu\bin\apache-tomcat-10.1.17\conf\ /Y
xcopy openssl.asianaidt.com.crt C:\OpenSSLEdu\bin\apache-tomcat-10.1.17\conf\ /Y

xcopy keystore.p12 C:\OpenSSLEdu\bin\apache-tomcat-10.1.17\conf\ /Y
REM ----------------------------------------------------------------------------------