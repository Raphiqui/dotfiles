# dotfiles

No effort setup.

## How to start

First, copy the file named `bootstrap.sh` where you like, probably under `/home/<username>/code/`.
Then give it the right permission,
chmod +× ./bootstrap.sh
After that execute the file and that will be it 😀😃🙂.

## Structure 

 - Folder containing all the configurations handled by `chezmoi`

 - bootstrap.sh file which aims to be run before anything else, this will install everything that `chezmoi` doesn't

 - run_once_*.sh script which will run right after executing `chezmoi --apply`

## WSL

### Docker 

Install docker desktop

### Clean path

The PATH variable can get messy because WSL will import a bunch of `/mnt/...` files.
To have a clean linux PATH you can update this file

```
# /etc/wsl.conf

[interop]
enabled = true
appendWindowsPath = false

```

### Backup

Backup file creates a snapshot of the specified distro.
This is so far only Windows oriented.
See how to run a cron to set it up properly.
