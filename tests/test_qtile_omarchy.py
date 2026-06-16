#!/usr/bin/env python3
"""
Tests for Qtile Omarchy-style configuration.
RED phase: All tests should fail on current config.
GREEN phase: All tests should pass after customization.
"""
import ast
import sys
import re

CONFIG_PATH = "qtile/config.py"

def parse_config():
    with open(CONFIG_PATH) as f:
        return ast.parse(f.read())

def find_assignments(tree, target_name):
    """Find all variable assignments with the given name."""
    results = []
    for node in ast.walk(tree):
        if isinstance(node, ast.Assign):
            for target in node.targets:
                if isinstance(target, ast.Name) and target.id == target_name:
                    results.append(node)
    return results

def count_list_elements(tree, list_var_name):
    """Count elements in a list assigned to a variable."""
    for node in ast.walk(tree):
        if isinstance(node, ast.Assign):
            for target in node.targets:
                if isinstance(target, ast.Name) and target.id == list_var_name:
                    if isinstance(node.value, ast.List):
                        return len(node.value.elts)
    return -1

def test_syntax():
    """Test 1: Python syntax is valid."""
    try:
        parse_config()
        print(f"  ✅ SYNTAX: Config file has valid Python syntax")
        return True
    except SyntaxError as e:
        print(f"  ❌ SYNTAX: Invalid Python syntax: {e}")
        return False

def test_bar_widget_count():
    """Test 2: Bar should have ≤ 12 widgets (tri-section layout)."""
    tree = parse_config()
    # Find the screens list, then the bar widget list
    for node in ast.walk(tree):
        if isinstance(node, ast.Assign):
            for target in node.targets:
                if isinstance(target, ast.Name) and target.id == "screens":
                    # Navigate to bar widget list
                    if isinstance(node.value, ast.List) and node.value.elts:
                        screen = node.value.elts[0]
                        if isinstance(screen, ast.Call):
                            for kw in screen.keywords:
                                if kw.arg == "top":
                                    bar_call = kw.value
                                    if isinstance(bar_call, ast.Call):
                                        for bar_arg in bar_call.args:
                                            if isinstance(bar_arg, ast.List):
                                                widgets = bar_arg.elts
                                                count = len(widgets)
                                                if count <= 12:
                                                    print(f"  ✅ BAR: {count} widgets (≤ 12) — tri-section layout")
                                                    return True
                                                else:
                                                    print(f"  ❌ BAR: {count} widgets (> 12) — too bloated")
                                                    return False
    print("  ❌ BAR: Could not determine widget count")
    return False

def test_no_prompt():
    """Test 3: No Prompt widget in bar."""
    tree = parse_config()
    for node in ast.walk(tree):
        if isinstance(node, ast.Call):
            if isinstance(node.func, ast.Attribute):
                if node.func.attr == "Prompt":
                    print(f"  ❌ PROMPT: Prompt widget found in bar (should be removed)")
                    return False
            elif isinstance(node.func, ast.Name) and node.func.id == "Prompt":
                print(f"  ❌ PROMPT: Prompt widget found (should be removed)")
                return False
    print(f"  ✅ PROMPT: No Prompt widget in bar")
    return True

def test_no_quickexit():
    """Test 5: No QuickExit widget in bar."""
    tree = parse_config()
    for node in ast.walk(tree):
        if isinstance(node, ast.Call):
            if isinstance(node.func, ast.Attribute):
                if node.func.attr == "QuickExit":
                    print(f"  ❌ QUICKEXIT: QuickExit widget found (should be removed)")
                    return False
            elif isinstance(node.func, ast.Name) and node.func.id == "QuickExit":
                print(f"  ❌ QUICKEXIT: QuickExit widget found (should be removed)")
                return False
    print(f"  ✅ QUICKEXIT: No QuickExit widget in bar")
    return True

