//
//  Engine.cpp
//  CacomiTestApp
//
//  Out-of-line definition for audio::Engine::shutdown, never called.
//

#include "Engine.hpp"

namespace audio {

// CACOMI-EXPECT[UnusedCode|low]: out-of-line method definition with no callers
void Engine::shutdown() {
    // intentionally empty
}

} // namespace audio
