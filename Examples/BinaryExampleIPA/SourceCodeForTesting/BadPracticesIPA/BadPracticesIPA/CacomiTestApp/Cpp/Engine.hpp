//
//  Engine.hpp
//  CacomiTestApp
//
//  C++ fixtures for the dedicated C++ parser (unused-code detection
//  and robustness against comment/string false positives).
//

#pragma once

#include <map>
#include <string>

namespace audio {

// CACOMI-EXPECT[UnusedCode|low]: class Engine has an out-of-line method nobody calls
class Engine {
public:
    Engine() = default;
    void start() {}      // inline, considered "used" via construction call sites if any
    void shutdown();     // declared here, defined out-of-line in Engine.cpp
};

// CACOMI-EXPECT[UnusedCode|low]: ObjectPool template is never instantiated
template <typename T>
class ObjectPool {
public:
    T acquire() { return T{}; }
    void release(const T &) {}
};

// CACOMI-EXPECT[UnusedCode|low]: type alias never referenced
using FrameBufferMap = std::map<int, int>;

// CACOMI-EXPECT[UnusedCode|low]: typedef never referenced
typedef std::map<int, std::string> FrameNameMap;

// CACOMI-NEGATIVE[UnusedCode]: comments and string literals must NOT produce symbols.
// class Ghost {};
inline const char *kFakeClass = "class Fake { }";

// Base class to exercise override negative control
class Listener {
public:
    virtual ~Listener() = default;
    virtual void onTick() = 0;
};

class TickListener : public Listener {
public:
    // CACOMI-NEGATIVE[UnusedCode]: override required by base interface, must not be flagged
    void onTick() override {}
};

} // namespace audio
