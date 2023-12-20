@echo 0 ----- set pass ----- 
@echo 1 ----- delete existing file ----- 
@echo 2 ----- generate server key -----
@echo 3 ----- generate CSR -----
@echo 4 ----- generator Certificate with CA Key & Cert -----
@echo 5 ----- display server Certificate -----
@echo 6 ----- display server Certificate ----- 

set pass=openssledu

del /q openssl.asianaidt.com.* 

openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -out openssl.asianaidt.com.key -outform PEM -pass pass:%PASS%

openssl req -new -sha256 -noenc -key openssl.asianaidt.com.key -out openssl.asianaidt.com.csr -outform PEM -config openssl.cnf -section req -verbose -verify

openssl x509 -req -sha256 -in openssl.asianaidt.com.csr -inform PEM -CA ./RootCA/RootCA.crt -CAform PEM -CAkey ./RootCA/RootCA.key -CAkeyform PEM -CAcreateserial -out openssl.asianaidt.com.crt -outform PEM -extfile openssl.cnf -extensions v3_req -days 365

openssl x509 -in openssl.asianaidt.com.crt -text -noout

openssl verify -CAfile ./RootCA/RootCA.crt -show_chain -verbose openssl.asianaidt.com.crt