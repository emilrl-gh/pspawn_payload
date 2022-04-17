all:macos

ios: main.m
	xcrun -sdk iphoneos cc -miphoneos-version-min=14.0 -arch arm64e -arch arm64 -dynamiclib main.m -include fishhook.h fishhook.c -framework Foundation -o pspawn_payload.dylib
	xcrun -sdk iphoneos cc -miphoneos-version-min=14.0 -arch arm64 test.c -o test

macos: main.m
	xcrun cc -arch arm64e -dynamiclib main.m -include fishhook.h fishhook.c -framework Foundation -o pspawn_payload.dylib
	gcc test.c -o test

clean:
	rm -rf pspawn_payload.dylib fishhook.o main.o test
.PHONY: all ios macos clean
