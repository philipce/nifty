OS := $(shell uname)
NOW := $(shell date +"%c" | tr ' :' '__')

# compile nifty and user code together, no modules
all:
	swiftc -O -import-objc-header ./include/nifty_bridging_header.h -L./lib/$(OS) -llapacke -llapack -lopenblas -lgfortran -o ./build/$(OS)/run ./src/nifty/*.swift ./src/*.swift

# compile code as modules--for some reason this has linker errors
nifty: niftymodule
	@mkdir -p ./build/$(OS)/doc ./build/$(OS)/lib ./build/$(OS)/module
	swiftc -DNIFTY -I./build/$(OS)/module -L./build/$(OS)/lib -L./lib/$(OS) -llapacke -llapack -lrefblas -lgfortran -o ./build/$(OS)/run ./src/main.swift

niftymodule: clapack
	swiftc -DCLAPACK -emit-library -emit-object -module-name Nifty -module-link-name Nifty -I./build/$(OS)/module -L./build/$(OS)/lib -L./lib/$(OS) ./src/nifty/*.swift
	swiftc -DCLAPACK -emit-module -module-name Nifty -module-link-name Nifty -I./build/$(OS)/module -L./build/$(OS)/lib -L./lib/$(OS) ./src/nifty/*.swift
	@ar rcs libNifty.a *.o
	@rm *.o
	@mkdir -p ./build/$(OS) lib module doc
	@mv libNifty.a ./build/$(OS)/lib	
	@mv Nifty.swiftmodule ./build/$(OS)/module
	@mv Nifty.swiftdoc ./build/$(OS)/doc

clapack: ./lib/$(OS)/liblapacke.a ./lib/$(OS)/liblapack.a ./lib/$(OS)/libcblas.a ./lib/$(OS)/libopenblas.a 
	@touch dummy_$(NOW).swift
	swiftc -emit-module -module-name CLapack -import-objc-header ./include/nifty_bridging_header.h -L./lib/$(OS) -llapacke -llapack -lopenblas -lgfortran -lm dummy_$(NOW).swift
	@rm dummy_$(NOW).swift
	@mkdir -p ./build/$(OS) lib module doc
	@mv CLapack.swiftmodule ./build/$(OS)/module
	@mv CLapack.swiftdoc ./build/$(OS)/doc