HAREPATH=/usr/src/hare/stdlib/:/usr/src/hare/third-party/:vendor/:./vendor

stamp: stamp.ha
	@hare build -v -lm -Lvendor/libschrift -lschrift
