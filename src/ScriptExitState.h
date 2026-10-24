#pragma once

enum class ScriptExitState {
    Completed,
    Failed,
    Stopped,
    CompletedWithCustomStatus
};

constexpr ScriptExitState classifyScriptExit(unsigned long exitCode,
                                             bool stopRequested,
                                             bool customStatusSet)
{
    if (stopRequested) return ScriptExitState::Stopped;
    if (exitCode != 0) return ScriptExitState::Failed;
    return customStatusSet ? ScriptExitState::CompletedWithCustomStatus
                           : ScriptExitState::Completed;
}
