UNAME := $(shell uname)
NOW := $(shell date +"%c" | tr ' :' '__')

all:
	swiftc -O -import-objc-header ./include/nifty_bridging_header.h -L./lib/$(UNAME) -llapacke -llapack -lopenblas -lgfortran -lpthread -o ./build/$(UNAME)/run ./src/nifty/*.swift ./src/*.swift

modular: 
	swiftc -emit-library -emit-object -module-name Nifty -module-link-name Nifty -import-objc-header ./include/nifty_bridging_header.h ./src/nifty/*.swift 
	swiftc -emit-module -module-name Nifty -module-link-name Nifty -import-objc-header ./include/nifty_bridging_header.h ./src/nifty/*.swift 
	@ar rcs libNifty.a *.o
	@rm *.o
	@mkdir -p ./build/$(UNAME)
	@mv libNifty.a Nifty.swiftmodule Nifty.swiftdoc ./build/$(UNAME)
	swiftc -DMODULAR -I./build/$(UNAME) -L./build/$(UNAME) -L./lib/$(UNAME) -llapacke -llapack -lrefblas -lgfortran -o ./build/$(UNAME)/run ./src/*.swift 


