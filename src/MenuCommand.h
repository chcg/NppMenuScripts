#pragma once

#include <string_view>

enum class MenuCommandAction {
    RunScript,
    RunCommand,
    RunCurrentFile,
    StopScript
};

constexpr std::wstring_view RUN_CURRENT_FILE_ACTION = L"{RUN_CURRENT_FILE}";
constexpr std::wstring_view STOP_SCRIPT_ACTION = L"{STOP_SCRIPT}";

constexpr bool hasExactlyOneExecutionTarget(bool hasScript, bool hasAction)
{
    return hasScript != hasAction;
}

constexpr bool hasExactlyOneExecutionTarget(bool hasScript, bool hasAction, bool hasExecute)
{
    return static_cast<unsigned int>(hasScript) + static_cast<unsigned int>(hasAction) +
           static_cast<unsigned int>(hasExecute) == 1;
}

inline bool parseActionToken(std::wstring_view value, MenuCommandAction& action)
{
    if (value == RUN_CURRENT_FILE_ACTION) {
        action = MenuCommandAction::RunCurrentFile;
        return true;
    }
    if (value == STOP_SCRIPT_ACTION) {
        action = MenuCommandAction::StopScript;
        return true;
    }
    return false;
}
