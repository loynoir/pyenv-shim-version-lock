# Brief
A `pyenv` plugin, to make package cli, at runtime, using **SAME** python version when you **install** it.

# Install
```sh
$ git clone \
    https://github.com/loynoir/pyenv-shim-version-lock.git \
    $(pyenv root)/plugins/pyenv-shim-version-lock
```

# Usage
Here is an exmaple using with [pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv)
```sh
$ env \
    PYENV_SHIM_VERSION_LOCK=y \
    PYENV_VERSION=2.7.10/envs/some-outdated-cli \
    pip install some-outdated-cli
```

```sh
# some-outdated-cli will auto under 2.7.10
$ some-outdated-cli --help
```

# Pain Point
```sh
$ env \
    PYENV_VERSION=2.7.10/envs/some-outdated-cli \
    pip install some-outdated-cli
```

```sh
$ export PYENV_VERSION=2.7.10/envs/some-outdated-cli
$ some-outdated-clisome-outdated-cli --help
```
Everytime call it, need to somehow setup environment.

# License
MIT.
