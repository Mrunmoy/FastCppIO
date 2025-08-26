# FastCppIO

A simple benchmark comparing **default C++ iostreams** vs. **fast mode** with:

```cpp
ios::sync_with_stdio(false);
cin.tie(nullptr);
```

These two lines make `cin`/`cout` much faster by:
- Turning off synchronization with C stdio
- Untying `cin` from `cout` so no auto-flush occurs


## Structure

```
.
├── CMakeLists.txt         # Builds two executables
├── main.cpp               # Benchmark program
└── build.sh               # Build + run benchmark on Linux/macOS
```

The CMake setup builds:
- `io_benchmark_slow` → default iostreams
- `io_benchmark_fast` → with fast mode enabled


## Build & Run

```bash
N=1000000 BUILD_DIR=out ./scripts/build.sh
```


## Example Output

```
==> Running SLOW (default iostream)
Elapsed: 241 ms
==> Running FAST (sync_with_stdio(false); cin.tie(nullptr);)
Elapsed: 97 ms

--- Benchmark Summary ---
Slow : 241 ms
Fast : 97 ms
Improvement: 59.8% faster
Done.
```


## Notes
- The program echoes all input numbers back to stdout. The script redirects that to `/dev/null` so only the timing remains.
- Timing is printed to **stderr** inside the program so it can be captured safely.
- Works on Linux/macOS. A PowerShell script can be added for Windows.
