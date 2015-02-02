#!/bin/bash

echo "nameserver 8.8.8.8" >> ~/.bashrc
echo "export LS_OPTIONS='--color=auto'" >> ~/.bashrc
echo "eval \"`dircolors`\"" >> ~/.bashrc
echo "alias ls='ls $LS_OPTIONS'" >> ~/.bashrc
echo "alias ll='ls $LS_OPTIONS -l'" >> ~/.bashrc
echo "alias l='ls $LS_OPTIONS -lA'" >> ~/.bashrc

echo "export LESS_TERMCAP_mb=$'\E[01;31m'" >> ~/.bashrc
echo "export LESS_TERMCAP_md=$'\E[01;31m'" >> ~/.bashrc
echo "export LESS_TERMCAP_me=$'\E[0m'" >> ~/.bashrc
echo "export LESS_TERMCAP_se=$'\E[0m'" >> ~/.bashrc
echo "export LESS_TERMCAP_so=$'\E[01;44;33m'" >> ~/.bashrc
echo "export LESS_TERMCAP_ue=$'\E[0m'" >> ~/.bashrc
echo "export LESS_TERMCAP_us=$'\E[01;32m'" >> ~/.bashrc

echo "export PS1='\[\033[01;31m\]\u\[\033[01;33m\]@\[\033[01;36m\]\h \[\033[01;33m\]\w \[\033[01;35m\]\$ \[\033[00m\]'" >> ~/.bashrc

echo "if [ -x /usr/bin/dircolors ]; then" >> ~/.bashrc
echo "	test -r ~/.dircolors && eval \"$(dircolors -b ~/.dircolors)\" || eval \"$(dircolors -b)\"" >> ~/.bashrc
echo "	alias ls='ls --color=auto'" >> ~/.bashrc
echo "	alias dir='dir --color=auto'" >> ~/.bashrc
echo "	alias vdir='vdir --color=auto'" >> ~/.bashrc
echo "	alias grep='grep --color=auto'" >> ~/.bashrc
echo "	alias fgrep='fgrep --color=auto'" >> ~/.bashrc
echo "	alias egrep='egrep --color=auto'" >> ~/.bashrc
echo "fi" >> ~/.bashrc


