xlsxio-0.2.21/libxlsxio_read.a: xlsxio-0.2.21.tar.xz
	cd xlsxio-0.2.21 && cmake -G"Unix Makefiles" && make -j4

xlsxio-0.2.21.tar.xz:
	wget https://github.com/brechtsanders/xlsxio/releases/download/0.2.21/xlsxio-0.2.21.tar.xz
	tar -xvf xlsxio-0.2.21.tar.xz
