echo 1 ----- 기존 파일 일괄 삭제 ----- 
echo 2 ----- 서버 키 생성 -----
echo 3 ----- CSR 생성 -----
echo 4 ----- 루트 키/인증서로 서명된 인증서 생성 -----
echo 5 ----- 인증서 정보 확인하기 -----
echo 6 ----- 인증서 검증 ----- 


del /q keystore.p12 openssl.asianaidt.com.* 

openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -out openssl.asianaidt.com.key -outform PEM -pass pass:openssledu

openssl req -new -sha256 -noenc -key openssl.asianaidt.com.key -out openssl.asianaidt.com.csr -outform PEM -config openssl.cnf -section req -verbose -verify

openssl x509 -req -sha256 -in openssl.asianaidt.com.csr -inform PEM -CA ./RootCA/RootCA.crt -CAform PEM -CAkey ./RootCA/RootCA.key -CAkeyform PEM -CAcreateserial -out openssl.asianaidt.com.crt -outform PEM -extfile openssl.cnf -extensions v3_req -days 365

openssl x509 -in openssl.asianaidt.com.crt -text -noout

openssl verify -CAfile ../RootCA/RootCA.crt -show_chain -verbose openssl.asianaidt.com.crt