# Module Audit Workflow

You are performing a comprehensive audit of the modular dotfiles structure. Follow this workflow step by step.

## Step 1: Structure Analysis

Analyze the current modular organization:
- `cli/` - Command line tools
- `dev/` - Development tools and languages
- `fun/` - Fun utilities and entertainment
- `system/` - System and network tools
- `shell/` - Shell configuration and tools

## Step 2: Module Health Check

For each module, verify:
1. **File Structure**: Are files properly organized?
2. **Dependencies**: Are all dependencies correctly declared?
3. **Configuration**: Are configurations optimal?
4. **Aliases**: Are aliases consistent and useful?
5. **Documentation**: Are modules self-documenting?

## Step 3: Cross-Module Dependencies

Check for:
- Duplicate functionality across modules
- Missing integrations between related tools
- Inconsistent naming conventions
- Unused or orphaned configurations

## Step 4: Performance Review

Evaluate:
- Module loading times
- Memory usage patterns
- Startup performance impact
- Configuration complexity

## Step 5: Recommendations

Provide specific recommendations for:
- Module consolidation or splitting
- New modules that should be created
- Modules that could be removed
- Configuration optimizations
- Documentation improvements

## Expected Output

1. **Health Score**: Rate each module (1-10)
2. **Issues Found**: List specific problems
3. **Optimizations**: Suggest improvements
4. **Action Items**: Prioritized list of changes
5. **Future Planning**: Long-term recommendations 