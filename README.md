# OPA Bundle Signing

Simple demonstration of [bundle](https://www.openpolicyagent.org/docs/latest/management-bundles/)
signing and verification for [Open Policy Agent](https://www.openpolicyagent.org/) (OPA).

## Create RSA key pair

First of all, we'll need a key pair (a private key for signing and a public key for verification):

```shell
openssl genpkey -algorithm RSA -out private_key.pem -pkeyopt rsa_keygen_bits:2048
openssl rsa -pubout -in private_key.pem -out public_key.pem
```

## Create .signatures.json

Given that we have a policy directory we'll want to create bundle from, we can now create a
`.signatures.json` file, which we'll later use for bundle verification:

```shell
opa sign --signing-key private_key.pem --bundle policy/
```
Once created, move the `.signatures.json` file into the bundle directory:
```shell
mv .signatures.json policy/
```

## Build bundle

We're now ready to build the bundle, providing both the signing key and the verification key:

```shell
opa build --bundle --signing-key private_key.pem  --verification-key public_key.pem policy/
```

## Upload bundle to bundle server

Next, move bundle to bundle server. For the purpose of the example, we'll use an nginx
server running locally. The bwloe command is on Mac OS with nginx installed via brew —
the location of the nginx "www" directory may obviously vary.

```shell
mv bundle.tar.gz /opt/homebrew/var/www
```

## Run OPA with bundle verification config

We now have a signed bundle served from our bundle server, so let's start the OPA server
with a config file pointing out its location. Note especially the use of `--set-file` to
point out the location of our public key. This is preferable over keeping keys embedded in
the configuration:

```shell
opa run --server \
        --config-file=opa-conf.yaml \
        --set-file="keys.verifier.key=public_key.pem"
```

Make sure you see "Bundle loaded and activated successfully." in the logs.

**Done!**
