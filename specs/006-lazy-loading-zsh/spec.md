# Feature Specification: Lazy Loading for Zsh

**Feature Branch**: `006-lazy-loading-zsh`  
**Created**: 2026-02-11  
**Status**: Draft  
**Input**: User requirement: Implement lazy loading for zsh plugins to optimize shell startup time

## User Scenarios & Testing

### User Story 1 - Lazy Load Heavy Plugins (Priority: P1)

Developers experience slow zsh startup times due to plugins that load on every shell initialization. Some plugins (like autosuggestions, syntax highlighting, fuzzy finders) perform expensive initialization that blocks shell prompt appearance. These should load only when first used, dramatically improving startup time.

**Why this priority**: P1 - Direct user experience impact. Fast shell startup is critical for developers switching between terminal windows/tabs frequently.

**Independent Test**: Can be fully tested by measuring zsh startup time before/after implementation and verifying all commands work correctly after lazy loading them.

**Acceptance Scenarios**:

1. **Given** zsh launches with heavy plugins loaded, **When** lazy loading implemented, **Then** shell prompt appears in <500ms (currently >2s with plugins).
2. **Given** lazy loading enabled, **When** user types a command that needs plugin functionality, **Then** plugin loads transparently and command executes correctly.
3. **Given** lazy loading enabled, **When** user spawns multiple shells rapidly, **Then** each loads with consistent fast startup time.

---

### User Story 2 - Lazy Load Plugin on First Use (Priority: P1)

Plugins should load transparently on first invocation of their functionality, not on shell startup. User should perceive no delay - the plugin activation should happen in background while command executes.

**Why this priority**: P1 - Core feature. Without transparent lazy loading, experience is degraded.

**Independent Test**: Can be tested by running `time zsh -i -c exit` before and after, and verifying plugin functionality works on first use without errors.

**Acceptance Scenarios**:

1. **Given** lazy-loaded plugin never used, **When** shell closes, **Then** plugin was never loaded (verified by checking load state).
2. **Given** lazy-loaded plugin never used in session, **When** zsh startup measured, **Then** fast startup persists (plugin not loaded).
3. **Given** user calls command using lazy-loaded plugin for first time, **When** command executes, **Then** plugin loads and command works correctly.

---

### User Story 3 - Conditional Loading Based on Commands (Priority: P2)

Some plugins only needed for specific tools/commands (e.g., fzf integration loads only when fzf is used, docker completion only if docker binary exists). Lazy loading should be intelligent about dependencies.

**Why this priority**: P2 - Optimization. Improves startup further by not loading unneeded features.

**Independent Test**: Can be tested by verifying plugins not needed on a clean system don't load, reducing startup time further.

**Acceptance Scenarios**:

1. **Given** system without docker installed, **When** zsh starts, **Then** docker completion plugin is never loaded.
2. **Given** system with fzf available, **When** user first uses fzf keybindings, **Then** fzf plugin loads transparently.
3. **Given** optional dependency unavailable, **When** plugin checks, **Then** gracefully skips loading with no error.

---

### Edge Cases

- What happens if lazy-loaded plugin fails to load? (Should not block shell)
- How should dependent plugins be ordered? (Plugin A needs B loaded first)
- What if user manually sources plugin config before lazy loader? (Should detect and skip)
- How to debug which plugins are lazy-loaded vs eager? (Need diagnostic mode)
- What if plugin modifies prompt? (Should not cause display glitches when lazy loading)

## Requirements

### Functional Requirements

- **FR-001**: Must identify which Oh My Zsh plugins are safe to lazy load (heavy plugins: autosuggestions, syntax-highlighting, fzf, history-substring-search)
- **FR-002**: Must implement wrapper/loader mechanism that defers plugin sourcing until first invocation
- **FR-003**: Must detect when plugin is first needed and load transparently without user interaction
- **FR-004**: Must handle plugins with dependencies (e.g., fzf-tab requires fzf-history-search-multi-word)
- **FR-005**: Must preserve all plugin functionality after lazy loading (no degraded behavior)
- **FR-006**: Must provide diagnostic mode to show which plugins are loaded/lazy-loaded via `zsh_debug_plugins` or similar command
- **FR-007**: Must measure and document startup time improvement (target: reduce from ~2s to <500ms)
- **FR-008**: Must work with both macOS (Darwin) and Ubuntu (Linux) versions of plugins
- **FR-009**: Must gracefully handle plugin load failures without crashing shell
- **FR-010**: Must not interfere with manual plugin sourcing or customizations

### Non-Functional Requirements

- **NFR-001**: Lazy loading mechanism should add <50ms overhead (minimal launcher cost)
- **NFR-002**: Lazy-loaded plugins should appear loaded instantly on first use (<100ms delay)
- **NFR-003**: Code should be maintainable and documented for future plugin additions
- **NFR-004**: Implementation should not require plugin authors to modify their code
- **NFR-005**: Should work with Oh My Zsh plugin format (standard)

### Key Entities

- **Plugin**: Oh My Zsh plugin that can be lazy-loaded or eager-loaded
- **Plugin Loader/Launcher**: Mechanism that wraps plugin sourcing with lazy loading logic
- **Hook/Trigger**: Command or keybinding that triggers plugin loading
- **Dependency Graph**: Relationships between plugins (which must load before others)

## Success Criteria

1. ✅ Zsh startup time reduced to <500ms (from current ~2s+)
2. ✅ At least 5 heavy plugins identified and made lazy-loadable
3. ✅ All lazy-loaded plugins work correctly on first use
4. ✅ No lost functionality or visual glitches from lazy loading
5. ✅ Diagnostic command available to verify lazy loading state
6. ✅ Documentation/README updated with lazy loading explanation
7. ✅ Works cross-platform (macOS and Ubuntu tested)
8. ✅ Implementation is maintainable for future modifications

## Implementation Considerations

### Candidates for Lazy Loading

These heavy plugins are typically safe to lazy load:

| Plugin | Load Time | Triggers | Risk Level |
|--------|-----------|----------|-----------|
| zsh-autosuggestions | ~200ms | First keystroke | Low |
| zsh-syntax-highlighting | ~150ms | First keystroke | Low |
| fzf (oh-my-zsh) | ~100ms | Ctrl+R, Ctrl+T | Low |
| history-substring-search | ~50ms | Arrow keys | Medium |
| zsh-completions | ~100ms | TAB | Medium |

### Implementation Approaches

1. **Manual Wrapper Functions** (Low complexity, maintainable)
   - Create function that loads plugin on first call
   - Use `alias` or function override for common commands
   
2. **Plugin Manager Extension** (Medium complexity)
   - If using zinit/zplug, use built-in lazy loading
   - If using Oh My Zsh, create custom loader

3. **Deferred Sourcing** (High complexity)
   - Use `autoload -U` with custom module system
   - Intercept shell commands to trigger loading

**Recommended**: Manual wrapper approach - simple, transparent, no external dependencies

## Notes

- Current zsh startup time measured at ~2-3 seconds with all plugins
- Target improvement: 75-80% reduction in startup time
- User has Powerlevel10k which loads early - not a candidate for lazy loading
- Consider impact on interactive features (completions, keybindings)
- Documentation should include "Performance Impact" section in README