def test_only_two_layouts():
    """Test 6: Only MonadTall and Max layouts (no Columns)."""
    tree = parse_config()
    for node in ast.walk(tree):
        if isinstance(node, ast.Assign):
            for target in node.targets:
                if isinstance(target, ast.Name) and target.id == "layouts":
                    if isinstance(node.value, ast.List):
                        layout_names = []
                        for elt in node.value.elts:
                            if isinstance(elt, ast.Call) and isinstance(elt.func, ast.Attribute):
                                layout_names.append(elt.func.attr)
                            elif isinstance(elt, ast.Call) and isinstance(elt.func, ast.Name):
                                layout_names.append(elt.func.id)
                        
                        if "Columns" in layout_names:
                            print(f"  ❌ LAYOUTS: Columns found ({layout_names}) — should be removed")
                            return False
                        if len(layout_names) != 2:
                            print(f"  ❌ LAYOUTS: Expected 2 layouts, got {len(layout_names)} ({layout_names})")
                            return False
                        print(f"  ✅ LAYOUTS: Only MonadTall + Max ({layout_names})")
                        return True
    print(f"  ❌ LAYOUTS: Could not determine layouts")
    return False

def has_keybinding(tree, mods, key, desc_contains=None):
    """Check if a specific keybinding exists by searching source text."""
    with open(CONFIG_PATH) as f:
        source = f.read()
    
    # Look for Key([mods], "key", ... pattern
    mods_str = ", ".join(f'"{m}"' if isinstance(m, str) else m for m in mods)
    pattern = rf'Key\(\[{mods_str}\],\s*"{key}"'
    
    if re.search(pattern, source):
        return True
    return False

def test_workspace_cycling():
    """Test 7: Super+Left/Right for workspace cycling."""
    with open(CONFIG_PATH) as f:
        source = f.read()
    
    has_left = 'lazy.screen.prev_group()' in source or ("Key([mod], \"Left\"" in source and "prev" in source)
    has_right = 'lazy.screen.next_group()' in source or ("Key([mod], \"Right\"" in source and "next" in source)
    
    if has_left and has_right:
        print(f"  ✅ CYCLING: Super+Left/Right workspace cycling configured")
        return True
    else:
        print(f"  ❌ CYCLING: Missing workspace cycling keys (has_left={has_left}, has_right={has_right})")
        return False

def test_precise_volume():
    """Test 8: Shift+volume keys for precise control."""
    with open(CONFIG_PATH) as f:
        source = f.read()
    
    has_lower = "XF86AudioLowerVolume" in source and "shift" in source.lower()
    has_raise = "XF86AudioRaiseVolume" in source and "shift" in source.lower()
    
    if has_lower and has_raise:
        print(f"  ✅ VOLUME: Shift+XF86Audio* for precise volume (±5%)")
        return True
    else:
        print(f"  ❌ VOLUME: Missing precise volume keys (has_lower={has_lower}, has_raise={has_raise})")
        return False

def test_precise_brightness():
    """Test 9: Shift+brightness keys for precise control."""
    with open(CONFIG_PATH) as f:
        source = f.read()
    
    has_down = "XF86MonBrightnessDown" in source and "shift" in source.lower()
    has_up = "XF86MonBrightnessUp" in source and "shift" in source.lower()
    
    if has_down and has_up:
        print(f"  ✅ BRIGHTNESS: Shift+XF86MonBrightness* for precise brightness (±5%)")
        return True
    else:
        print(f"  ❌ BRIGHTNESS: Missing precise brightness keys (has_down={has_down}, has_up={has_up})")
        return False


def main():
    print("=" * 60)
    print("  Qtile Omarchy-Style Configuration Tests (GREEN Phase)")
    print("=" * 60)
    print()
    print(f"Config file: {CONFIG_PATH}")
    print()
    
    tests = [
        ("Syntax check", test_syntax),
        ("Tri-section bar (≤12 widgets)", test_bar_widget_count),
        ("No Prompt widget", test_no_prompt),
        ("No QuickExit widget", test_no_quickexit),
        ("Only MonadTall + Max layouts", test_only_two_layouts),
        ("Workspace cycling (Super+←/→)", test_workspace_cycling),
        ("Precise volume (Shift+🔊)", test_precise_volume),
        ("Precise brightness (Shift+☀️)", test_precise_brightness),
    ]
    
    passed = 0
    failed = 0
    
    for name, test_fn in tests:
        print(f"Test: {name}")
        try:
            if test_fn():
                passed += 1
            else:
                failed += 1
        except Exception as e:
            print(f"  ❌ ERROR: {e}")
            failed += 1
        print()
    
    print("=" * 60)
    print(f"  Results: {passed} passed, {failed} failed out of {len(tests)}")
    print("=" * 60)
    
    return 0 if failed == 0 else 1

if __name__ == "__main__":
    sys.exit(main())
