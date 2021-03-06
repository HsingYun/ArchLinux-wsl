#! /bin/sh
echo "begin update kernel src"
cd linux/archlinux-linux
git fetch
cd ../src/archlinux-linux
git add . && git reset --hard HEAD && git checkout master && git pull
cd ../../..
mv linux linux_src
echo "begin update and export the linux pkg"
asp update linux
asp export linux
cp linux/* linux_src
rm -rf linux
mv linux_src linux
echo "begin modify the PKGBUILD and the config"
sed -i 's/pkgbase=linux$/pkgbase=linux-wsl2/' linux/PKGBUILD
sed -i 's/make all$/make all -j24/' linux/PKGBUILD
sed -i 's/make htmldocs$/echo skip build htmldocs/' linux/PKGBUILD
cp wsl/config linux/config
echo "generate checksum"
cd linux
updpkgsums
echo "begin build kernel"
makepkg -s -f

