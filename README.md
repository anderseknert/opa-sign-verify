# OPA Bundle Signing

Simple demonstration of [bundle](https://www.openpolicyagent.org/docs/latest/management-bundles/)
signing and verification for [Open Policy Agent](https://www.openpolicyagent.org/) (OPA).

## Create RSA key pair

```shell
openssl genpkey -algorithm RSA -out private_key.pem -pkeyopt rsa_keygen_bits:2048
openssl rsa -pubout -in private_key.pem -out public_key.pem
```

## Create .signatures.json

```shell
opa sign --signing-key private_key.pem --bundle policy/
mv .signatures.json policy/
```

## Build bundle

```shell
opa build --bundle --verification-key public_key.pem --signing-key private_key.pem policy/
```

## Upload bundle to bundle server

Next, move bundle to bundle server. For the purpose of the example, we'll use an nginx
running locally. This is on Mac OS with nginx installed via brew — the location of the
nginx "www" directory may obviously vary.

```shell
mv bundle.tar.gz /opt/homebrew/var/www
```

## Run OPA with bundle verification config

```shell
opa run --server \
        --config-file=opa-conf.yaml \
        --set-file="keys.verifier.key=public_key.pem"
```

Make sure you see "Bundle loaded and activated successfully." in the logs.

Done!
