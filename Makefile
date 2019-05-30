libzip/build/lib/libzip.a:
	cd libzip && mkdir -p build && cd build && cmake .. && make -j6

expat/expat/libexpat.a:
	export
	cd expat/expat && pwd && make -j6

xlsxio/build/libxlsxio_read.a:
	cd xlsxio/ && mkdir -p build && cd build && cmake .. && make -j6
