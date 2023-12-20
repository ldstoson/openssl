REM -----------------------------------------------------------------------------------
REM (방법3-성공) Root CA 없이 keytool 로 서버(단일 도메인) 개인키와 인증서를 키 저장소 안에 직접 한 번에 만들기
REM (주의) 이 방법으로 만들면 키 파일을 확보할 수 없어 Spring Boot API App은 서비스할 수 있다.

del keystore.p12

keytool -genkeypair -alias openssl.asianaidt.com -keyalg RSA -keysize 2048 -storetype PKCS12 -keystore keystore.p12 -validity 365 -keypass "openssledu" -storepass "openssledu" -dname "CN=openssl.asianaidt.com, C=KR" -ext "SAN=DNS:openssl.asianaidt.com" -ext "KeyUsage=nonRepudiation,digitalSignature,keyEncipherment" -ext "ExtendedKeyUsage=serverAuth"

xcopy keystore.p12 C:\OpenSSLEdu\bin\apache-tomcat-10.1.17\conf\ /Y
