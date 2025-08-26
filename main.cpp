#include <chrono>
#include <iostream>
#include <vector>
#include <string>

int main(int argc, char **argv)
{
    using namespace std;

    // Allow N via argv[1], default 5M
    int N = 5'000'000;
    if (argc >= 2)
    {
        try
        {
            int x = stoi(argv[1]);
            if (x > 0)
                N = x;
        }
        catch (...)
        { /* ignore */
        }
    }

#ifdef FAST_IO
    // Turbo mode: fast iostreams
    ios::sync_with_stdio(false);
    cin.tie(nullptr);
#endif

    vector<int> data(static_cast<size_t>(N));

    std::cout << "Expecting " << N << " integers...\n";

    auto t0 = std::chrono::high_resolution_clock::now();

    // Ingest up to N ints
    for (int i = 0; i < N; ++i)
    {
        if (!(std::cin >> data[static_cast<size_t>(i)]))
        {
            N = i;
            data.resize(static_cast<size_t>(N));
            break;
        }
    }

    for (int i = 0; i < N; ++i)
    {
        std::cout << data[static_cast<size_t>(i)] << '\n';
    }

    auto t1 = std::chrono::high_resolution_clock::now();
    auto ms = std::chrono::duration_cast<std::chrono::milliseconds>(t1 - t0).count();

    // Print timing to **stderr** so the script can capture it while stdout is /dev/null
    std::cerr << "Elapsed: " << ms << " ms\n";
    return 0;
}
// Compile with: g++ -O2 -std=c++17 -o main main.cpp
// Run with: ./main 10000000 < input.txt > /dev/null
// Optionally define FAST_IO for turbo mode: g++ -O2 -std=c++17 -DFAST_IO -o main main.cpp
// Example input generation: seq 1 10000000 > input.txt
// Note: Adjust N as needed for testing different sizes.