# Ghidra EL FidDb generator


## How do I use it?

**Pre-requisites:**

- Set `GHIDRA_HOME` env var to your Ghidra installation, e.g. via `export GHIDRA_HOME=/home/user/ghidra/ghidra_9.0.4`
- Set `GHIDRA_PROJ` env var to your Ghidra project directory, e.g. via `export GHIDRA_PROJ=/home/user/ghidra-proj`
- **Must use `ghidra-9.1-DEV` or later** due to a bug in X86_64 relocation handling (<https://github.com/NationalSecurityAgency/ghidra/pull/910>)

To generate `fidb/el7.i686.fidb` run:

```
./00-get-el7-rpms.sh
./01-unpack-all-rpm.sh
./02-ghidra-import.sh el/el7.i686
./03-ghidra-fidb.sh el/el7.i686
```

To generate additionally `fidb/el7.x86_64.fidb` you only need to run:

```
./02-ghidra-import.sh el/el7.x86_64                                                
./03-ghidra-fidb.sh el/el7.x86_64
```

You can manually add analysis to the `el-fiddb` Ghidra project. Then to regenerate
the new `fidb/el7.x86_64.fidb` you run:

```
rm fidb/el7.x86_64.fidb
./03-ghidra-fidb.sh el/el7.x86_64
```

## How does this work?

- `00-get-el7-rpms.sh`: Downloads RPMs from `http://mirror.centos.org/centos/` into folder `rpms`
- `01-unpack-all-rpm.sh`: Unpacks all the RPMs from `rpms` to `el/el{6,7}.{i686,x86_64}/libname/version/release/*.o` (calls `01-unpack-rpm.sh`)
- `01-unpack-rpm.sh <rpm>`: Unpacks a **single** RPM to `el/el{6,7}.{i686,x86_64}/libname/version/release/*.o`
- `02-ghidra-import.sh <osarch>`: Import (and analyze) from folder `<osarch>` into Ghidra project `el-fiddb`.
- `03-ghidra-fidb.sh <osarch>`: Generates a `.fidb` file in `fidb/` with signatures for the libraries in `<osarch>` folder

## Can I just download the .fidb files?

Yes: <https://github.com/threatrack/ghidra-fidb-repo>

## How much disk space and time will this take?

As an example, look at [el7.x86_64.fidb](https://github.com/threatrack/ghidra-fidb-repo/blob/master/el7.x86_64.fidb). It includes:

- `boost-static/1.53.0/27.el7.x86_64`
- `glibc-static/2.17/260.el7_6.3.x86_64`
- `glibc-static/2.17/260.el7_6.6.x86_64`
- `glibc-static/2.17/260.el7.x86_64`
- `glibc-static/2.17/292.el7.x86_64`
- `libgo-static/4.8.5/36.el7_6.1.x86_64`
- `libgo-static/4.8.5/36.el7.x86_64`
- `libstdc++-static/4.8.5/36.el7.x86_64`
- `lua-static/5.1.4/15.el7.x86_64`
- `openssl-static/1.0.2k/16.el7_6.1.x86_64`
- `openssl-static/1.0.2k/16.el7.x86_64`
- `openssl-static/1.0.2k/19.el7.x86_64`
- `protobuf-lite-static/2.5.0/8.el7.x86_64`
- `protobuf-static/2.5.0/8.el7.x86_64`
- `zlib-static/1.2.7/18.el7.x86_64`

The object files in `el/el7.x86_64` were 192MB.
The resulting Ghidra project after running `02-ghidra-import.sh` (which took 4h on a i5-2520M) was 16GB.
Running `03-ghidra-fidb.sh` (which took 15min) resulted in a 6.6MB `fidb/el7.x86_64.fidb` file.
Using `RepackFid.java` the final size is 5.9M.

## TODO

- Adjust this to handle other sources of static libraries:
	- <https://www.npcglib.org/~stathis/blog/precompiled-openssl/>
- Add `common.txt` to not generate signatures for unrelated functions
	- e.g. via `cat /usr/include/openssl/* | grep -o "[A-Za-z_][A-Za-z_0-9]*" | sort -u > common.txt`
	- TODO: How could this be automated? Download ``package-{static,devel}` then grep all `.h` file in `package-devel`?


