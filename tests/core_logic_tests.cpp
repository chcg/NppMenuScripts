#include "../src/MenuCommand.h"
#include "../src/ScriptExitState.h"

#include <cassert>

int main()
{
    assert(classifyScriptExit(0, false, false) == ScriptExitState::Completed);
    assert(classifyScriptExit(0, false, true) == ScriptExitState::CompletedWithCustomStatus);
    assert(classifyScriptExit(1, false, false) == ScriptExitState::Failed);
    assert(classifyScriptExit(0, true, false) == ScriptExitState::Stopped);
    assert(classifyScriptExit(1, true, false) == ScriptExitState::Stopped);
    assert(classifyScriptExit(0, true, true) == ScriptExitState::Stopped);

    assert(hasExactlyOneExecutionTarget(true, false));
    assert(hasExactlyOneExecutionTarget(false, true));
    assert(!hasExactlyOneExecutionTarget(false, false));
    assert(!hasExactlyOneExecutionTarget(true, true));
    MenuCommandAction action{};
    assert(parseActionToken(L"{RUN_CURRENT_FILE}", action));
    assert(action == MenuCommandAction::RunCurrentFile);
    assert(parseActionToken(L"{STOP_SCRIPT}", action));
    assert(action == MenuCommandAction::StopScript);
    assert(!parseActionToken(L"{CURRENT_FILE}", action));
    assert(!parseActionToken(L"{UNKNOWN}", action));
}
