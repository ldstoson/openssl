REM ----------------------------------------------------------------------------------
REM 단일 도메인용 인증서와 방법은 동일하고 openssl.cnf 파일에 subjectAltName extention 섹션을 포함하는 것만 다르다

openssl genrsa -out openssl.asianaidt.com.key -verbose 2048

openssl req -new -x509 -sha256 -key openssl.asianaidt.com.key -out openssl.asianaidt.com.crt -days 365 -config openssl.cnf -section req -extensions v3_req -verbose

xcopy openssl.asianaidt.com.key C:\OpenSSLEdu\bin\apache-tomcat-10.1.17\conf\ /Y
xcopy openssl.asianaidt.com.crt C:\OpenSSLEdu\bin\apache-tomcat-10.1.17\conf\ /Y

REM ----------------------------------------------------------------------------------
