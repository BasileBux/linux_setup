# Linux setup

This is my setup script to install a linux machine with all my config and softwares I like with low effort. (I know NixOs exists)

I was inspired by [Omakub](https://omakub.org/) to do this with my own setup.

> [!WARNING]
> Running shell scripts you don't know is dangerous! All the scripts are commented so they are easier to audit. Don't trust me and read through the file before installing!

# Features

The setup

# Installation

- Install [Fedora Workstation](https://fedoraproject.org/workstation/) (Gnome DE is really important)
- If you have write access to the dotfiles repo, add the ssh key from your new system to your github account.

Run this command in the terminal:

```bash
curl -sSL https://raw.githubusercontent.com/BasileBux/linux_setup/refs/heads/main/install.sh >  ~/install.sh
bash ~/install.sh
```

You will have to answer some questions and configure oh-my-zsh manually. For the oh-my-zsh part, it will run the shell after the questions. Just execute

```bash
exit
```

To continue the installation!
