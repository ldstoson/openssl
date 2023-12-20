REM -----------------------------------------------------------------------------------
REM (방법2-성공) Root CA 없이 서버(도메인) openssl 로 개인 키와 인증서를 직접 한 번에 만들기

del openssl.asianaidt.com.*

openssl req -newkey rsa:2048 -noenc -keyout openssl.asianaidt.com.key -keyform PEM -x509 -sha256 -out openssl.asianaidt.com.crt -outform PEM -days 365 -config openssl_with_san.cnf -section req -extensions v3_req -verbose

xcopy openssl.asianaidt.com.key C:\OpenSSLEdu\bin\apache-tomcat-10.1.17\conf\ /Y
xcopy openssl.asianaidt.com.crt C:\OpenSSLEdu\bin\apache-tomcat-10.1.17\conf\ /Y
