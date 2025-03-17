# dotfiles

Basically a no effort setup.

## Structure 

 - A setup.sh file which aims to be run fisrt, this will install everything that `chezmoi` doesn't

 - dot_config folder which is handled by chezmoi and applies a bunch of already written configurations

## WSL

### Docker 

Install docker desktop

### Clean path

The PATH variable can get messy because WSL wll import a bunch of /mnt/... so if you don't want that and have a clean linux PATH you can update this file

```/etc/wsl.conf
[interop]
enabled = true
appendWindowsPath = false
```
