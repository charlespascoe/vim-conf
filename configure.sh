#sudo apt-get remove --purge vim vim-runtime vim-gnome vim-tiny vim-gui-common

sudo apt-get install python-dev python3-dev libncurses5-dev
#git clone https://github.com/vim/vim

./configure \
--enable-multibyte \
--enable-pythoninterp=dynamic \
--enable-python3interp \
--enable-cscope \
--with-features=huge \
--enable-fontset \
--enable-largefile \
--disable-netbeans \
--with-compiledby="Charles Pascoe" \
--enable-fail-if-missing
#--with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
#--with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu \

#make && sudo make install
