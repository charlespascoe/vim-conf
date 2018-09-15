#sudo apt-get remove --purge vim vim-runtime vim-gnome vim-tiny vim-gui-common

#sudo apt-get install python3-dev libncurses5-dev
#git clone https://github.com/vim/vim
cd vim

./configure \
--enable-multibyte \
--enable-python3interp \
--with-python3-config-dir=/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu \
--enable-cscope \
--with-features=huge \
--enable-fontset \
--enable-largefile \
--disable-netbeans \
--with-compiledby="Charles Pascoe" \
--enable-fail-if-missing

make && sudo make install
