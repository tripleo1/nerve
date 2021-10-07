+++
title = "GPG2 Keys cheatsheet"
date = "2018-11-20T14:35:26Z"
draft = false

+++

# Creating GPG Key

```
gpg2 --full-gen-key
```

# Export private key

```
gpg2 --export-secret-keys --armor jqdoe@example.com > jqdoe-privkey.asc
```

# Export public key

```
gpg2 --export --armor jqdoe@example.com > jqdoe-pubkey.asc
```

# Export trustdb

```
gpg2 --export-ownertrust > otrust.txt
```

# Import trustdb

```
gpg2 --import-ownertrust < otrust.txt
```

# Update trustdb

```
gpg2 --update-trustdb
```

# Import GPG keys

```
gpg2 --import < keys.asc
```

