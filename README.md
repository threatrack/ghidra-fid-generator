# Ghidra FidDb generator

## How do I use it?

**Pre-requisites:**

- Set `GHIDRA_HOME` env var to your Ghidra installation, e.g. via `export GHIDRA_HOME=/home/user/ghidra/ghidra_9.0.4`
- Set `GHIDRA_PROJ` env var to your Ghidra project directory, e.g. via `export GHIDRA_PROJ=/home/user/ghidra_projects`
- **Must use `ghidra-9.1-DEV` or later** due to a bug in X86_64 relocation handling (<https://github.com/NationalSecurityAgency/ghidra/pull/910>)

Only tested with CentOS 7. Requires:
- wget
- grep
- sed
- sort
- gzip
- 7z
- find
- rpm2cpio
- cpio
- unzip
- tar
- ar
- tee
- (maybe others; please open an issue if you have problems)

Everything should be already installed (even on a minimal install) except:
```
yum install epel-release
yum install p7zip p7zip-plugins
```

To generate `fidb/el7-x86.LE.32.default.fidb` and `fidb/el7-x86:LE:64:default` run:

```
./00-el-get-rpms.sh
./01-el-unpack-all-rpms.sh
./02-unpack-libs.sh lib/el7
./03-ghidra-import.sh lib/el7
./04-checklog.sh lib/el7
./05-ghidra-fidb.sh lib/el7
```

To generate additionally `fidb/el6-x86.LE.32.default.fidb` and `fidb/el6-x86:LE:64:default` you only need to run:

```
./02-unpack-libs.sh lib/el6
./03-ghidra-import.sh lib/el6
./04-checklog.sh lib/el6
./05-ghidra-fidb.sh lib/el6
```

You can manually add analysis to the `lib-fidb` Ghidra project. Then to regenerate
the new `fidb/el7-x86.LE.32.default.fidb` and `fidb/el7-x86:LE:64:default` you run:

```
rm fidb/el7-*.fidb
./05-ghidra-fidb.sh lib/el7
```

## How does this work?

- `00-el-get-rpms.sh`: Downloads RPMs from `http://mirror.centos.org/centos/` into folder `rpms`
- `01-el-unpack-all-rpms.sh`: Unpacks all the RPMs from `rpms` to `lib/el{6,7}.{i686,x86_64}/libname/version/release/*.o` (calls `01-unpack-rpm.sh`)
- `02-unpack-libs.sh <library>: Unpack `.lib` files to `.o` files.
- `03-ghidra-import.sh <library>`: Import (and analyze) from folder `<library>` into Ghidra project `lib-fidb`.
- `04-checklog.sh <library>`: Check the analysis log **and genrate `lib/library-langids.txt`**. **Generating `library-langids.txt` is important!**
- `05-ghidra-fidb.sh <library>`: Generates `.fidb` files (**one for each Language ID in `lib/library-langids.txt`**) into `fidb/` with signatures for the libraries in `<library>` folder

## How can I manually add libraries?

Add your `.lib` files into the `lib` folder as follows:

```
+-- lib
|   |-- provider-name
|   |   |-- library-name
|   |   |   `-- version
|   |   |       `-- variant
|   |   |           |-- lib1.a
|   |   |           `-- lib2.lib
```

- `provider-name`: The name of the provider of the libraries. This will also be the filename of the generated `.fidb` files.
- `library-name`: The name of the library.
- `version`: Version.
- `variant`: Variant or release string.

To extract the `.a` and/or `.lib` files run `./02-unpack-libs.sh lib/provider-name`.

After this the folders should be:

```
+-- lib
|   |-- provider-name
|   |   |-- library-name
|   |   |   `-- version
|   |   |       `-- variant
|   |   |           |-- lib1
|   |   |           |   |-- foo.o
|   |   |           |   `-- bar.o
|   |   |           `-- lib2
|   |   |           |   |-- this.obj
|   |   |           |   `-- that.obj
```

(You can also a `.o` files directly.

Then run `./03-ghidra-import.sh lib/provider-name` to import this folder structure into the Ghidra project `lib-fidb`.
After the import run `./04-checklog.sh lib/provider-name` this will read the `lib/provider-name-headless.log` file written during `03-ghidra-import.sh`
and generate `lib/provider-name-langids.txt` from it. `lib/provider-name-langids.txt` is used by `05-ghidra-fidb.sh` to know for which processor architectures
Function ID datasets should be generated.

Last run `./05-ghidra-fidb.sh lib/provider-name` to generate `fidb/provider-name-PROC.ENDIAN.SIZE.VARIANT.fidb`.

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

### Stats

Here are the stats for (some) of the Function ID datasets in <https://github.com/threatrack/ghidra-fidb-repo>:

| `.fidb`         | # `.o` | du `.o` | `02-ghidra-import.sh` | du `.gpr` | `03-ghidra-fidb.sh` | du `.fidb` | # Entries  |
|-----------------|--------|---------|-----------------------|-----------|---------------------|------------|------------|
| el7.x86_64.fidb | 13036  | 195M    | ~ 4h                  | ~ 16GB    | ~ 15min             | 6.6M       | 57966      |
| el7.i686.fidb   | 12600  | 132M    | ~ 8h                  | ~ 16GB    | ~ 26min             | 6.6M       | 53823      |
| el6.x86_64.fidb |  5695  | 53M     | ~ 3h                  | ~  8GB    | ~  3min             | 2.2M       | 16912      |
| el6.i686.fidb   |  5709  | 45M     | ~ 2h                  | ~  8GB    | ~  4min             | 2.5M       | 21612      |

(These are only ballpark figures, as the measurements may have been impacted by
thermal throttling or concurrent tasks running on the system.)

## Known issues

### Program has different compiler spec than already established

In case you received an error like (when running `05-ghidra-fidb.sh`):

```
ERROR REPORT SCRIPT ERROR:  /home/user/github/threatrack/ghidra-fid-generator/ghidra_scripts/AutoCreateMultipleLibraries.java : Program x86_64cpuid.o has different compiler spec (windows) than already established (gcc) (HeadlessAnalyzer) java.lang.IllegalArgumentException: Program x86_64cpuid.o has different compiler spec (windows) than already established (gcc)
```

You can fix it by going into Ghidra and in the project view right clicking (in this case `x86_64cpuid.o`) and change its `Language` to `gcc` (or what ever the error complains it should be).
You can use `ghidra_scripts/SearchFalseCspecsInPrograms.py` to search for programs in a project that do not match a desired compiler spec.

The cause of this problem seems to be that Ghidra on import identified the compiler wrongly and then on generating the .fidb complains about it.

## TODO

- De-duplicate .o files. Going from one minor version to the next some .o files in a package don't change at all. Analyzing the same file multiple times wastes time.
- Re-do `el{6,7}` with new system.
- Extend `ghidra_scripts/SearchFalseCspecsInPrograms.py` to automatically change the Compiler ID and not just find the offending programs.

