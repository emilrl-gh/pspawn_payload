# pspawn.dylib

This dylib is suppose to be injected in a binary that has a posix_spawn call in it. It uses the fishhook library to hook the function. It will each time, before you call posix_spawn, call ldid -Ksigncert.p12 -Sent.xml <i>binary-path</i>. This is suppose to be a Proof of concept of a CoreTrust "bypass". (⚠️In the main.m file you need to specify the signcert.p12, ents.xml and the ldid binary path)

## Build/Run Instructions
```
make
```
### For iOS:<br>
```
make iOS
```
### To run:<br>
```
DYLD_INSERT_LIBRARIES=pspawn_payload.dylib ./test <binary-path>
```
