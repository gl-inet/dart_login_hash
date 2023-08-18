## Features

A package for calculating login ciphertext for GL.iNet routers



## Usage

```dart
    int alg = 1;
    String salt = "shGzEq91";
    String nonce = "SGgyhFWf3lFrIpX2BFImBjE1gv2AKPC2";

    Crypt? pw;
    switch (alg) {
        case 1:
        pw = Crypt.md5(password, salt: salt);
        break;
        case 5:
        pw = Crypt.sha256(password, salt: salt);
        break;
        case 6:
        pw = Crypt.sha512(password, salt: salt);
        break;
        default:
    }
```