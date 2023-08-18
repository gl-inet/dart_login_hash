# example

A demo for GL.iNet login and get status

# pubspec.yaml

dependencies:
  dio: any
  crypto: any
  gl_crypt:
    git:
      url: https://github.com/gl-inet/gl_crypt_dart.git

## Usage

```dart
    final String url = 'http://192.168.10.1/rpc';
    final String username = 'root';
    final String password = 'goodlife12';

    // Step1: Get encryption parameters by challenge method
    Dio().post(
        url,
        data: {
        'jsonrpc': '2.0',
        'method': 'challenge',
        'params': {
            'username': username,
        }
      },
    ).then(
        (value) {
        Map result = jsonDecode(value.data)['result'];
        int alg = result['alg'];
        String salt = result['salt'];
        String nonce = result['nonce'];

        // Step2: Generate cipher text using Crypt
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
        // Step3: Generate hash values for login
        String hash =
            md5.convert(utf8.encode('$username:$pw:$nonce')).toString();

        // Step4: Get sid by login
        Dio().post(
            url,
            data: {
            'jsonrpc': '2.0',
            'method': 'login',
            'params': {
              'username': username,
              'hash': hash,
            }
          },
        ).then(
            (value) {
            Map result = jsonDecode(value.data)['result'];
            String sid = result['sid'];

            // Step5: Calling other APIs with sid
            Dio().post(
                url,
                data: {
                'jsonrpc': '2.0',
                'method': 'call',
                'params': [
                    sid,
                    'system',
                    'get_status',
                ]
              },
            ).then(
                (value) {
                Map result = jsonDecode(value.data)['result'];
                setState(() {
                    status = result;
                });
                print(result);
              },
            );
          },
        );
      },
    );
```