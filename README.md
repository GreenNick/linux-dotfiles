# linux-dotfiles
## Getting Started
Define the `config` alias in the current shell environment
```
alias config='/usr/bin/git --git-dir=$HOME/Git/.dotfiles/ --work-tree=$HOME'
```

Clone the files into a bare git repository
```
git clone --bare https://github.com/GreenNick/linux-dotfiles.git $HOME/Git/.dotfiles
```

Checkout the main branch
```
config checkout
```
