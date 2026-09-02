## New version
1. Set new version in `./ports/dmn/vcpkg.json`
2. Obtain proper SHA-512 hashes using the command below
```
vcpkg hash <file>
```
3. Set the hashes in `./ports/dmn/portfile.cmake`
4. Commit and push changes as `feat: vX.X.X`
5. Add the new version using the command blow
```
vcpkg x-add-version --x-builtin-ports-root=./ports --x-builtin-registry-versions-dir=./versions dmn
```
6. Commit and push changes as `feat: Added vX.X.X to versions`