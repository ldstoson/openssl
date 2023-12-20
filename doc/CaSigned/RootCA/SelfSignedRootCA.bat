REM ----------------------------------------------------------------------------------
REM 목표 : SSL/TLS Server용 인증서 생성을 위한 Root CA용 개인키/인증서 생성

@echo off
@echo 0 ----- set pass ----- 
@echo 1 ----- delete existing file ----- 
@echo 2 ----- generate root CA key -----
@echo 3 ----- generate root CA CSR -----
@echo 4 ----- generator root CA Certificate slf-signed -----
@echo 5 ----- display root CA Certificate -----
@echo 6 ----- display root CA Certificate ----- 


set pass=openssledu

del /q RootCA.*

openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -out RootCA.key -outform PEM -pass pass:%pass% 
REM openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -out RootCA.key -outform PEM -pass pass:openssledu

openssl req -new -sha256 -noenc -key RootCA.key -out RootCA.csr -outform PEM -config openssl.cnf -section req -verbose -verify

openssl x509 -req -sha256 -in RootCA.csr -inform PEM -signkey RootCA.key -keyform PEM -out RootCA.crt -outform PEM -extfile openssl.cnf -extensions v3_ca -days 365

openssl x509 -in RootCA.crt -text -noout

openssl verify RootCA.crt


REM (참고)개인키와 CSR을 동시에 만들려면 아래와 같이 명령 축약 가능
REM openssl req -newkey rsa:4096 -noenc -keyout RootCA.key -keyform PEM -out RootCA.csr -outform PEM -config openssl.cnf -section req -verbose -verify

REM (참고)개인키와 인증서를 동시에 만들려면 아래와 같이 명령 축약 가능
REM openssl req -newkey rsa:2048 -noenc -keyout RootCA.key -keyform PEM -x509 -sha256 -out RootCA.crt -outform PEM -days 365 -config openssl.cnf -section req -extensions v3_ca -verbose
REM ----------------------------------------------------------------------------------
