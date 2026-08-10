import re
import sys

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    # Find import
    content = re.sub(r"import 'package:laci_mobile/widgets/custom_refresh_control.dart';\n", "", content)

    # We need to find `CustomScrollView(` and if it has CustomRefreshControl inside its slivers, wrap it.
    idx = 0
    while True:
        match = re.search(r'CustomScrollView\s*\(', content[idx:])
        if not match:
            break
        
        start_idx = idx + match.start()
        # Find closing parenthesis
        paren_count = 0
        in_string = False
        escape = False
        end_idx = -1
        
        for i in range(start_idx + len('CustomScrollView(') - 1, len(content)):
            char = content[i]
            if char == '\\' and in_string:
                escape = not escape
                continue
                
            if char in ("'", '"') and not escape:
                # simplify string handling for this specific codebase
                in_string = not in_string
                
            escape = False
            
            if not in_string:
                if char == '(':
                    paren_count += 1
                elif char == ')':
                    paren_count -= 1
                    if paren_count == 0:
                        end_idx = i
                        break
        
        if end_idx == -1:
            idx = start_idx + 1
            continue
            
        custom_scroll_view_body = content[start_idx:end_idx+1]
        
        # Check if it has CustomRefreshControl
        refresh_match = re.search(r'CustomRefreshControl\(\s*onRefresh:\s*([a-zA-Z0-9_().]+)\s*(?:,\s*primaryColor:\s*([a-zA-Z0-9_().]+))?[^)]*\),?\s*', custom_scroll_view_body)
        
        if refresh_match:
            on_refresh = refresh_match.group(1)
            color_arg = refresh_match.group(2)
            
            color_str = f"color: {color_arg}," if color_arg else ""
            
            # Remove CustomRefreshControl from slivers
            new_body = custom_scroll_view_body[:refresh_match.start()] + custom_scroll_view_body[refresh_match.end():]
            
            # Replace BouncingScrollPhysics with AlwaysScrollableScrollPhysics
            new_body = new_body.replace('BouncingScrollPhysics()', 'AlwaysScrollableScrollPhysics()')
            
            # Wrap with RefreshIndicator
            wrapped = f"RefreshIndicator(\n  onRefresh: {on_refresh},\n  {color_str}\n  child: {new_body},\n)"
            
            content = content[:start_idx] + wrapped + content[end_idx+1:]
            
            # Move index past the wrapped block
            idx = start_idx + len(wrapped)
        else:
            idx = start_idx + 1

    with open(filepath, 'w') as f:
        f.write(content)
    print(f"Processed {filepath}")

files = [
    "lib/screens/home_screen.dart",
    "lib/screens/aktivitas/riwayat_aktivitas_screen.dart",
    "lib/screens/periode/periode_screen.dart",
    "lib/screens/aktivitas/detail_riwayat_aktivitas_screen.dart",
    "lib/screens/profile_screen.dart",
    "lib/screens/pengguna/pengguna_screen.dart",
    "lib/screens/pengguna/detail_pengguna_screen.dart"
]

for f in files:
    process_file(f)
